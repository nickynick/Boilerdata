//
//  BLFilterDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLFilterDataProvider.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLFilteredData.h"
#import "BLEmptyData.h"
#import "BLDataItemFilter.h"
#import "BLDataEvent.h"

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

#pragma mark - BLChainDataProvider

- (id<BLData>)transformInnerDataForEvent:(BLDataEvent *)innerEvent withLastQueuedData:(BLFilteredData *)lastQueuedData {
    BLDataItemFilter *newFilter = [lastQueuedData.filter copy];
    
    if (newFilter) {
        for (id<BLDataItemId> itemId in innerEvent.updatedItemIds) {
            [newFilter invalidateCachedEvaluationForItemWithId:itemId];
        }
        
        // TODO: invalidate deleted items too?
    }
    
    return [[BLFilteredData alloc] initWithOriginalData:innerEvent.newData filter:newFilter];
}

#pragma mark - Updates

- (void)updateWithPredicate:(NSPredicate *)predicate {
    [self updateChainingWithBlock:^(BLFilteredData *lastQueuedData, id<BLData> lastQueuedInnerData) {
        BLDataItemFilter *newFilter = [[BLDataItemFilter alloc] initWithPredicate:predicate];
        
        BLFilteredData *newData = [[BLFilteredData alloc] initWithOriginalData:lastQueuedInnerData filter:newFilter];
        
        [self enqueueDataEvent:[[BLDataEvent alloc] initWithOldData:lastQueuedData newData:newData]];
    }];
}

@end
