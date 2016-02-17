//
//  BLNilDataEventProcessor.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataEventProcessor.h"

NS_ASSUME_NONNULL_BEGIN


@interface BLNilDataEventProcessor : NSObject <BLDataEventProcessor>

+ (instancetype)processor;

@end


NS_ASSUME_NONNULL_END