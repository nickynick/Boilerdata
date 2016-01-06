//
//  BLAbstractDataProvider+Subclassing.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLAbstractDataProvider.h"

@class BLDataEvent;
@class BLAbstractDataProviderEventCallbacks;
@protocol BLDataEventProcessor;


@interface BLAbstractDataProvider ()

- (void)enqueueDataEvent:(BLDataEvent *)event;

- (void)enqueueDataEvent:(BLDataEvent *)event callbacks:(BLAbstractDataProviderEventCallbacks *)callbacks;

@end


@interface BLAbstractDataProviderEventCallbacks : NSObject

@property (nonatomic, copy) void (^willProcessBlock)(id<BLDataEventProcessor> processor);

@property (nonatomic, copy) void (^didProcessBlock)();

@end