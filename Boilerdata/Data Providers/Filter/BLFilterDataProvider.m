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
#import "BLStaticFilterDataProvider.h"
#import "BLDataItem.h"
#import "BLDataItemFilter.h"
#import "BLDataEvent.h"
#import "BLDataDiff.h"
#import "BLMutableDataDiff.h"
#import "BLMutableDataDiffChange.h"
#import "BLUtils.h"

@implementation BLFilterDataProvider

#pragma mark - Init

- (instancetype)init {
    return [self initWithDataProvider:nil];
}

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider {
    NSParameterAssert(dataProvider != nil);
    
    self = [super init];
    if (!self) return nil;
    
    self.innerDataProvider = dataProvider;
    
    return self;
}

#pragma mark - Filtering

- (void)updatePredicate:(NSPredicate *)predicate {
    BLStaticFilterDataProvider *oldDataProvider = (BLStaticFilterDataProvider *) self.lastQueuedEvent.updatedDataProvider;

    BLDataItemFilter *newFilter = [[BLDataItemFilter alloc] initWithPredicate:predicate];
    
    BLStaticFilterDataProvider *newDataProvider =
        [[BLStaticFilterDataProvider alloc] initWithFullDataProvider:oldDataProvider.fullDataProvider filter:newFilter];
    
    id<BLDataDiff> dataDiff = [self dataDiffForPredicateUpdateWithOldDataProvider:oldDataProvider newDataProvider:newDataProvider];
    
    [self enqueueDataEvent:[[BLDataEvent alloc] initWithUpdatedDataProvider:newDataProvider
                                                                   dataDiff:dataDiff
                                                                    context:nil]];
}

#pragma mark - Chaining

- (BLDataEvent *)handleInnerDataEvent:(BLDataEvent *)event {
    BLStaticFilterDataProvider *oldDataProvider = (BLStaticFilterDataProvider *) self.lastQueuedEvent.updatedDataProvider;
    
    BLDataItemFilter *newFilter = [oldDataProvider.filter copy];
    
    for (id<BLDataDiffIndexPathChange> change in event.dataDiff.changedIndexPaths) {
        if (change.updated) {
            id<BLDataItem> updatedItem = [event.updatedDataProvider itemAtIndexPath:change.after];
            [newFilter invalidateCachedResultForItemWithId:updatedItem.itemId];
        }
    }
    
    BLStaticFilterDataProvider *newDataProvider =
        [[BLStaticFilterDataProvider alloc] initWithFullDataProvider:event.updatedDataProvider filter:newFilter];
    
    id<BLDataDiff> dataDiff = [self dataDiffForInnerDataEvent:event oldDataProvider:oldDataProvider newDataProvider:newDataProvider];
    
    return [[BLDataEvent alloc] initWithUpdatedDataProvider:newDataProvider
                                                   dataDiff:dataDiff
                                                    context:nil];
}

#pragma mark - Private

- (id<BLDataDiff>)dataDiffForPredicateUpdateWithOldDataProvider:(BLStaticFilterDataProvider *)oldDataProvider
                                                newDataProvider:(BLStaticFilterDataProvider *)newDataProvider
{
    BLMutableDataDiff *dataDiff = [[BLMutableDataDiff alloc] init];
    
    if (!newDataProvider.identical) {
        [BLUtils dataProvider:oldDataProvider enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
            NSIndexPath *fullIndexPath = [oldDataProvider filteredIndexPathToFull:indexPath];
            if (![newDataProvider fullIndexPathToFiltered:fullIndexPath]) {
                [dataDiff.deletedIndexPaths addObject:indexPath];
            }
        }];
    }
    
    if (!oldDataProvider.identical) {
        [BLUtils dataProvider:newDataProvider enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
            NSIndexPath *fullIndexPath = [newDataProvider filteredIndexPathToFull:indexPath];
            if (![oldDataProvider fullIndexPathToFiltered:fullIndexPath]) {
                [dataDiff.insertedIndexPaths addObject:indexPath];
            }
        }];
    }
    
    return dataDiff;
}

- (id<BLDataDiff>)dataDiffForInnerDataEvent:(BLDataEvent *)event
                            oldDataProvider:(BLStaticFilterDataProvider *)oldDataProvider
                            newDataProvider:(BLStaticFilterDataProvider *)newDataProvider
{
    id<BLDataDiff> fullDataDiff = event.dataDiff;
    
    if (oldDataProvider.identical && newDataProvider.identical) {
        return fullDataDiff;
    }
    
    BLMutableDataDiff *dataDiff = [[BLMutableDataDiff alloc] init];
    [dataDiff addSectionsFromDiff:fullDataDiff];
    
    for (NSIndexPath *fullIndexPath in fullDataDiff.deletedIndexPaths) {
        NSIndexPath *indexPath = [oldDataProvider fullIndexPathToFiltered:fullIndexPath];
        if (indexPath) {
            [dataDiff.deletedIndexPaths addObject:indexPath];
        }
    }
    
    for (NSIndexPath *fullIndexPath in fullDataDiff.insertedIndexPaths) {
        NSIndexPath *indexPath = [newDataProvider fullIndexPathToFiltered:fullIndexPath];
        if (indexPath) {
            [dataDiff.insertedIndexPaths addObject:indexPath];
        }
    }
    
    for (id<BLDataDiffIndexPathChange> fullChange in fullDataDiff.changedIndexPaths) {
        NSIndexPath *indexPathBefore = [oldDataProvider fullIndexPathToFiltered:fullChange.before];
        NSIndexPath *indexPathAfter = [newDataProvider fullIndexPathToFiltered:fullChange.after];
        
        if (indexPathBefore && indexPathAfter) {
            BLMutableDataDiffIndexPathChange *filteredChange = [[BLMutableDataDiffIndexPathChange alloc] initWithChange:fullChange];
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
