//
//  BLDataDiffCalculator.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataDiff;
@protocol BLDataItem;
@protocol BLDataSection;

typedef BOOL (^BLDataItemUpdatedBlock)(id<BLDataItem> itemBefore, id<BLDataItem> itemAfter);


@interface BLDataDiffCalculator : NSObject

+ (id<BLDataDiff>)diffForItemsBefore:(NSArray<id<BLDataItem>> *)itemsBefore
                          itemsAfter:(NSArray<id<BLDataItem>> *)itemsAfter;

+ (id<BLDataDiff>)diffForItemsBefore:(NSArray<id<BLDataItem>> *)itemsBefore
                          itemsAfter:(NSArray<id<BLDataItem>> *)itemsAfter
                        updatedBlock:(BLDataItemUpdatedBlock)updatedBlock;


+ (id<BLDataDiff>)diffForSectionsBefore:(NSArray<id<BLDataSection>> *)sectionsBefore
                          sectionsAfter:(NSArray<id<BLDataSection>> *)sectionsAfter;

+ (id<BLDataDiff>)diffForSectionsBefore:(NSArray<id<BLDataSection>> *)sectionsBefore
                          sectionsAfter:(NSArray<id<BLDataSection>> *)sectionsAfter
                           updatedBlock:(BLDataItemUpdatedBlock)updatedBlock;

@end
