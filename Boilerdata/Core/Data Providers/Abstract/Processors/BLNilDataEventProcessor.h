//
//  BLNilDataEventProcessor.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataEventProcessor.h"

@interface BLNilDataEventProcessor : NSObject <BLDataEventProcessor>

+ (instancetype)sharedInstance;

@end
