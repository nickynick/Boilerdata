//
//  BLDataSection.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataSection.h"

@implementation BLDataSection

#pragma mark - Init

- (instancetype)init {
    return [self initWithItems:nil headerItem:nil];
}

- (instancetype)initWithItems:(NSArray<id<BLDataItem>> *)items headerItem:(id<BLDataItem>)headerItem {
    NSParameterAssert(headerItem != nil);
    
    self = [super init];
    if (!self) return nil;

    _items = items;
    _headerItem = headerItem;
    
    return self;
}

#pragma mark - BLDataSection

@synthesize items = _items;
@synthesize headerItem = _headerItem;

@end
