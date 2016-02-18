//
//  BLSearchIndexDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLSearchIndexDataProvider.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLSearchIndexData.h"
#import "BLDataEvent.h"

@implementation BLSearchIndexDataProvider

#pragma mark - Init

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider {
    self = [super init];
    if (!self) return nil;
    
    [self updateInnerDataProvider:dataProvider];
    
    return self;
}

#pragma mark - Chaining

- (BLDataEvent *)handleInnerDataEvent:(BLDataEvent *)event {
    return [[BLDataEvent alloc] initWithUpdatedData:[[BLSearchIndexData alloc] initWithOriginalData:event.updatedData]
                                           dataDiff:event.dataDiff
                                            context:event.context];
}

@end
