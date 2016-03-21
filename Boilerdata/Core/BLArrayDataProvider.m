//
//  BLArrayDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLArrayDataProvider.h"
#import "BLBasicDataProvider+Subclassing.h"
#import "BLArrayData.h"

@implementation BLArrayDataProvider

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items {
    [self updateWithItems:items updatedItemIds:nil];
}

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items updatedItemIds:(NSSet<id<BLDataItemId>> *)precalculatedUpdatedItemIds {
    BLArrayData *newData = [[BLArrayData alloc] initWithItems:items];
    [self updateWithData:newData updatedItemIds:precalculatedUpdatedItemIds];
}

@end
