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
#import "BLSimpleDataDiff.h"
#import "BLUtils.h"

#import <NNArrayDiff/ArrayDiff.h>
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
        [convertedSections addObject:[[NNSection alloc] initWithKey:section.headerItem.itemId objects:section.items]];
    }
    
    return convertedSections;
}

+ (NSArray<NNSection *> *)sectionsWithData:(id<BLData>)data {
    NSInteger numberOfSections = [data numberOfSections];
    NSMutableArray<NNSection *> *sections = [NSMutableArray arrayWithCapacity:numberOfSections];
    
    for (NSInteger section = 0; section < numberOfSections; ++section) {
        NSArray<id<BLDataItem>> *items = [BLUtils data:data itemsInSection:section];
        
        id key;
        if ([data respondsToSelector:@selector(titleForSection:)]) {
            key = [data titleForSection:section];
        }
        if (!key) {
            key = @(section);
        }
        
        [sections addObject:[[NNSection alloc] initWithKey:key objects:items]];
    }
    
    return sections;
}

@end
