//
//  BLLocalizedIndexedCollationData.m
//  Boilerdata
//
//  Created by Makarov Yury on 01/04/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLLocalizedIndexedCollationData.h"
#import "NSString+BLSectionItem.h"

@interface BLLocalizedIndexedCollationData ()

@property (nonatomic, strong, readonly) UILocalizedIndexedCollation *collation;
@property (nonatomic, copy, readonly) NSArray<id<BLSectionItem>> *sections;

@end

@implementation BLLocalizedIndexedCollationData

- (instancetype)initWithOriginalData:(id<BLData>)originalData {
    self = [super initWithOriginalData:originalData];
    if (!self) return nil;
    
    _collation = [UILocalizedIndexedCollation currentCollation];
    _sections = [self availableSections];
    
    return self;
}

- (NSArray<id<BLSectionItem>> *)availableSections {
    NSMutableArray *mutableSections = [NSMutableArray array];
    
    for (NSInteger idx = 0; idx < [self.originalData numberOfSections]; ++idx) {
        id<BLSectionItem> section = [self.originalData itemForSection:idx];
        [mutableSections addObject:section];
    }
    return [mutableSections copy];
}

#pragma mark - BLData

- (NSArray<NSString *> *)sectionIndexTitles {
    return self.collation.sectionIndexTitles;
}

- (NSInteger)sectionForSectionIndexTitleAtIndex:(NSInteger)index {
    NSString *title = [self.collation.sectionTitles objectAtIndex:index];
    return [self.sections indexOfObject:title];
}

@end
