//
//  BLNilDataEventProcessor.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLNilDataEventProcessor.h"

@implementation BLNilDataEventProcessor

+ (instancetype)sharedInstance {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (void)applyEventWithDataUpdateBlock:(void (^)())dataUpdateBlock
            individualItemUpdateBlock:(void (^)())individualItemUpdateBlock
                           completion:(void (^)())completion
{
    dataUpdateBlock();
    individualItemUpdateBlock();
    completion();
}

@end
