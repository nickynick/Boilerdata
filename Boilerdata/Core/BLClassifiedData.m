//
//  BLClassifiedData.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 19/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLClassifiedData.h"
#import "BLDataItem.h"
#import "BLSectionItem.h"
#import "BLDataSection.h"
#import "BLUtils.h"
#import "NSIndexPath+BLUtils.h"

@interface BLClassifiedData ()

@property (nonatomic, copy, readonly) BLDataItemClassificationBlock classificationBlock;
@property (nonatomic, copy, readonly) BLSectionItemSortingBlock sectionSortingBlock;

@property (nonatomic, strong, readonly) NSArray<id<BLDataSection>> *sections;

@property (nonatomic, strong, readonly) NSDictionary<id<BLDataItemId>, NSIndexPath *> *classifiedIndexPaths;

@end


@implementation BLClassifiedData

#pragma mark - Init

- (instancetype)initWithOriginalData:(id<BLData>)originalData
                 classificationBlock:(BLDataItemClassificationBlock)classificationBlock
                 sectionSortingBlock:(BLSectionItemSortingBlock)sectionSortingBlock {
    self = [super initWithOriginalData:originalData];
    if (!self) return nil;
    
    // TODO: assert that original data only has 0 or 1 section
    
    _classificationBlock = [classificationBlock copy];
    _sectionSortingBlock = [sectionSortingBlock copy];
    
    _sections = [self calculateSections];
    _classifiedIndexPaths = [self calculateClassifiedIndexPaths];
    
    return self;
}

#pragma mark - Classification

- (NSArray<id<BLDataSection>> *)calculateSections {
    NSMutableOrderedSet<id<BLSectionItem>> *sectionItems = [NSMutableOrderedSet orderedSet];
    NSMutableDictionary<id<BLSectionItem>, NSMutableArray<id<BLDataItem>> *> *classifiedItems = [NSMutableDictionary dictionary];
    
    [BLUtils data:self.originalData enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
        id<BLSectionItem> sectionItem = self.classificationBlock(item);
        [sectionItems addObject:sectionItem];
        
        NSMutableArray<id<BLDataItem>> *items = classifiedItems[sectionItem];
        if (!items) {
            items = [NSMutableArray array];
            classifiedItems[sectionItem] = items;
        }
        
        [items addObject:item];
    }];
    
    NSArray<id<BLSectionItem>> *sortedSectionItems = [self sortSectionItems:sectionItems.array];
    
    NSMutableArray<id<BLDataSection>> *sections = [NSMutableArray arrayWithCapacity:sectionItems.count];
    
    for (id<BLSectionItem> sectionItem in sortedSectionItems) {
        id<BLDataSection> section = [[BLDataSection alloc] initWithItems:classifiedItems[sectionItem]
                                                             sectionItem:sectionItem];
        [sections addObject:section];
    }
    
    return sections;
}

- (NSArray<id<BLSectionItem>> *)sortSectionItems:(NSArray<id<BLSectionItem>> *)sectionItems {
    if (!self.sectionSortingBlock) {
        return sectionItems;
    }
    
    NSArray<id<BLSectionItem>> *sortedSectionItems = self.sectionSortingBlock(sectionItems);
    // TODO: check that all items are present
    
    return sortedSectionItems;
}

- (NSDictionary<id<BLDataItemId>, NSIndexPath *> *)calculateClassifiedIndexPaths {
    NSMutableDictionary<id<BLDataItemId>, NSIndexPath *> *classifiedIndexPaths =
        [NSMutableDictionary dictionaryWithCapacity:[BLUtils dataNumberOfItems:self.originalData]];
    
    [BLUtils data:self enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
        classifiedIndexPaths[item.itemId] = indexPath;
    }];
    
    return classifiedIndexPaths;
}

#pragma mark - BLData

- (NSInteger)numberOfSections {
    return self.sections.count;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return self.sections[section].items.count;
}

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    return self.sections[indexPath.bl_section].items[indexPath.bl_row];
}

- (NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId {
    NSIndexPath *originalIndexPath = [super indexPathForItemWithId:itemId];
    return originalIndexPath ? [self originalIndexPathToMapped:originalIndexPath] : nil;
}

- (id<BLSectionItem>)itemForSection:(NSInteger)section {
    return self.sections[section].sectionItem;
}

#pragma mark - BLIndexPathMapping

- (BOOL)isIdentical {
    return self.sections.count <= 1;
}

- (BOOL)isFull {
    return YES;
}

- (NSIndexPath *)originalIndexPathToMapped:(NSIndexPath *)originalIndexPath {
    id<BLDataItem> originalItem = [self.originalData itemAtIndexPath:originalIndexPath];
    return self.classifiedIndexPaths[originalItem.itemId];
}

- (NSIndexPath *)mappedIndexPathToOriginal:(NSIndexPath *)mappedIndexPath {
    id<BLDataItem> item = [self itemAtIndexPath:mappedIndexPath];
    return [self.originalData indexPathForItemWithId:item.itemId];
}

@end
