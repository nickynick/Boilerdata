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
#import "BLDataDiffCalculator.h"
#import "BLMutableDataDiff.h"
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
    return [[BLFilteredData alloc] initWithOriginalData:self.lastQueuedInnerData filter:nil];
}

#pragma mark - Filtering

- (void)updateWithPredicate:(NSPredicate *)predicate {
    BLDataItemFilter *newFilter = [[BLDataItemFilter alloc] initWithPredicate:predicate];
    
    BLFilteredData *oldData = self.lastQueuedData;
    BLFilteredData *newData = [[BLFilteredData alloc] initWithOriginalData:self.lastQueuedInnerData filter:newFilter];
    
    id<BLDataDiff> dataDiff = [BLDataDiffCalculator indexPathDiffForMappingUpdateWithMappedDataBefore:oldData
                                                                                      mappedDataAfter:newData];
    
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
    
    id<BLDataDiff> dataDiff = [self dataDiffForInnerDiff:event.dataDiff oldData:oldData newData:newData];
    
    return [[BLDataEvent alloc] initWithUpdatedData:newData dataDiff:dataDiff context:event.context];
}

#pragma mark - Private

- (id<BLDataDiff>)dataDiffForInnerDiff:(id<BLDataDiff>)innerDataDiff oldData:(BLFilteredData *)oldData newData:(BLFilteredData *)newData {
    if (oldData.identical && newData.identical) {
        return innerDataDiff;
    }
    
    BLMutableDataDiff *dataDiff = [[BLMutableDataDiff alloc] init];
    [dataDiff addSectionsFromDiff:innerDataDiff];
    [dataDiff addIndexPathsFromDiff:[BLDataDiffCalculator indexPathDiffWithOriginalDiff:innerDataDiff
                                                                          mappingBefore:oldData
                                                                           mappingAfter:newData]];
    return dataDiff;
}

@end
