//
//  BLLocalizedIndexedCollationDataProvider.m
//  Boilerdata
//
//  Created by Makarov Yury on 01/04/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLLocalizedIndexedCollationDataProvider.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLLocalizedIndexedCollationData.h"
#import "BLDataEvent.h"
#import "NSString+BLSectionItem.h"

@implementation BLLocalizedIndexedCollationDataProvider

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider stringifierBlock:(BLDataItemStringifierBlock)stringifierBlock {
    UILocalizedIndexedCollation *collation = [UILocalizedIndexedCollation currentCollation];
    
    return [super initWithDataProvider:dataProvider classificationBlock:^id<BLSectionItem>(id<BLDataItem> dataItem) {
        NSString *string = stringifierBlock(dataItem);
        NSUInteger sectionIndex = [collation sectionForObject:string collationStringSelector:@selector(self)];
        return [collation.sectionTitles objectAtIndex:sectionIndex];
        
    } sectionSortingBlock:^NSArray<id<BLSectionItem>> *(NSArray<id<BLSectionItem>> *sectionItems) {
        NSOrderedSet<NSString *> *collactionTitles = [NSOrderedSet orderedSetWithArray:collation.sectionTitles];
        
        return [sectionItems sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
            return [@([collactionTitles indexOfObject:obj1]) compare:@([collactionTitles indexOfObject:obj2])];
        }];
    }];
}

#pragma mark - BLChainDataProvider

- (id<BLData>)transformInnerDataForEvent:(BLDataEvent *)innerEvent withLastQueuedData:(id<BLData>)lastQueuedData {
    id<BLData> data = [super transformInnerDataForEvent:innerEvent withLastQueuedData:lastQueuedData];
    return [[BLLocalizedIndexedCollationData alloc] initWithOriginalData:data];
}

@end
