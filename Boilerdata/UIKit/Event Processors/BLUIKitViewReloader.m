//
//  BLUIKitViewReloader.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 10/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUIKitViewReloader.h"
#import "BLUITableViewReloaderEngine.h"
#import "BLUICollectionViewReloaderEngine.h"
#import "BLDataEvent.h"
#import "BLDataDiff.h"
#import "BLMutableDataDiff.h"
#import "BLUtils.h"
#import "NSIndexPath+BLUtils.h"

@interface BLUIKitViewReloader ()

@property (nonatomic, readonly) id<BLUIKitViewReloaderEngine> engine;

@end


@implementation BLUIKitViewReloader

#pragma mark - Init

- (instancetype)init {
    return [self initWithEngine:nil];
}

- (instancetype)initWithTableView:(UITableView *)tableView {
    return [self initWithTableView:tableView animations:nil];
}

- (instancetype)initWithTableView:(UITableView *)tableView animations:(BLUITableViewAnimations *)animations {
    return [self initWithEngine:[[BLUITableViewReloaderEngine alloc] initWithTableView:tableView animations:animations]];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    return [self initWithEngine:[[BLUICollectionViewReloaderEngine alloc] initWithCollectionView:collectionView]];
}

- (instancetype)initWithEngine:(id<BLUIKitViewReloaderEngine>)engine {
    NSParameterAssert(engine != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _engine = engine;
    
    return self;
}

#pragma mark - BLDataEventProcessor

- (void)applyEvent:(BLDataEvent *)event withDataUpdateBlock:(void (^)())dataUpdateBlock completion:(void (^)())completion {
    id<BLDataDiff> dataDiff = event.dataDiff;
    
    if ([BLUtils dataDiffIsEmpty:dataDiff]) {
        dataUpdateBlock();
        completion();
        return;
    }
    
    if ([self shouldUseReloadDataForEvent:event]) {
        dataUpdateBlock();
        // TODO: we need a callback here
        [self.engine reloadData];
        completion();
        return;
    }
    
    dataDiff = [self sanitizeDataDiff:dataDiff];
    
    // TODO: NNSectionsDiffTracker *tracker = [[NNSectionsDiffTracker alloc] initWithSectionsDiff:diff];
    NSMutableArray<NSIndexPath *> *indexPathsToUpdateWithBlock = [NSMutableArray array];
    
    [self.engine performUpdates:^{
        dataUpdateBlock();
        
        [self.engine deleteSections:dataDiff.deletedSections];
        [self.engine insertSections:dataDiff.insertedSections];
        // TODO: move & reload sections
        
        [self.engine deleteItemsAtIndexPaths:dataDiff.deletedIndexPaths.allObjects];
        [self.engine insertItemsAtIndexPaths:dataDiff.insertedIndexPaths.allObjects];
        
        for (id<BLDataDiffIndexPathChange> change in dataDiff.changedIndexPaths) {
            if (change.updated && !change.moved) {
                if (self.useUpdateBlockForReload) {
                    [indexPathsToUpdateWithBlock addObject:change.after];
                } else {
                    if (self.useMoveWhenPossible) {
                        // Have to use delete+insert for reloading purpose to co-exist with moves (thanks UIKit!)
                        [self.engine reloadItemsAtIndexPaths:@[ change.before ] asDeleteAndInsertAtIndexPaths:@[ change.after ]];
                    } else {
                        [self.engine reloadItemsAtIndexPaths:@[ change.before ] asDeleteAndInsertAtIndexPaths:nil];
                    }
                }
            } else {
                if ([self shouldUseMoveForIndexPathChange:change]) {
                    [self.engine moveItemAtIndexPath:change.before toIndexPath:change.after];
                    
                    if (change.updated) {
                        [indexPathsToUpdateWithBlock addObject:change.after];
                    }
                } else {
                    [self.engine deleteItemsAtIndexPaths:@[ change.before ]];
                    [self.engine insertItemsAtIndexPaths:@[ change.after ]];
                }
            }
        }
    } completion:^{
        if (self.waitForAnimationCompletion) {
            completion();
        }
    }];

    for (NSIndexPath *indexPath in indexPathsToUpdateWithBlock) {
        id cell = [self.engine cellForItemAtIndexPath:indexPath];
        if (cell) {
            self.cellUpdateBlock(cell, indexPath);
        }
    }
    
    if (!self.waitForAnimationCompletion) {
        completion();
    }
}

#pragma mark - Private

- (id<BLDataDiff>)sanitizeDataDiff:(id<BLDataDiff>)dataDiff {
    // UIKit would get upset if we attempted to move an item from a section being deleted / into a section being inserted.
    // Therefore, we should break such moves into deletions+insertions.
    
    NSMutableSet *extraInsertedIndexPaths = [NSMutableSet set];
    NSMutableSet *extraDeletedIndexPaths = [NSMutableSet set];
    
    NSSet *badChangedIndexPaths = [dataDiff.changedIndexPaths objectsPassingTest:^BOOL(id<BLDataDiffIndexPathChange> change, BOOL *stop) {
        if (!change.moved) {
            return NO;
        }
        
        if ([dataDiff.deletedSections containsIndex:change.before.bl_section]) {
            if (![dataDiff.insertedSections containsIndex:change.after.bl_section]) {
                [extraInsertedIndexPaths addObject:change.after];
            }
            return YES;
        }
        
        if ([dataDiff.insertedSections containsIndex:change.after.bl_section]) {
            if (![dataDiff.deletedSections containsIndex:change.before.bl_section]) {
                [extraDeletedIndexPaths addObject:change.before];
            }
            return YES;
        }
        
        return NO;
    }];
    
    if (badChangedIndexPaths.count == 0) {
        return dataDiff;
    }
    
    BLMutableDataDiff *sanitizedDataDiff = [[BLMutableDataDiff alloc] initWithDataDiff:dataDiff];
    
    [sanitizedDataDiff.insertedIndexPaths unionSet:extraInsertedIndexPaths];
    [sanitizedDataDiff.deletedIndexPaths unionSet:extraDeletedIndexPaths];
    [sanitizedDataDiff.changedIndexPaths minusSet:badChangedIndexPaths];
    
    return sanitizedDataDiff;
}

- (BOOL)shouldUseReloadDataForEvent:(BLDataEvent *)event {
    if (self.forceReloadData) {
        return YES;
    }
    
    if ([self.engine shouldForceReloadData]) {
        return YES;
    }
    
    // TODO: need more sophisticated stuff here?
    
    return NO;
}

- (BOOL)shouldUseMoveForIndexPathChange:(id<BLDataDiffIndexPathChange>)change {
    if (!self.useMoveWhenPossible) {
        return NO;
    }
    
    // We cannot use move because we also need to update the cell, but there is no update block.
    if (change.updated && self.cellUpdateBlock == nil) {
        return NO;
    }
    
    // Move animations between different sections will crash if the destination section index doesn't match its initial one (thanks UIKit!)
    NSUInteger sourceSectionIndex = [change.before indexAtPosition:0];
    NSUInteger destinationSectionIndex = [change.after indexAtPosition:0];
    NSUInteger oldDestinationSectionIndex = 0; // TODO: [tracker oldIndexForSection:destinationSectionIndex];
    
    if (sourceSectionIndex != oldDestinationSectionIndex && destinationSectionIndex != oldDestinationSectionIndex) {
        return NO;
    }
    
    return YES;
}

@end
