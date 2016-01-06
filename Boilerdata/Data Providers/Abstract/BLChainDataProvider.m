//
//  BLChainDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataProvider.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLAbstractDataProvider+Subclassing.h"
#import "BLDataObserver.h"
#import "BLDataEvent.h"
#import "BLDataEventProcessor.h"
#import "BLChainDataEventProcessor.h"

@interface BLChainDataProvider () <BLDataObserver>

@end


@implementation BLChainDataProvider

#pragma mark - BLDataProvider

- (void)setLocked:(BOOL)locked {
    [super setLocked:locked];
    
    self.innerDataProvider.locked = locked;
}

#pragma mark - BLDataObserver

- (id<BLDataEventProcessor>)dataProvider:(id<BLDataProvider>)dataProvider willUpdateWithEvent:(BLDataEvent *)event {
    if (dataProvider != self.innerDataProvider) {
        return nil;
    }
    
    BLDataEvent *transformedEvent = [self transformInnerDataEvent:event];
    
    if (transformedEvent == nil) {
        return nil;
    }
    
    BLChainDataEventProcessor *chainProcessor = [[BLChainDataEventProcessor alloc] init];
    
    BLAbstractDataProviderEventCallbacks *eventCallbacks = [[BLAbstractDataProviderEventCallbacks alloc] init];
    eventCallbacks.willProcessBlock = ^(id<BLDataEventProcessor> processor) {
        chainProcessor.innerProcessor = processor;
    };

    [self enqueueDataEvent:transformedEvent callbacks:eventCallbacks];

    return chainProcessor;
}

#pragma mark - Protected

- (void)setInnerDataProvider:(id<BLDataProvider>)innerDataProvider {
    if (_innerDataProvider == innerDataProvider) {
        return;
    }
    
    if (_innerDataProvider.observer == self) {
        _innerDataProvider.observer = nil;
    }
    
    _innerDataProvider = innerDataProvider;
    _innerDataProvider.observer = self;
}

- (BLDataEvent *)transformInnerDataEvent:(BLDataEvent *)event {
    return event;
}

@end
