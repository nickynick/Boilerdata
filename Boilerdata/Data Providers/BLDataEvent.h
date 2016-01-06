//
//  BLDataEvent.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataDiff;
@protocol BLDataProvider;


@interface BLDataEvent : NSObject

@property (nonatomic, readonly) id<BLDataDiff> diff;

@property (nonatomic, readonly) id<BLDataProvider> updatedDataProvider;

@property (nonatomic, readonly) NSDictionary *context; // optional arbitrary data from model

@end
