//
//  BLArrayDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLArrayDataProvider.h"
#import "BLAbstractDataProvider+Subclassing.h"
#import "BLArrayData.h"
#import "BLDataEvent.h"
#import "BLDataDiffCalculator.h"

@implementation BLArrayDataProvider

#pragma mark - BLAbstractDataProvider

- (id<BLData>)createInitialData {
    return [[BLArrayData alloc] initWithItems:@[]];
}

#pragma mark - Updates

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items {
    [self updateWithItems:items precalculatedDiff:nil];
}

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items precalculatedDiff:(nullable id<BLDataDiff>)dataDiff {
    BLArrayData *newData = [[BLArrayData alloc] initWithItems:items];
    
    if (!dataDiff) {
        BLArrayData *oldData = self.lastQueuedData;
        dataDiff = [BLDataDiffCalculator diffForItemsBefore:oldData.items itemsAfter:newData.items];
    }
    
    [self enqueueDataEvent:[[BLDataEvent alloc] initWithUpdatedData:newData dataDiff:dataDiff context:nil]];
}

@end
