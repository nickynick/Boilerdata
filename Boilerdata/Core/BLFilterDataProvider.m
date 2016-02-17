//
//  BLFilterDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLFilterDataProvider.h"
#import "BLAbstractDataProvider+Subclassing.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLFilteredData.h"
#import "BLEmptyData.h"
#import "BLDataItem.h"
#import "BLDataItemFilter.h"
#import "BLDataEvent.h"
#import "BLDataDiff.h"
#import "BLMutableDataDiff.h"
#import "BLMutableDataDiffChange.h"
#import "BLUtils.h"

@implementation BLFilterDataProvider

#pragma mark - Init

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider {
    self = [super init];
    if (!self) return nil;
    
    [self updateInnerDataProvider:dataProvider];
    
    return self;
}

#pragma mark - BLAbstractDataProvider

- (id<BLData>)createInitialData {
    return [[BLFilteredData alloc] initWithOriginalData:[BLEmptyData data] filter:nil];
}

#pragma mark - Filtering

- (void)updateWithPredicate:(NSPredicate *)predicate {
    BLDataItemFilter *newFilter = [[BLDataItemFilter alloc] initWithPredicate:predicate];
    BLFilteredData *newData = [[BLFilteredData alloc] initWithOriginalData:self.lastQueuedInnerData filter:newFilter];
    
    id<BLDataDiff> dataDiff = [self dataDiffForPredicateUpdateWithOldData:self.lastQueuedData newData:newData];
    
    [self enqueueDataEvent:[[BLDataEvent alloc] initWithUpdatedData:newData dataDiff:dataDiff context:nil]];
}

#pragma mark - Chaining

- (BLDataEvent *)handleInnerDataEvent:(BLDataEvent *)event {
    BLFilteredData *oldData = self.lastQueuedData;
    
    BLDataItemFilter *newFilter = [oldData.filter copy];
    
    for (id<BLDataDiffIndexPathChange> change in event.dataDiff.changedIndexPaths) {
        if (change.updated) {
            id<BLDataItem> updatedItem = [event.updatedData itemAtIndexPath:change.after];
            [newFilter invalidateCachedEvaluationForItemWithId:updatedItem.itemId];
        }
    }
    
    BLFilteredData *newData = [[BLFilteredData alloc] initWithOriginalData:event.updatedData filter:newFilter];
    
    id<BLDataDiff> dataDiff = [self dataDiffForInnerDataEvent:event oldData:oldData newData:newData];
    
    return [[BLDataEvent alloc] initWithUpdatedData:newData dataDiff:dataDiff context:event.context];
}

#pragma mark - Private

- (id<BLDataDiff>)dataDiffForPredicateUpdateWithOldData:(BLFilteredData *)oldData newData:(BLFilteredData *)newData {
    BLMutableDataDiff *dataDiff = [[BLMutableDataDiff alloc] init];
    
    if (!newData.identical) {
        [BLUtils data:oldData enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
            NSIndexPath *originalIndexPath = [oldData filteredIndexPathToOriginal:indexPath];
            if (![newData originalIndexPathToFiltered:originalIndexPath]) {
                [dataDiff.deletedIndexPaths addObject:indexPath];
            }
        }];
    }
    
    if (!oldData.identical) {
        [BLUtils data:newData enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
            NSIndexPath *originalIndexPath = [newData filteredIndexPathToOriginal:indexPath];
            if (![oldData originalIndexPathToFiltered:originalIndexPath]) {
                [dataDiff.insertedIndexPaths addObject:indexPath];
            }
        }];
    }
    
    return dataDiff;
}

- (id<BLDataDiff>)dataDiffForInnerDataEvent:(BLDataEvent *)event oldData:(BLFilteredData *)oldData newData:(BLFilteredData *)newData {
    id<BLDataDiff> innerDataDiff = event.dataDiff;
    
    if (oldData.identical && newData.identical) {
        return innerDataDiff;
    }
    
    BLMutableDataDiff *dataDiff = [[BLMutableDataDiff alloc] init];
    [dataDiff addSectionsFromDiff:innerDataDiff];
    
    for (NSIndexPath *originalIndexPath in innerDataDiff.deletedIndexPaths) {
        NSIndexPath *indexPath = [oldData originalIndexPathToFiltered:originalIndexPath];
        if (indexPath) {
            [dataDiff.deletedIndexPaths addObject:indexPath];
        }
    }
    
    for (NSIndexPath *originalIndexPath in innerDataDiff.insertedIndexPaths) {
        NSIndexPath *indexPath = [newData originalIndexPathToFiltered:originalIndexPath];
        if (indexPath) {
            [dataDiff.insertedIndexPaths addObject:indexPath];
        }
    }
    
    for (id<BLDataDiffIndexPathChange> originalChange in innerDataDiff.changedIndexPaths) {
        NSIndexPath *indexPathBefore = [oldData originalIndexPathToFiltered:originalChange.before];
        NSIndexPath *indexPathAfter = [newData originalIndexPathToFiltered:originalChange.after];
        
        if (indexPathBefore && indexPathAfter) {
            BLMutableDataDiffIndexPathChange *filteredChange = [[BLMutableDataDiffIndexPathChange alloc] initWithChange:originalChange];
            filteredChange.before = indexPathBefore;
            filteredChange.after = indexPathAfter;
            
            [dataDiff.changedIndexPaths addObject:filteredChange];
        } else if (indexPathBefore && !indexPathAfter) {
            [dataDiff.deletedIndexPaths addObject:indexPathBefore];
        } else if (!indexPathBefore && indexPathAfter) {
            [dataDiff.insertedIndexPaths addObject:indexPathAfter];
        }
    }
    
    return dataDiff;
}

@end
