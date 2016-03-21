//
//  BLBasicDataProvider.h
//  Boilerdata
//
//  Created by Makarov Yury on 21/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLAbstractDataProvider.h"

@protocol BLDataItem;

NS_ASSUME_NONNULL_BEGIN


typedef BOOL (^BLDataItemIsUpdatedBlock)(__kindof id<BLDataItem> oldItem, __kindof id<BLDataItem> newItem);


@interface BLBasicDataProvider : BLAbstractDataProvider

- (instancetype)initWithIsUpdatedBlock:(nullable BLDataItemIsUpdatedBlock)isUpdatedBlock NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END