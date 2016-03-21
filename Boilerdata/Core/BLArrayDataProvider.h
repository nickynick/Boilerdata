//
//  BLArrayDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLBasicDataProvider.h"

@protocol BLDataItem;
@protocol BLDataItemId;

NS_ASSUME_NONNULL_BEGIN


@interface BLArrayDataProvider : BLBasicDataProvider

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items;

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items updatedItemIds:(nullable NSSet<id<BLDataItemId>> *)updatedItemIds;

@end


NS_ASSUME_NONNULL_END