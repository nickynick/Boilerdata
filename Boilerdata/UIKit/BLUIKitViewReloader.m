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
#import "BLDataDiffChange.h"
#import "BLUtils.h"

@interface BLUIKitViewReloader ()

@property (nonatomic, strong, readonly) id<BLUIKitViewReloaderEngine> engine;

@end


@implementation BLUIKitViewReloader

#pragma mark - Init

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
    self = [super init];
    if (!self) return nil;
    
    _engine = engine;
    
    return self;
}

#pragma mark - Config

- (BLCellUpdateBlock)cellUpdateBlock {
    return self.engine.cellUpdateBlock;
}

- (void)setCellUpdateBlock:(BLCellUpdateBlock)cellUpdateBlock {
    self.engine.cellUpdateBlock = cellUpdateBlock;
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
    
    [self.engine performUpdates:^{
        dataUpdateBlock();
        
        [self.engine deleteSections:dataDiff.deletedSections];
        [self.engine insertSections:dataDiff.insertedSections];
        
        [self.engine deleteItemsAtIndexPaths:dataDiff.deletedIndexPaths.allObjects];
        [self.engine insertItemsAtIndexPaths:dataDiff.insertedIndexPaths.allObjects];
        
        for (id<BLDataDiffSectionChange> change in dataDiff.changedSections) {
            if (change.updated) {
                [self.engine reloadSections:[NSIndexSet indexSetWithIndex:change.before]];
            }
            
            if (change.moved) {
                [self.engine moveSection:change.before toSection:change.after];
            }
        }
        
        for (id<BLDataDiffIndexPathChange> change in dataDiff.changedIndexPaths) {
            if (change.updated) {
                if (self.useCellUpdateBlockForReload) {
                    [self.engine customReloadItemsAtIndexPaths:@[ change.before ]];
                } else {
                    [self.engine reloadItemsAtIndexPaths:@[ change.before ]];
                }
            }
            
            if (change.moved) {
                [self.engine moveItemAtIndexPath:change.before toIndexPath:change.after];
            }
        }
    } completion:^{
        if (self.waitForAnimationCompletion) {
            completion();
        }
    }];
        
    if (!self.waitForAnimationCompletion) {
        completion();
    }
}

#pragma mark - Private

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

@end
