//
//  BLDataDiffCalculator.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataDiffCalculator.h"
#import "BLData.h"
#import "BLDataItem.h"
#import "BLDataSection.h"
#import "BLIndexPathMapping.h"
#import "BLSimpleDataDiff.h"
#import "BLMutableDataDiff.h"
#import "BLMutableDataDiffChange.h"
#import "BLDataUtils.h"

#import <NNArrayDiff/ArrayDiff.h>
#import "NNArrayDiff+BLDataDiff.h"
#import "NNSectionsDiff+BLDataDiff.h"


@implementation BLDataDiffCalculator

+ (id<BLDataDiff>)diffForDataBefore:(id<BLData>)dataBefore dataAfter:(id<BLData>)dataAfter {
    return [self diffForDataBefore:dataBefore dataAfter:dataAfter updatedBlock:nil];
}

+ (id<BLDataDiff>)diffForDataBefore:(id<BLData>)dataBefore
                          dataAfter:(id<BLData>)dataAfter
                       updatedBlock:(BLDataItemUpdatedBlock)updatedBlock {
    if ([dataBefore numberOfSections] == 0) {
        return [[BLSimpleDataDiff alloc] initWithNumberOfSections:[dataAfter numberOfSections] inserted:YES];
    }
    
    if ([dataAfter numberOfSections] == 0) {
        return [[BLSimpleDataDiff alloc] initWithNumberOfSections:[dataBefore numberOfSections] inserted:NO];
    }
    
    NNSectionsDiffCalculator *calculator = [self calculatorWithUpdatedBlock:updatedBlock];
    return [calculator calculateDiffForSectionsBefore:[self sectionsWithData:dataBefore]
                                             andAfter:[self sectionsWithData:dataAfter]];
}

+ (id<BLDataDiff>)diffForItemsBefore:(NSArray<id<BLDataItem>> *)itemsBefore
                          itemsAfter:(NSArray<id<BLDataItem>> *)itemsAfter {
    return [self diffForItemsBefore:itemsBefore itemsAfter:itemsAfter updatedBlock:nil];
}

+ (id<BLDataDiff>)diffForItemsBefore:(NSArray<id<BLDataItem>> *)itemsBefore
                          itemsAfter:(NSArray<id<BLDataItem>> *)itemsAfter
                        updatedBlock:(BLDataItemUpdatedBlock)updatedBlock {
    NNSectionsDiffCalculator *calculator = [self calculatorWithUpdatedBlock:updatedBlock];
    return [calculator calculateDiffForSingleSectionObjectsBefore:itemsBefore andAfter:itemsAfter];
}

+ (id<BLDataDiff>)diffForSectionsBefore:(NSArray<id<BLDataSection>> *)sectionsBefore
                          sectionsAfter:(NSArray<id<BLDataSection>> *)sectionsAfter {
    return [self diffForSectionsBefore:sectionsBefore sectionsAfter:sectionsAfter updatedBlock:nil];
}

+ (id<BLDataDiff>)diffForSectionsBefore:(NSArray<id<BLDataSection>> *)sectionsBefore
                          sectionsAfter:(NSArray<id<BLDataSection>> *)sectionsAfter
                           updatedBlock:(BLDataItemUpdatedBlock)updatedBlock {
    if (sectionsBefore.count == 0) {
        return [[BLSimpleDataDiff alloc] initWithNumberOfSections:sectionsAfter.count inserted:YES];
    }
    
    if (sectionsAfter.count == 0) {
        return [[BLSimpleDataDiff alloc] initWithNumberOfSections:sectionsBefore.count inserted:NO];
    }
    
    NNSectionsDiffCalculator *calculator = [self calculatorWithUpdatedBlock:updatedBlock];
    return [calculator calculateDiffForSectionsBefore:[self convertSections:sectionsBefore]
                                             andAfter:[self convertSections:sectionsAfter]];
}

+ (id<BLDataDiff>)indexPathDiffWithOriginalDiff:(id<BLDataDiff>)originalDiff
                                  mappingBefore:(id<BLIndexPathMapping>)mappingBefore
                                   mappingAfter:(id<BLIndexPathMapping>)mappingAfter {
    if (mappingBefore.identical && mappingAfter.identical) {
        return originalDiff;
    }
    
    BLMutableDataDiff *diff = [[BLMutableDataDiff alloc] init];
    
    for (NSIndexPath *originalIndexPath in originalDiff.deletedIndexPaths) {
        NSIndexPath *indexPath = [mappingBefore originalIndexPathToMapped:originalIndexPath];
        if (indexPath) {
            [diff.deletedIndexPaths addObject:indexPath];
        }
    }
    
    for (NSIndexPath *originalIndexPath in originalDiff.insertedIndexPaths) {
        NSIndexPath *indexPath = [mappingAfter originalIndexPathToMapped:originalIndexPath];
        if (indexPath) {
            [diff.insertedIndexPaths addObject:indexPath];
        }
    }
    
    for (id<BLDataDiffIndexPathChange> originalChange in originalDiff.changedIndexPaths) {
        NSIndexPath *indexPathBefore = [mappingBefore originalIndexPathToMapped:originalChange.before];
        NSIndexPath *indexPathAfter = [mappingAfter originalIndexPathToMapped:originalChange.after];
        
        if (indexPathBefore && indexPathAfter) {
            BLMutableDataDiffIndexPathChange *change = [[BLMutableDataDiffIndexPathChange alloc] initWithChange:originalChange];
            change.before = indexPathBefore;
            change.after = indexPathAfter;
            
            [diff.changedIndexPaths addObject:change];
        } else if (indexPathBefore && !indexPathAfter) {
            [diff.deletedIndexPaths addObject:indexPathBefore];
        } else if (!indexPathBefore && indexPathAfter) {
            [diff.insertedIndexPaths addObject:indexPathAfter];
        }
    }
    
    return diff;
}

+ (id<BLDataDiff>)indexPathDiffForMappingUpdateWithMappedDataBefore:(id<BLData, BLIndexPathMapping>)mappedDataBefore
                                                    mappedDataAfter:(id<BLData, BLIndexPathMapping>)mappedDataAfter {
    BLMutableDataDiff *diff = [[BLMutableDataDiff alloc] init];
    
    if (!mappedDataAfter.full) {
        [BLDataUtils(mappedDataBefore) enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
            NSIndexPath *originalIndexPath = [mappedDataBefore mappedIndexPathToOriginal:indexPath];
            if (![mappedDataAfter originalIndexPathToMapped:originalIndexPath]) {
                [diff.deletedIndexPaths addObject:indexPath];
            }
        }];
    }
    
    if (!mappedDataBefore.full) {
        [BLDataUtils(mappedDataAfter) enumerateItemsWithBlock:^(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop) {
            NSIndexPath *originalIndexPath = [mappedDataAfter mappedIndexPathToOriginal:indexPath];
            if (![mappedDataBefore originalIndexPathToMapped:originalIndexPath]) {
                [diff.insertedIndexPaths addObject:indexPath];
            }
        }];
    }
    
    return diff;
}

+ (id<BLDataDiff>)sectionDiffForSectionItemsBefore:(NSArray<id<BLSectionItem>> *)sectionItemsBefore
                                 sectionItemsAfter:(NSArray<id<BLSectionItem>> *)sectionItemsAfter {
    NNArrayDiffCalculator *calculator = [[NNArrayDiffCalculator alloc] init];
    return [calculator calculateDiffForObjectsBefore:sectionItemsBefore andAfter:sectionItemsAfter];
}

#pragma mark - Private

+ (NNSectionsDiffCalculator *)calculatorWithUpdatedBlock:(BLDataItemUpdatedBlock)updatedBlock {
    NNSectionsDiffCalculator *calculator = [[NNSectionsDiffCalculator alloc] init];
    
    calculator.objectIdBlock = ^(id<BLDataItem> item) {
        return item.itemId;
    };
    
    if (updatedBlock) {
        calculator.objectUpdatedBlock = updatedBlock;
    }
    
    return calculator;
}

+ (NSArray<NNSection *> *)convertSections:(NSArray<id<BLDataSection>> *)sections {
    NSMutableArray<NNSection *> *convertedSections = [NSMutableArray arrayWithCapacity:sections.count];
    
    for (id<BLDataSection> section in sections) {
        [convertedSections addObject:[[NNSection alloc] initWithKey:section.sectionItem objects:section.items]];
    }
    
    return convertedSections;
}

+ (NSArray<NNSection *> *)sectionsWithData:(id<BLData>)data {
    NSInteger numberOfSections = [data numberOfSections];
    NSMutableArray<NNSection *> *sections = [NSMutableArray arrayWithCapacity:numberOfSections];
    
    for (NSInteger section = 0; section < numberOfSections; ++section) {
        NSArray<id<BLDataItem>> *items = [BLDataUtils(data) itemsInSection:section];
        
        id key;
        if ([data respondsToSelector:@selector(itemForSection:)]) {
            key = [data itemForSection:section];
        }
        if (!key) {
            key = @(section);
        }
        
        [sections addObject:[[NNSection alloc] initWithKey:key objects:items]];
    }
    
    return sections;
}

@end
