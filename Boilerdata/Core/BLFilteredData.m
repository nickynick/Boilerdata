//
//  BLFilteredData.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLFilteredData.h"
#import "BLDataItemFilter.h"
#import "BLDataItem.h"
#import "NSIndexPath+BLUtils.h"

@interface BLFilteredData ()

@property (strong, readonly, nonatomic) NSArray<NSOrderedSet<NSIndexPath *> *> *filteredSections;
@property (strong, readonly, nonatomic) NSMutableDictionary<id<BLDataItemId>, NSIndexPath *> *filteredIndexPathsByItemId;

@end


@implementation BLFilteredData

#pragma mark - Init

- (instancetype)initWithOriginalData:(id<BLData>)originalData {
    return [self initWithOriginalData:originalData filter:nil];
}

- (instancetype)initWithOriginalData:(id<BLData>)originalData filter:(BLDataItemFilter *)filter {
    self = [super initWithOriginalData:originalData];
    if (!self) return nil;
    
    _filter = filter;
    [self calculateFilteredSections];
    
    return self;
}

#pragma mark - Public

- (BOOL)isIdentical {
    return self.filter.predicate == nil;
}

- (NSIndexPath *)filteredIndexPathToOriginal:(NSIndexPath *)filteredIndexPath {
    if (self.identical) {
        return filteredIndexPath;
    }
    
    NSOrderedSet<NSIndexPath *> *originalIndexPaths = self.filteredSections[filteredIndexPath.bl_section];
    return originalIndexPaths[filteredIndexPath.bl_row];
}

- (NSIndexPath *)originalIndexPathToFiltered:(NSIndexPath *)originalIndexPath {
    if (self.identical) {
        return originalIndexPath;
    }
    
    NSOrderedSet<NSIndexPath *> *originalIndexPaths = self.filteredSections[originalIndexPath.bl_section];
    NSInteger filteredIndex = [originalIndexPaths indexOfObject:originalIndexPath];
    
    if (filteredIndex != NSNotFound) {
        return [NSIndexPath bl_indexPathForRow:filteredIndex inSection:originalIndexPath.bl_section];
    } else {
        return nil;
    }
}

#pragma mark - Private

- (void)calculateFilteredSections {
    if (self.identical) {
        return;
    }
    
    NSMutableArray<NSOrderedSet *> *sections = [NSMutableArray arrayWithCapacity:[self.originalData numberOfSections]];
    NSMutableDictionary<id<BLDataItemId>, NSIndexPath *> *filteredIndexPathsByItemId = [NSMutableDictionary dictionary];
    
    for (NSInteger section = 0; section < [self.originalData numberOfSections]; ++section) {
        NSMutableOrderedSet<NSIndexPath *> *originalIndexPaths = [NSMutableOrderedSet orderedSet];
        
        for (NSInteger row = 0; row < [self.originalData numberOfItemsInSection:section]; ++row) {
            NSIndexPath *indexPath = [NSIndexPath bl_indexPathForRow:row inSection:section];
            id<BLDataItem> item = [self.originalData itemAtIndexPath:indexPath];
            if ([_filter evaluateItem:item]) {
                [originalIndexPaths addObject:indexPath];
                
                NSIndexPath *filteredIndexPath = [NSIndexPath bl_indexPathForRow:originalIndexPaths.count - 1 inSection:section];
                filteredIndexPathsByItemId[item.itemId] = filteredIndexPath;
            }
        }
        
        [sections addObject:originalIndexPaths];
    }
    
    _filteredSections = sections;
    _filteredIndexPathsByItemId = filteredIndexPathsByItemId;
}

#pragma mark - BLStaticDataProvider

- (NSInteger)numberOfSections {
    if (self.identical) {
        return [super numberOfSections];
    }
    
    return self.filteredSections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (self.identical) {
        return [super numberOfItemsInSection:section];
    }
    
    NSOrderedSet<NSIndexPath *> *originalIndexPaths = self.filteredSections[section];
    return originalIndexPaths.count;
}

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.identical) {
        return [super itemAtIndexPath:indexPath];
    }
    
    NSIndexPath *originalIndexPath = [self filteredIndexPathToOriginal:indexPath];
    return [self.originalData itemAtIndexPath:originalIndexPath];
}

- (NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId {
    if (self.identical) {
        return [super indexPathForItemWithId:itemId];
    }
    
    return self.filteredIndexPathsByItemId[itemId];
}

@end
