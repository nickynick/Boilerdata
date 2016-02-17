//
//  BLArrayData.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 17/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLData.h"

@protocol BLDataItem;

NS_ASSUME_NONNULL_BEGIN


@interface BLArrayData : NSObject <BLData>

@property (nonatomic, copy, readonly) NSArray<id<BLDataItem>> *items;

- (instancetype)initWithItems:(NSArray<id<BLDataItem>> *)items NS_DESIGNATED_INITIALIZER;

@end


NS_ASSUME_NONNULL_END