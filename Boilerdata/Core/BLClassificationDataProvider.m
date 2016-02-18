//
//  BLClassificationDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLClassificationDataProvider.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLData.h"
#import "BLDataItem.h"
#import "BLSectionItem.h"
#import "BLDataEvent.h"
#import "BLDataSection.h"
#import "BLUtils.h"

@interface BLClassificationDataProvider ()

@property (nonatomic, copy, readonly) BLDataItemClassificationBlock classificationBlock;

@property (nonatomic, copy, readonly) BLSectionItemSortingBlock sectionSortingBlock;

@end


@implementation BLClassificationDataProvider

#pragma mark - Init

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider
                 classificationBlock:(BLDataItemClassificationBlock)classificationBlock
                 sectionSortingBlock:(BLSectionItemSortingBlock)sectionSortingBlock {
    self = [super init];
    if (!self) return nil;
    
    [self updateInnerDataProvider:dataProvider];
    
    _classificationBlock = [classificationBlock copy];
    _sectionSortingBlock = [sectionSortingBlock copy];
    
    return self;
}

#pragma mark - Chaining

- (BLDataEvent *)handleInnerDataEvent:(BLDataEvent *)event {
    NSArray<id<BLDataSection>> *sections = [self collectSectionsFromData:event.updatedData];
    
    return event; // TODO
}

- (NSArray<id<BLDataSection>> *)collectSectionsFromData:(id<BLData>)data {
    NSMutableOrderedSet<id<BLSectionItem>> *sectionItems = [NSMutableOrderedSet orderedSet];
    NSMutableDictionary<id<BLSectionItem>, NSMutableArray<id<BLDataItem>> *> *classifiedItems = [NSMutableDictionary dictionary];
    
    [BLUtils data:data enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
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

@end
