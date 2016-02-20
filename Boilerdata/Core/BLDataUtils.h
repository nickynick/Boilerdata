//
//  BLDataUtils.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 20/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLData;
@protocol BLDataItem;
@protocol BLDataItemId;
@protocol BLSectionItem;

NS_ASSUME_NONNULL_BEGIN


typedef void (^BLDataItemEnumerationBlock)(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop);


@interface _BLDataUtils : NSObject

- (BOOL)isEmpty;

- (NSInteger)numberOfItems;

- (NSArray<id<BLDataItem>> *)itemsInSection:(NSInteger)section;

- (NSDictionary<id<BLDataItemId>, id<BLDataItem>> *)itemsById;

- (NSArray<id<BLSectionItem>> *)sectionItems;

- (void)enumerateItemsWithBlock:(BLDataItemEnumerationBlock)block;

@end


extern _BLDataUtils *BLDataUtils(id<BLData> data);


NS_ASSUME_NONNULL_END