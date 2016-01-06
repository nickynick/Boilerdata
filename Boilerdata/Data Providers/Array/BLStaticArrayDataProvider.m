//
//  BLStaticArrayDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLStaticArrayDataProvider.h"
#import "BLDataItem.h"
#import "NSIndexPath+BLUtils.h"

@implementation BLStaticArrayDataProvider

#pragma mark - Init

- (instancetype)initWithItems:(NSArray<id<BLDataItem>> *)items {
    self = [super init];
    if (!self) return nil;
    
    _items = [items copy];
    
    return self;
}

#pragma mark - BLStaticDataProvider

- (NSInteger)numberOfSections {
    return 1;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.items.count;
}

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.items[indexPath.bl_item];
}

- (NSIndexPath *)indexPathForItemWithId:(id)itemId {
    __block NSIndexPath *result = nil;
    
    [self.items enumerateObjectsUsingBlock:^(id<BLDataItem> item, NSUInteger idx, BOOL *stop) {
        if ([item.itemId isEqual:itemId]) {
            result = [NSIndexPath bl_indexPathForItem:idx inSection:0];
            *stop = YES;
        }
    }];
    
    return result;
}

@end
