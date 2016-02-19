//
//  BLChainDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataProvider.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLData.h"
#import "BLDataObserver.h"
#import "BLDataEvent.h"
#import "BLEmptyData.h"

@interface BLChainDataProvider () <BLDataObserver>

@property (nonatomic, strong) id<BLDataProvider> innerDataProvider;

@property (nonatomic, strong) id<BLData> lastQueuedInnerData;

@end


@implementation BLChainDataProvider

#pragma mark - BLDataProvider

- (void)setLocked:(BOOL)locked {
    [super setLocked:locked];
    
    self.innerDataProvider.locked = locked;
}

#pragma mark - BLDataObserver

- (id<BLDataEventProcessor>)dataProvider:(id<BLDataProvider>)dataProvider willUpdateWithEvent:(BLDataEvent *)event {
    [self enqueueTransformedInnerEvent:event];
    
    return nil;
}

#pragma mark - Protected

- (void)updateInnerDataProvider:(id<BLDataProvider>)innerDataProvider {
    if (self.innerDataProvider == innerDataProvider) {
        return;
    }
    
    self.innerDataProvider = innerDataProvider;
    
    [self enqueueDataEventForInnerDataProviderUpdate];
}

- (void)updateChainingWithBlock:(void (^)(__kindof id<BLData> lastQueuedData, id<BLData> lastQueuedInnerData))block {
    [self updateWithBlock:^(__kindof id<BLData> lastQueuedData) {
        block(lastQueuedData, self.lastQueuedInnerData);
    }];
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
    id<BLData> oldInnerData = self.lastQueuedInnerData;
    id<BLData> newInnerData = self.innerDataProvider ? self.innerDataProvider.data : [BLEmptyData data];
    
    BLDataEvent *fauxInnerEvent = [[BLDataEvent alloc] initWithOldData:oldInnerData
                                                               newData:newInnerData
                                                        updatedItemIds:nil // TODO?
                                                               context:nil];
    
    [self enqueueTransformedInnerEvent:fauxInnerEvent];
}

- (void)enqueueTransformedInnerEvent:(BLDataEvent *)innerEvent {
    [self updateWithBlock:^(__kindof id<BLData> lastQueuedData) {
        self.lastQueuedInnerData = innerEvent.newData;
        
        BLDataEvent *externalDataEvent = [self transformInnerEvent:innerEvent withLastQueuedData:lastQueuedData];
        
        if (externalDataEvent) {
            [self enqueueDataEvent:externalDataEvent];
        }
    }];
}

@end


@implementation BLChainDataProvider (Overridable)

- (BLDataEvent *)transformInnerEvent:(BLDataEvent *)innerEvent withLastQueuedData:(__kindof id<BLData>)lastQueuedData {
    id<BLData> newData = [self transformInnerDataForEvent:innerEvent withLastQueuedData:lastQueuedData];
    if (!newData) {
        return nil;
    }
    
    return [[BLDataEvent alloc] initWithOldData:lastQueuedData
                                        newData:newData
                                 updatedItemIds:innerEvent.updatedItemIds
                                        context:innerEvent.context];
}

- (id<BLData>)transformInnerDataForEvent:(BLDataEvent *)innerEvent withLastQueuedData:(__kindof id<BLData>)lastQueuedData {
    return innerEvent.newData;
}

@end
