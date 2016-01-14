//
//  BLUtils.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUtils.h"
#import "BLDataProvider.h"
#import "NSIndexPath+BLUtils.h"
#import "BLDataDiff.h"

@implementation BLUtils

#pragma mark - BLDataProvider stuff

+ (BOOL)dataProviderIsEmpty:(id<BLStaticDataProvider>)dataProvider {
    for (NSInteger section = 0; section < [dataProvider numberOfSections]; ++section) {
        if ([dataProvider numberOfItemsInSection:section] > 0) {
            return NO;
        }
    }
    
    return YES;
}

+ (NSInteger)dataProviderNumberOfItems:(id<BLStaticDataProvider>)dataProvider {
    NSInteger count = 0;
    
    for (NSInteger section = 0; section < [dataProvider numberOfSections]; ++section) {
        count += [dataProvider numberOfItemsInSection:section];
    }
    
    return count;
}

+ (void)dataProvider:(id<BLStaticDataProvider>)dataProvider enumerateItemsWithBlock:(BLDataProviderEnumerationBlock)block {
    BOOL stop = NO;
    
    for (NSInteger section = 0; section < [dataProvider numberOfSections]; ++section) {
        for (NSInteger row = 0; row < [dataProvider numberOfItemsInSection:section]; ++row) {
            NSIndexPath *indexPath = [NSIndexPath bl_indexPathForRow:row inSection:section];
            id<BLDataItem> item = [dataProvider itemAtIndexPath:indexPath];
            
            block(item, indexPath, &stop);
            
            if (stop) {
                return;
            }
        }
    }
}

#pragma mark - BLDataDiff stuff

+ (BOOL)dataDiffIsEmpty:(id<BLDataDiff>)dataDiff {
    return (dataDiff.insertedIndexPaths.count == 0 &&
            dataDiff.deletedIndexPaths.count == 0 &&
            dataDiff.changedIndexPaths.count == 0 &&
            dataDiff.insertedSections.count == 0 &&
            dataDiff.deletedSections.count == 0 &&
            dataDiff.changedSections.count == 0);
}

@end
