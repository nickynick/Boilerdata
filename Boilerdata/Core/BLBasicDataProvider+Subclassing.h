//
//  BLBasicDataProvider+Subclassing.h
//  Boilerdata
//
//  Created by Makarov Yury on 21/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLBasicDataProvider.h"

NS_ASSUME_NONNULL_BEGIN


@protocol BLData;
@protocol BLDataItemId;


@interface BLBasicDataProvider (Subclassing)

- (void)updateWithData:(id<BLData>)data updatedItemIds:(nullable NSSet<id<BLDataItemId>> *)updatedItemIds;

@end

NS_ASSUME_NONNULL_END