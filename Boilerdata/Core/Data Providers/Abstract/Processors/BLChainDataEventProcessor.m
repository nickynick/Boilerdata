//
//  BLChainDataEventProcessor.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataEventProcessor.h"

@interface BLChainDataEventProcessor ()

@property (nonatomic, assign) BOOL pending;

@property (nonatomic, strong) BLDataEvent *pendingEvent;
@property (nonatomic, copy) void (^pendingDataUpdateBlock)();
@property (nonatomic, copy) void (^pendingCompletion)();

@end


@implementation BLChainDataEventProcessor

#pragma mark - BLDataEventProcessor

- (void)applyEvent:(BLDataEvent *)event withDataUpdateBlock:(void (^)())dataUpdateBlock completion:(void (^)())completion {
    if (self.innerProcessor) {
        [self.innerProcessor applyEvent:event withDataUpdateBlock:dataUpdateBlock completion:completion];
    } else {
        self.pending = YES;
        self.pendingEvent = event;
        self.pendingDataUpdateBlock = dataUpdateBlock;
        self.pendingCompletion = completion;
    }
}

#pragma mark - Chaining

- (void)setInnerProcessor:(id<BLDataEventProcessor>)innerProcessor {
    _innerProcessor = innerProcessor;
    
    if (self.pending) {
        [innerProcessor applyEvent:self.pendingEvent withDataUpdateBlock:self.pendingDataUpdateBlock completion:self.pendingCompletion];
        
        self.pending = NO;
        self.pendingEvent = nil;
        self.pendingDataUpdateBlock = nil;
        self.pendingCompletion = nil;
    }
}

@end
