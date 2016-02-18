//
//  BLSearchIndexData.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLSearchIndexData.h"

@implementation BLSearchIndexData

#pragma mark - BLData

- (NSArray<NSString *> *)sectionIndexTitles {
    return [@[ UITableViewIndexSearch ] arrayByAddingObjectsFromArray:[super sectionIndexTitles]];
}

- (NSInteger)sectionForSectionIndexTitleAtIndex:(NSInteger)index {
    return index == 0 ? NSNotFound : [super sectionForSectionIndexTitleAtIndex:index - 1];
}

@end
