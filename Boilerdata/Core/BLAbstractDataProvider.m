//
//  BLAbstractDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLAbstractDataProvider.h"
#import "BLAbstractDataProvider+Subclassing.h"
#import "BLEmptyData.h"
#import "BLSimpleDataDiff.h"
#import "BLDataEventCallbacks.h"
#import "BLDataEvent.h"
#import "BLDataEventProcessor.h"
#import "BLDataObserver.h"
#import "BLNilDataEventProcessor.h"

@interface BLAbstractDataProvider ()

@property (nonatomic, strong) id<BLData> data;

@property (nonatomic, strong, readonly) NSMutableArray<BLDataEvent *> *eventQueue;
@property (nonatomic, strong, readonly) NSMutableArray<BLDataEventCallbacks *> *eventCallbacksQueue;

@property (nonatomic, strong) id<BLDataEventProcessor> eventProcessorInProgress;

@end


@implementation BLAbstractDataProvider

#pragma mark - Init

- (instancetype)init {
    self = [super init];
    if (!self) return nil;

    _eventQueue = [NSMutableArray array];
    _eventCallbacksQueue = [NSMutableArray array];
    
    [self enqueueDataEventWithInitialData];
    
    return self;
}

#pragma mark - BLDataProvider

@synthesize data = _data;
@synthesize observer = _observer;
@synthesize locked = _locked;

#pragma mark - Protected

- (void)enqueueDataEvent:(BLDataEvent *)event {
    [self enqueueDataEvent:event callbacks:nil];
}

- (void)enqueueDataEvent:(BLDataEvent *)event callbacks:(BLDataEventCallbacks *)callbacks {
    _lastQueuedData = event.updatedData;
    
    [self.eventQueue addObject:event];
    [self.eventCallbacksQueue addObject:callbacks ?: [[BLDataEventCallbacks alloc] init]];
    
    [self dequeueEventIfPossible];
}

#pragma mark - Private

- (void)enqueueDataEventWithInitialData {
    id<BLData> initialData = [self createInitialData];
    
    BLDataEvent *event = [[BLDataEvent alloc] initWithUpdatedData:initialData dataDiff:[BLSimpleDataDiff empty] context:nil];
    [self enqueueDataEvent:event];
}

- (void)dequeueEventIfPossible {
    if (self.eventQueue.count == 0 || self.locked || self.eventProcessorInProgress) {
        return;
    }
    
    BLDataEvent *event = self.eventQueue.firstObject;
    BLDataEventCallbacks *callbacks = self.eventCallbacksQueue.firstObject;
    [self.eventQueue removeObjectAtIndex:0];
    [self.eventCallbacksQueue removeObjectAtIndex:0];
    
    self.eventProcessorInProgress = [self getProcessorForEvent:event];
    
    if (callbacks.willProcessBlock) {
        callbacks.willProcessBlock(self.eventProcessorInProgress);
    }
    
    [self.eventProcessorInProgress applyEvent:event withDataUpdateBlock:^{
        if (callbacks.willUpdateDataBlock) {
            callbacks.willUpdateDataBlock();
        }
        
        self.data = event.updatedData;
        
        if (callbacks.didUpdateDataBlock) {
            callbacks.didUpdateDataBlock();
        }
    } completion:^{
        self.eventProcessorInProgress = nil;
        
        if (callbacks.completionBlock) {
            callbacks.completionBlock();
        }
        
        [self dequeueEventIfPossible];
    }];
    
    // TODO: post notifications?
}

- (id<BLDataEventProcessor>)getProcessorForEvent:(BLDataEvent *)event {
    id<BLDataEventProcessor> processor = [self.observer dataProvider:self willUpdateWithEvent:event];
    
    if (!processor) {
        processor = [BLNilDataEventProcessor processor];
    }
    
    return processor;
}

@end


@implementation BLAbstractDataProvider (Overridable)

- (id<BLData>)createInitialData {
    return [BLEmptyData data];
}

@end
