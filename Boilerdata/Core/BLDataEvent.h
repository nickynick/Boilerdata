//
//  BLDataEvent.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLData;
@protocol BLDataDiff;

NS_ASSUME_NONNULL_BEGIN


@interface BLDataEvent : NSObject

@property (nonatomic, strong, readonly) id<BLData> updatedData;

@property (nonatomic, strong, readonly) id<BLDataDiff> dataDiff;

// TODO: consider removing this.
// Wouldn't it be better to store special model info in .updateData itself?
// However, this won't work with chaining.
@property (nonatomic, copy, readonly) NSDictionary *context; // optional arbitrary data from model

- (instancetype)initWithUpdatedData:(id<BLData>)updatedData
                           dataDiff:(id<BLDataDiff>)dataDiff
                            context:(nullable NSDictionary *)context NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END