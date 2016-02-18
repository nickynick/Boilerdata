//
//  BLData.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 17/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataItem;
@protocol BLDataItemId;
@protocol BLSectionItem;

NS_ASSUME_NONNULL_BEGIN


@protocol BLData <NSObject>

@required

- (NSInteger)numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath;
- (nullable NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId;


@optional

- (nullable id<BLSectionItem>)itemForSection:(NSInteger)section;

- (NSArray<NSString *> *)sectionIndexTitles;
- (NSInteger)sectionForSectionIndexTitleAtIndex:(NSInteger)index;

@end


NS_ASSUME_NONNULL_END