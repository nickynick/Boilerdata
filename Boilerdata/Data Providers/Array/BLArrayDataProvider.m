//
//  BLArrayDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLArrayDataProvider.h"
#import "BLAbstractDataProvider+Subclassing.h"
#import "BLStaticArrayDataProvider.h"
#import "BLDataEvent.h"
#import "BLDataDiffCalculator.h"

@implementation BLArrayDataProvider

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items {
    BLStaticArrayDataProvider *oldDataProvider = (BLStaticArrayDataProvider *) self.lastQueuedEvent.updatedDataProvider;
    
    BLStaticArrayDataProvider *newDataProvider = [[BLStaticArrayDataProvider alloc] initWithItems:items];
    
    id<BLDataDiff> dataDiff = [BLDataDiffCalculator diffForItemsBefore:oldDataProvider.items itemsAfter:newDataProvider.items];
    
    [self enqueueDataEvent:[[BLDataEvent alloc] initWithUpdatedDataProvider:newDataProvider
                                                                   dataDiff:dataDiff
                                                                    context:nil]];
}

@end
