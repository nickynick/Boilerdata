//
//  BLDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataItem;
@protocol BLDataItemId;
@protocol BLDataObserver;


@protocol BLStaticDataProvider <NSObject>

@required

- (NSInteger)numberOfSections;

- (NSInteger)numberOfItemsInSection:(NSInteger)section;

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath;
- (NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId;


@optional

- (NSString *)titleForSection:(NSInteger)section; // TODO: should be an arbitrary object, not NSString

- (NSArray *)sectionIndexTitles;
- (NSInteger)sectionForSectionIndexTitleAtIndex:(NSInteger)index;

@end


@protocol BLDataProvider <BLStaticDataProvider>

@property (nonatomic, weak) id<BLDataObserver> observer;

@property (nonatomic, assign, getter = isLocked) BOOL locked;

@end
