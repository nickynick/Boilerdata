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

@property (nonatomic, copy) void (^pendingDataUpdateBlock)();
@property (nonatomic, copy) void (^pendingIndividualItemUpdateBlock)();
@property (nonatomic, copy) void (^pendingCompletion)();

@end


@implementation BLChainDataEventProcessor

#pragma mark - BLDataEventProcessor

- (void)applyEventWithDataUpdateBlock:(void (^)())dataUpdateBlock
            individualItemUpdateBlock:(void (^)())individualItemUpdateBlock
                           completion:(void (^)())completion
{
    if (self.innerProcessor) {
        [self.innerProcessor applyEventWithDataUpdateBlock:dataUpdateBlock
                                 individualItemUpdateBlock:individualItemUpdateBlock
                                                completion:completion];
    } else {
        self.pending = YES;
        self.pendingDataUpdateBlock = dataUpdateBlock;
        self.pendingIndividualItemUpdateBlock = individualItemUpdateBlock;
        self.pendingCompletion = completion;
    }
}

#pragma mark - Chaining

- (void)setInnerProcessor:(id<BLDataEventProcessor>)innerProcessor {
    _innerProcessor = innerProcessor;
    
    if (self.pending) {
        [innerProcessor applyEventWithDataUpdateBlock:self.pendingDataUpdateBlock
                            individualItemUpdateBlock:self.pendingIndividualItemUpdateBlock
                                           completion:self.pendingCompletion];
        
        self.pending = NO;
        self.pendingDataUpdateBlock = nil;
        self.pendingIndividualItemUpdateBlock = nil;
        self.pendingCompletion = nil;
    }
}

@end
