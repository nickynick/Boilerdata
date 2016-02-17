//
//  BLArrayDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLAbstractDataProvider.h"

@protocol BLDataItem;
@protocol BLDataDiff;

NS_ASSUME_NONNULL_BEGIN


@interface BLArrayDataProvider : BLAbstractDataProvider

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items;

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items precalculatedDiff:(nullable id<BLDataDiff>)dataDiff;

@end


NS_ASSUME_NONNULL_END