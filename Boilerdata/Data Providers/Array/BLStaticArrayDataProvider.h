//
//  BLStaticArrayDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataProvider.h"

@protocol BLDataItem;


@interface BLStaticArrayDataProvider : NSObject <BLStaticDataProvider>

@property (nonatomic, copy, readonly) NSArray<id<BLDataItem>> *items;

- (instancetype)initWithItems:(NSArray<id<BLDataItem>> *)items;

@end
