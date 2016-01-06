//
//  BLArrayDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLAbstractDataProvider.h"

@protocol BLDataItem;


@interface BLArrayDataProvider : BLAbstractDataProvider

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items;

@end
