//
//  BLDataItemFilter.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataItem;
@protocol BLDataItemId;


@interface BLDataItemFilter : NSObject <NSCopying>

@property (nonatomic, readonly) NSPredicate *predicate;

- (instancetype)initWithPredicate:(NSPredicate *)predicate;

- (BOOL)filterItem:(id<BLDataItem>)item;

- (void)invalidateCachedResultForItemWithId:(id<BLDataItemId>)itemId;

@end
