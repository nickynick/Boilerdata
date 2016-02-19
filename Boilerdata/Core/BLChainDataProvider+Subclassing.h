//
//  BLChainDataProvider+Subclassing.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataProvider.h"
#import "BLAbstractDataProvider+Subclassing.h"

@protocol BLData;
@class BLDataEvent;

NS_ASSUME_NONNULL_BEGIN


@interface BLChainDataProvider ()

- (void)updateInnerDataProvider:(id<BLDataProvider>)innerDataProvider;

- (void)updateChainingWithBlock:(void (^)(__kindof id<BLData> lastQueuedData, id<BLData> lastQueuedInnerData))block;

@end


/**
 * Override either of these two methods to customize chaining transformations.
 */
@interface BLChainDataProvider (Overridable)

- (nullable BLDataEvent *)transformInnerEvent:(BLDataEvent *)innerEvent withLastQueuedData:(__kindof id<BLData>)lastQueuedData;

- (nullable id<BLData>)transformInnerDataForEvent:(BLDataEvent *)innerEvent withLastQueuedData:(__kindof id<BLData>)lastQueuedData;

@end


NS_ASSUME_NONNULL_END

// TODO: rename inner -> original?
