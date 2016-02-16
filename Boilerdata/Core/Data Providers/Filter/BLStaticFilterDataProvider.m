//
//  BLStaticFilterDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLStaticFilterDataProvider.h"
#import "BLStaticDataProviderProxy+Subclassing.h"
#import "BLDataItemFilter.h"
#import "BLDataItem.h"
#import "NSIndexPath+BLUtils.h"

@interface BLStaticFilterDataProvider ()

@property (strong, readonly, nonatomic) NSArray<NSOrderedSet<NSIndexPath *> *> *filteredSections;
@property (strong, readonly, nonatomic) NSMutableDictionary<id<BLDataItemId>, NSIndexPath *> *filteredIndexPathsByItemId;

@end


@implementation BLStaticFilterDataProvider

#pragma mark - Init

- (instancetype)initWithFullDataProvider:(id<BLStaticDataProvider>)fullDataProvider filter:(BLDataItemFilter *)filter {
    self = [super init];
    if (!self) return nil;
    
    self.staticDataProvider = fullDataProvider;
    
    _fullDataProvider = fullDataProvider;
    _filter = filter;
    
    [self calculateFilteredSectionsWithFilter:filter];
    
    return self;
}

#pragma mark - Public

- (BOOL)isIdentical {
    return self.filter.predicate == nil;
}

- (NSIndexPath *)filteredIndexPathToFull:(NSIndexPath *)filteredIndexPath {
    if (self.identical) {
        return filteredIndexPath;
    }
    
    NSOrderedSet *fullIndexPaths = self.filteredSections[filteredIndexPath.bl_section];
    return fullIndexPaths[filteredIndexPath.bl_row];
}

- (NSIndexPath *)fullIndexPathToFiltered:(NSIndexPath *)fullIndexPath {
    if (self.identical) {
        return fullIndexPath;
    }
    
    NSOrderedSet *fullIndexPaths = self.filteredSections[fullIndexPath.bl_section];
    NSInteger filteredIndex = [fullIndexPaths indexOfObject:fullIndexPath];
    if (filteredIndex != NSNotFound) {
        return [NSIndexPath bl_indexPathForRow:filteredIndex inSection:fullIndexPath.bl_section];
    } else {
        return nil;
    }
}

#pragma mark - Private

- (void)calculateFilteredSectionsWithFilter:(BLDataItemFilter *)filter {
    if (self.identical) {
        return;
    }
    
    NSMutableArray<NSOrderedSet *> *sections = [NSMutableArray arrayWithCapacity:[self.fullDataProvider numberOfSections]];
    NSMutableDictionary<id<BLDataItemId>, NSIndexPath *> *filteredIndexPathsByItemId = [NSMutableDictionary dictionary];
    
    for (NSInteger section = 0; section < [self.fullDataProvider numberOfSections]; ++section) {
        NSMutableOrderedSet *fullIndexPaths = [NSMutableOrderedSet orderedSet];
        
        for (NSInteger row = 0; row < [self.fullDataProvider numberOfItemsInSection:section]; ++row) {
            NSIndexPath *indexPath = [NSIndexPath bl_indexPathForRow:row inSection:section];
            id<BLDataItem> item = [self.fullDataProvider itemAtIndexPath:indexPath];
            if ([filter filterItem:item]) {
                [fullIndexPaths addObject:indexPath];
                
                NSIndexPath *filteredIndexPath = [NSIndexPath bl_indexPathForRow:fullIndexPaths.count - 1 inSection:section];
                filteredIndexPathsByItemId[item.itemId] = filteredIndexPath;
            }
        }
        
        [sections addObject:fullIndexPaths];
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
    
    NSOrderedSet *fullIndexPaths = self.filteredSections[section];
    return fullIndexPaths.count;
}

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.identical) {
        return [super itemAtIndexPath:indexPath];
    }
    
    NSIndexPath *fullIndexPath = [self filteredIndexPathToFull:indexPath];
    return [self.fullDataProvider itemAtIndexPath:fullIndexPath];
}

- (NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId {
    if (self.identical) {
        return [super indexPathForItemWithId:itemId];
    }
    
    return self.filteredIndexPathsByItemId[itemId];
}

@end
