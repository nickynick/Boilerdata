//
//  BLDataObserver.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataProvider;
@protocol BLDataEventProcessor;
@class BLDataEvent;


@protocol BLDataObserver <NSObject>

- (id<BLDataEventProcessor>)dataProvider:(id<BLDataProvider>)dataProvider willUpdateWithEvent:(BLDataEvent *)event;

@end
