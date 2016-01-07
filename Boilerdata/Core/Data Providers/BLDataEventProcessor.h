//
//  BLDataEventProcessor.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataEventProcessor <NSObject>

- (void)applyEventWithDataUpdateBlock:(void (^)())dataUpdateBlock
            individualItemUpdateBlock:(void (^)())individualItemUpdateBlock
                           completion:(void (^)())completion;

@end
