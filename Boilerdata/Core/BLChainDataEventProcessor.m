//
//  BLChainDataEventProcessor.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataEventProcessor.h"
#import "BLDataEventCallbacks.h"

@implementation BLChainDataEventProcessor

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _callbacks = [[BLDataEventCallbacks alloc] init];
    
    return self;
}

#pragma mark - BLDataEventProcessor

- (void)applyEvent:(BLDataEvent *)event withDataUpdateBlock:(void (^)())dataUpdateBlock completion:(void (^)())completion {
    self.callbacks.willUpdateDataBlock = ^{
        dataUpdateBlock();
    };
    
    self.callbacks.completionBlock = ^{
        completion();
    };
}

@end
