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

- (void)calculateFilteredSections {
    if (_filter.predicate == nil) {
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

#pragma mark - BLData

- (NSInteger)numberOfSections {
    if (self.full) {
        return [super numberOfSections];
    }
    
    return self.filteredSections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    if (self.full) {
        return [super numberOfItemsInSection:section];
    }
    
    NSOrderedSet<NSIndexPath *> *originalIndexPaths = self.filteredSections[section];
    return originalIndexPaths.count;
}

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.full) {
        return [super itemAtIndexPath:indexPath];
    }
    
    NSIndexPath *originalIndexPath = [self mappedIndexPathToOriginal:indexPath];
    return [self.originalData itemAtIndexPath:originalIndexPath];
}

- (NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId {
    if (self.full) {
        return [super indexPathForItemWithId:itemId];
    }
    
    return self.filteredIndexPathsByItemId[itemId];
}

#pragma mark - BLIndexPathMapping

- (BOOL)isIdentical {
    return [self isFull];
}

- (BOOL)isFull {
    // TODO: this is not quite correct
    return self.filter.predicate == nil;
}

- (NSIndexPath *)originalIndexPathToMapped:(NSIndexPath *)originalIndexPath {
    if (self.full) {
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

- (NSIndexPath *)mappedIndexPathToOriginal:(NSIndexPath *)mappedIndexPath {
    if (self.full) {
        return mappedIndexPath;
    }
    
    NSOrderedSet<NSIndexPath *> *originalIndexPaths = self.filteredSections[mappedIndexPath.bl_section];
    return originalIndexPaths[mappedIndexPath.bl_row];
}

@end
