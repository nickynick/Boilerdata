//
//  BLChainDataProvider+Subclassing.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataProvider.h"

@protocol BLData;
@class BLDataEvent;

NS_ASSUME_NONNULL_BEGIN


@interface BLChainDataProvider ()

@property (nonatomic, strong, readonly) id<BLData> lastQueuedInnerData;

- (void)updateInnerDataProvider:(id<BLDataProvider>)innerDataProvider;

@end


@interface BLChainDataProvider (Overridable)

/**
 * Override this method to customize chaining transformations.
 */
- (nullable BLDataEvent *)handleInnerDataEvent:(BLDataEvent *)event;

@end


NS_ASSUME_NONNULL_END

// TODO: rename inner -> original?
