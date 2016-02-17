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
#import "BLData.h"
#import "BLDataObserver.h"
#import "BLDataEvent.h"
#import "BLEmptyData.h"
#import "BLChainDataEventProcessor.h"

@interface BLChainDataProvider () <BLDataObserver>

@property (nonatomic, strong) id<BLDataProvider> innerDataProvider;

@end


@implementation BLChainDataProvider

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    
    _lastQueuedInnerData = [BLEmptyData data];
    
    return self;
}

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
    
    _lastQueuedInnerData = event.updatedData;
    
    BLDataEvent *externalDataEvent = [self handleInnerDataEvent:event];
    
    if (externalDataEvent == nil) {
        return nil;
    }
    
    BLChainDataEventProcessor *chainProcessor = [[BLChainDataEventProcessor alloc] init];
    
    [self enqueueDataEvent:externalDataEvent callbacks:chainProcessor.callbacks];

    return chainProcessor;
}

#pragma mark - Protected

- (void)updateInnerDataProvider:(id<BLDataProvider>)innerDataProvider {
    if (self.innerDataProvider == innerDataProvider) {
        return;
    }
    
    self.innerDataProvider = innerDataProvider;
    
    [self enqueueDataEventForInnerDataProviderUpdate];
}

#pragma mark - Private

- (void)setInnerDataProvider:(id<BLDataProvider>)innerDataProvider {
    if (_innerDataProvider.observer == self) {
        _innerDataProvider.observer = nil;
    }
    
    _innerDataProvider = innerDataProvider;
    _innerDataProvider.observer = self;
}

- (void)enqueueDataEventForInnerDataProviderUpdate {
    id<BLData> oldInnerData = _lastQueuedInnerData;
    _lastQueuedInnerData = self.innerDataProvider ? self.innerDataProvider.data : [BLEmptyData data];

    id<BLDataDiff> innerDataDiff = nil; // TODO
    
    BLDataEvent *innerDataEvent = [[BLDataEvent alloc] initWithUpdatedData:_lastQueuedInnerData dataDiff:innerDataDiff context:nil];
    
    BLDataEvent *externalDataEvent = [self handleInnerDataEvent:innerDataEvent];

    if (externalDataEvent) {
        [self enqueueDataEvent:externalDataEvent];
    }
}

@end


@implementation BLChainDataProvider (Overridable)

- (BLDataEvent *)handleInnerDataEvent:(BLDataEvent *)event {
    return event;
}

@end
