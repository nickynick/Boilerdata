//
//  BLChainDataEventProcessor.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLDataEventProcessor.h"

@interface BLChainDataEventProcessor : NSObject <BLDataEventProcessor>

@property (nonatomic, strong) id<BLDataEventProcessor> innerProcessor;

@end
