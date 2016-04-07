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
#import "BLSectionsData.h"
#import "BLDataSection.h"
#import "BLDataUtils.h"
#import "NSIndexPath+BLUtils.h"

@interface BLClassifiedData ()

@property (nonatomic, strong, readonly) id<BLData> unclassifiedData;

@property (nonatomic, strong, readonly) NSDictionary<id<BLDataItemId>, NSIndexPath *> *classifiedIndexPaths;

@end


@implementation BLClassifiedData

#pragma mark - Init

- (instancetype)initWithOriginalData:(id<BLData>)originalData
                 classificationBlock:(BLDataItemClassificationBlock)classificationBlock
                 sectionSortingBlock:(BLSectionItemSortingBlock)sectionSortingBlock {
    self = [super initWithOriginalData:[self calculateSectionsDataWithOriginalData:originalData
                                                               classificationBlock:classificationBlock
                                                               sectionSortingBlock:sectionSortingBlock]];
    if (!self) return nil;
    
    _unclassifiedData = originalData;
    
    _classifiedIndexPaths = [self calculateClassifiedIndexPaths];
    
    return self;
}

- (BLSectionsData *)calculateSectionsDataWithOriginalData:(id<BLData>)originalData
                                      classificationBlock:(BLDataItemClassificationBlock)classificationBlock
                                      sectionSortingBlock:(BLSectionItemSortingBlock)sectionSortingBlock {
    // TODO: assert that original data only has 0 or 1 section
    
    NSMutableOrderedSet<id<BLSectionItem>> *sectionItems = [NSMutableOrderedSet orderedSet];
    NSMutableDictionary<id<BLSectionItem>, NSMutableArray<id<BLDataItem>> *> *classifiedItems = [NSMutableDictionary dictionary];
    
    [BLDataUtils(originalData) enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
        id<BLSectionItem> sectionItem = classificationBlock(item);
        [sectionItems addObject:sectionItem];
        
        NSMutableArray<id<BLDataItem>> *items = classifiedItems[sectionItem];
        if (!items) {
            items = [NSMutableArray array];
            classifiedItems[sectionItem] = items;
        }
        
        [items addObject:item];
    }];
    
    NSArray<id<BLSectionItem>> *sortedSectionItems = [self sortSectionItems:sectionItems.array withBlock:sectionSortingBlock];
    
    NSMutableArray<id<BLDataSection>> *sections = [NSMutableArray arrayWithCapacity:sectionItems.count];
    
    for (id<BLSectionItem> sectionItem in sortedSectionItems) {
        id<BLDataSection> section = [[BLDataSection alloc] initWithItems:classifiedItems[sectionItem]
                                                             sectionItem:sectionItem];
        [sections addObject:section];
    }
    
    return [[BLSectionsData alloc] initWithSections:sections];
}

- (NSArray<id<BLSectionItem>> *)sortSectionItems:(NSArray<id<BLSectionItem>> *)sectionItems
                                       withBlock:(BLSectionItemSortingBlock)block {
    if (!block) {
        return sectionItems;
    }
    
    NSArray<id<BLSectionItem>> *sortedSectionItems = block(sectionItems);
    // TODO: check that all items are present
    
    return sortedSectionItems;
}

- (NSDictionary<id<BLDataItemId>, NSIndexPath *> *)calculateClassifiedIndexPaths {
    NSMutableDictionary<id<BLDataItemId>, NSIndexPath *> *classifiedIndexPaths =
        [NSMutableDictionary dictionaryWithCapacity:[BLDataUtils(self.originalData) numberOfItems]];
    
    [BLDataUtils(self) enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
        classifiedIndexPaths[item.itemId] = indexPath;
    }];
    
    return classifiedIndexPaths;
}

#pragma mark - BLData

- (NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId {
    NSIndexPath *originalIndexPath = [self.unclassifiedData indexPathForItemWithId:itemId];
    return originalIndexPath ? [self originalIndexPathToMapped:originalIndexPath] : nil;
}

#pragma mark - BLIndexPathMapping

- (BOOL)isIdentical {
    return [self numberOfSections] <= 1;
}

- (BOOL)isFull {
    return YES;
}

- (NSIndexPath *)originalIndexPathToMapped:(NSIndexPath *)originalIndexPath {
    id<BLDataItem> originalItem = [self.unclassifiedData itemAtIndexPath:originalIndexPath];
    return self.classifiedIndexPaths[originalItem.itemId];
}

- (NSIndexPath *)mappedIndexPathToOriginal:(NSIndexPath *)mappedIndexPath {
    id<BLDataItem> item = [self itemAtIndexPath:mappedIndexPath];
    return [self.unclassifiedData indexPathForItemWithId:item.itemId];
}

@end
