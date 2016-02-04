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

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    [self updateWithItems:@[]];
    
    return self;
}

#pragma mark - Updates

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items {
    [self updateWithItems:items dataDiff:nil];
}

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items dataDiff:(id<BLDataDiff>)dataDiff {
    BLStaticArrayDataProvider *newDataProvider = [[BLStaticArrayDataProvider alloc] initWithItems:items];
    
    if (!dataDiff) {
        BLStaticArrayDataProvider *oldDataProvider = (BLStaticArrayDataProvider *) self.lastQueuedEvent.updatedDataProvider;
        
        dataDiff = [BLDataDiffCalculator diffForItemsBefore:oldDataProvider.items itemsAfter:newDataProvider.items];
    }
    
    [self enqueueDataEvent:[[BLDataEvent alloc] initWithUpdatedDataProvider:newDataProvider
                                                                   dataDiff:dataDiff
                                                                    context:nil]];
}

@end
