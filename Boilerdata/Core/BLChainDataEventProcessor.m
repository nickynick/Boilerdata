//
//  BLChainDataEventProcessor.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataEventProcessor.h"
#import "BLDataEventCallbacks.h"

@interface BLChainDataEventProcessor ()

@property (nonatomic, assign) BOOL willUpdateDataCalled;
@property (nonatomic, assign) BOOL completionCalled;

@end


@implementation BLChainDataEventProcessor

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _callbacks = [[BLDataEventCallbacks alloc] init];
    
    __weak __typeof(self) weakSelf = self;
    
    _callbacks.willUpdateDataBlock = ^{
        weakSelf.willUpdateDataCalled = YES;
    };
    
    _callbacks.completionBlock = ^{
        weakSelf.completionCalled = YES;
    };
    
    return self;
}

#pragma mark - BLDataEventProcessor

- (void)applyEvent:(BLDataEvent *)event withDataUpdateBlock:(void (^)())dataUpdateBlock completion:(void (^)())completion {
    if (self.willUpdateDataCalled) {
        dataUpdateBlock();
    } else {
        self.callbacks.willUpdateDataBlock = ^{
            dataUpdateBlock();
        };
    }

    if (self.completionCalled) {
        completion();
    } else {
        self.callbacks.completionBlock = ^{
            completion();
        };
    }    
}

@end
