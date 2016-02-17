//
//  BLChainDataEventProcessor.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataEventProcessor.h"

@class BLDataEventCallbacks;

NS_ASSUME_NONNULL_BEGIN


@interface BLChainDataEventProcessor : NSObject <BLDataEventProcessor>

@property (nonatomic, strong, readonly) BLDataEventCallbacks *callbacks;

@end


NS_ASSUME_NONNULL_END