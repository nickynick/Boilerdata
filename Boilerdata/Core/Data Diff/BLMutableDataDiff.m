//
//  BLMutableDataDiff.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLMutableDataDiff.h"
#import "BLMutableDataDiffChange.h"
#import "NSIndexPath+BLUtils.h"

@implementation BLMutableDataDiff

#pragma mark - Init

- (instancetype)init {
    return [self initWithDataDiff:nil];
}

- (instancetype)initWithDataDiff:(id<BLDataDiff>)dataDiff {
    self = [super init];
    if (!self) return nil;
    
    _deletedIndexPaths = [dataDiff.deletedIndexPaths mutableCopy] ?: [NSMutableSet set];
    _insertedIndexPaths = [dataDiff.insertedIndexPaths mutableCopy] ?: [NSMutableSet set];
    _changedIndexPaths = [dataDiff.changedIndexPaths mutableCopy] ?: [NSMutableSet set];
    
    _deletedSections = [dataDiff.deletedSections mutableCopy] ?: [NSMutableIndexSet indexSet];
    _insertedSections = [dataDiff.insertedSections mutableCopy] ?: [NSMutableIndexSet indexSet];
    _changedSections = [dataDiff.changedSections mutableCopy] ?: [NSMutableSet set];
    
    return self;
}

#pragma mark - Operations

- (void)addIndexPathsFromDiff:(id<BLDataDiff>)dataDiff {
    [self.deletedIndexPaths unionSet:dataDiff.deletedIndexPaths];
    [self.insertedIndexPaths unionSet:dataDiff.insertedIndexPaths];
    [self.changedIndexPaths unionSet:dataDiff.changedIndexPaths];
}

- (void)addSectionsFromDiff:(id<BLDataDiff>)dataDiff {
    [self.deletedSections addIndexes:dataDiff.deletedSections];
    [self.insertedSections addIndexes:dataDiff.insertedSections];
    [self.changedSections unionSet:dataDiff.changedSections];
}

- (void)shiftBySectionDelta:(NSInteger)sectionDelta rowDelta:(NSInteger)rowDelta {
    if (sectionDelta == 0 && rowDelta == 0) {
        return;
    }
    
    NSMutableSet<NSIndexPath *> *deletedIndexPaths = [NSMutableSet setWithCapacity:self.deletedIndexPaths.count];
    for (NSIndexPath *indexPath in self.deletedIndexPaths) {
        [deletedIndexPaths addObject:[indexPath bl_shiftBySectionDelta:sectionDelta rowDelta:rowDelta]];
    }
    _deletedIndexPaths = deletedIndexPaths;
    
    NSMutableSet<NSIndexPath *> *insertedIndexPaths = [NSMutableSet setWithCapacity:self.insertedIndexPaths.count];
    for (NSIndexPath *indexPath in self.insertedIndexPaths) {
        [insertedIndexPaths addObject:[indexPath bl_shiftBySectionDelta:sectionDelta rowDelta:rowDelta]];
    }
    _insertedIndexPaths = insertedIndexPaths;
    
    NSMutableSet<id<BLDataDiffIndexPathChange>> *changedIndexPaths = [NSMutableSet setWithCapacity:self.changedIndexPaths.count];
    for (id<BLDataDiffIndexPathChange> change in self.changedIndexPaths) {
        BLMutableDataDiffIndexPathChange *shiftedChange = [[BLMutableDataDiffIndexPathChange alloc] initWithChange:change];
        shiftedChange.before = [shiftedChange.before bl_shiftBySectionDelta:sectionDelta rowDelta:rowDelta];
        shiftedChange.after = [shiftedChange.after bl_shiftBySectionDelta:sectionDelta rowDelta:rowDelta];
        
        [changedIndexPaths addObject:shiftedChange];
    }
    _changedIndexPaths = changedIndexPaths;
    
    
    if (sectionDelta == 0) {
        return;
    }
    
    [self.deletedSections shiftIndexesStartingAtIndex:0 by:sectionDelta];
    
    [self.insertedSections shiftIndexesStartingAtIndex:0 by:sectionDelta];
    
    NSMutableSet<id<BLDataDiffSectionChange>> *changedSections = [NSMutableSet setWithCapacity:self.changedSections.count];
    for (id<BLDataDiffSectionChange> change in self.changedSections) {
        BLMutableDataDiffSectionChange *shiftedChange = [[BLMutableDataDiffSectionChange alloc] initWithChange:change];
        shiftedChange.before += sectionDelta;
        shiftedChange.after += sectionDelta;
        
        [changedSections addObject:shiftedChange];
    }
    _changedSections = changedSections;
}

@end
