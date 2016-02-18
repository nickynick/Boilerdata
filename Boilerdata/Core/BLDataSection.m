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

- (instancetype)initWithItems:(NSArray<id<BLDataItem>> *)items sectionItem:(id<BLSectionItem>)sectionItem {
    self = [super init];
    if (!self) return nil;

    _items = items;
    _sectionItem = sectionItem;
    
    return self;
}

#pragma mark - BLDataSection

@synthesize items = _items;
@synthesize sectionItem = _sectionItem;

@end
