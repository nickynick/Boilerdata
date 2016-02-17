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

NS_ASSUME_NONNULL_BEGIN


@interface BLDataItemFilter : NSObject <NSCopying>

@property (nonatomic, strong, readonly, nullable) NSPredicate *predicate;

- (instancetype)initWithPredicate:(nullable NSPredicate *)predicate NS_DESIGNATED_INITIALIZER;

- (BOOL)evaluateItem:(id<BLDataItem>)item;

- (void)invalidateCachedEvaluationForItemWithId:(id<BLDataItemId>)itemId;

@end


NS_ASSUME_NONNULL_END
