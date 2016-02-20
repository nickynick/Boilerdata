//
//  BLDataUtils.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 20/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataUtils.h"
#import "BLData.h"
#import "BLDataItem.h"
#import "NSIndexPath+BLUtils.h"

@interface _BLDataUtils ()

@property (nonatomic, strong, readonly) id<BLData> data;

@end


@implementation _BLDataUtils

#pragma mark - Init

- (instancetype)initWithData:(id<BLData>)data {
    self = [super init];
    if (!self) return nil;
    
    _data = data;
    
    return self;
}

_BLDataUtils *BLDataUtils(id<BLData> data) {
    return [[_BLDataUtils alloc] initWithData:data];
}

#pragma mark - Public

- (BOOL)isEmpty {
    for (NSInteger section = 0; section < [self.data numberOfSections]; ++section) {
        if ([self.data numberOfItemsInSection:section] > 0) {
            return NO;
        }
    }
    
    return YES;
}

- (NSInteger)numberOfItems {
    NSInteger count = 0;
    
    for (NSInteger section = 0; section < [self.data numberOfSections]; ++section) {
        count += [self.data numberOfItemsInSection:section];
    }
    
    return count;
}

- (NSArray<id<BLDataItem>> *)itemsInSection:(NSInteger)section {
    NSInteger numberOfItems = [self.data numberOfItemsInSection:section];
    NSMutableArray<id<BLDataItem>> *items = [NSMutableArray arrayWithCapacity:numberOfItems];
    
    for (NSInteger row = 0; row < numberOfItems; ++row) {
        [items addObject:[self.data itemAtIndexPath:[NSIndexPath bl_indexPathForRow:row inSection:section]]];
    }
    
    return items;
}

- (NSDictionary<id<BLDataItemId>,id<BLDataItem>> *)itemsById {
    NSMutableDictionary<id<BLDataItemId>, id<BLDataItem>> *items = [NSMutableDictionary dictionaryWithCapacity:[self numberOfItems]];
    
    [self enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
        items[item.itemId] = item;
    }];
    
    return items;
}

- (NSArray<id<BLSectionItem>> *)sectionItems {
    NSInteger numberOfSections = [self.data numberOfSections];
    NSMutableArray<id<BLSectionItem>> *items = [NSMutableArray arrayWithCapacity:numberOfSections];
    
    for (NSInteger section = 0; section < numberOfSections; ++section) {
        [items addObject:[self.data itemForSection:section]];
    }
    
    return items;
}

- (void)enumerateItemsWithBlock:(BLDataItemEnumerationBlock)block {
    BOOL stop = NO;
    
    for (NSInteger section = 0; section < [self.data numberOfSections]; ++section) {
        for (NSInteger row = 0; row < [self.data numberOfItemsInSection:section]; ++row) {
            NSIndexPath *indexPath = [NSIndexPath bl_indexPathForRow:row inSection:section];
            id<BLDataItem> item = [self.data itemAtIndexPath:indexPath];
            
            block(item, indexPath, &stop);
            
            if (stop) {
                return;
            }
        }
    }
}

@end
