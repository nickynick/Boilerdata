//
//  BLChainDataProvider+Subclassing.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataProvider.h"

@class BLDataEvent;


@interface BLChainDataProvider ()

@property (nonatomic, strong) id<BLDataProvider> innerDataProvider;

- (BLDataEvent *)transformInnerDataEvent:(BLDataEvent *)event;

@end
