//
//  BLDataEvent.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataEvent.h"

@implementation BLDataEvent

- (instancetype)initWithUpdatedDataProvider:(id<BLStaticDataProvider>)updatedDataProvider
                                   dataDiff:(id<BLDataDiff>)dataDiff
                                    context:(NSDictionary *)context
{
    NSParameterAssert(updatedDataProvider != nil);
    NSParameterAssert(dataDiff != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _updatedDataProvider = updatedDataProvider;
    _dataDiff = dataDiff;
    _context = context;
    
    return self;    
}

@end
