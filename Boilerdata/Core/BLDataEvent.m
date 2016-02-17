//
//  BLDataEvent.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataEvent.h"

@implementation BLDataEvent

- (instancetype)initWithUpdatedData:(id<BLData>)updatedData
                           dataDiff:(id<BLDataDiff>)dataDiff
                            context:(NSDictionary *)context {
    self = [super init];
    if (!self) return nil;
    
    _updatedData = updatedData;
    _dataDiff = dataDiff;
    _context = [context copy] ?: @{};
    
    return self;    
}

@end
