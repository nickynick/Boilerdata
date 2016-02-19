//
//  BLDataEvent.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLData;
@protocol BLDataItemId;

NS_ASSUME_NONNULL_BEGIN


@interface BLDataEvent : NSObject

@property (nonatomic, strong, readonly) id<BLData> oldData;

@property (nonatomic, strong, readonly) id<BLData> newData NS_RETURNS_NOT_RETAINED;

@property (nonatomic, copy, readonly) NSSet<id<BLDataItemId>> *updatedItemIds;

/**
 * Optional arbitrary data from model.
 */
@property (nonatomic, copy, readonly) NSDictionary *context;

- (instancetype)initWithOldData:(id<BLData>)oldData newData:(id<BLData>)newData;

- (instancetype)initWithOldData:(id<BLData>)oldData
                        newData:(id<BLData>)newData
                 updatedItemIds:(nullable NSSet<id<BLDataItemId>> *)updatedItemIds
                        context:(nullable NSDictionary *)context NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

+ (instancetype)empty;

@end


NS_ASSUME_NONNULL_END