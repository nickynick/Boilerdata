//
//  BLDataEventCallbacks.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 17/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataEventProcessor;

NS_ASSUME_NONNULL_BEGIN


@interface BLDataEventCallbacks : NSObject

@property (nonatomic, copy, nullable) void (^willProcessBlock)(id<BLDataEventProcessor>);

@property (nonatomic, copy, nullable) void (^willUpdateDataBlock)(void);
@property (nonatomic, copy, nullable) void (^didUpdateDataBlock)(void);

@property (nonatomic, copy, nullable) void (^completionBlock)(void);

@end


NS_ASSUME_NONNULL_END
