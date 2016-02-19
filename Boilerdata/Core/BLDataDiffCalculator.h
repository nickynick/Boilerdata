//
//  BLDataDiffCalculator.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataDiff;
@protocol BLData;
@protocol BLDataItem;
@protocol BLDataSection;
@protocol BLIndexPathMapping;

NS_ASSUME_NONNULL_BEGIN


typedef BOOL (^BLDataItemUpdatedBlock)(id<BLDataItem> itemBefore, id<BLDataItem> itemAfter);


@interface BLDataDiffCalculator : NSObject

+ (id<BLDataDiff>)diffForDataBefore:(id<BLData>)dataBefore dataAfter:(id<BLData>)dataAfter;

+ (id<BLDataDiff>)diffForDataBefore:(id<BLData>)dataBefore
                          dataAfter:(id<BLData>)dataAfter
                       updatedBlock:(nullable BLDataItemUpdatedBlock)updatedBlock;


+ (id<BLDataDiff>)diffForItemsBefore:(NSArray<id<BLDataItem>> *)itemsBefore
                          itemsAfter:(NSArray<id<BLDataItem>> *)itemsAfter;

+ (id<BLDataDiff>)diffForItemsBefore:(NSArray<id<BLDataItem>> *)itemsBefore
                          itemsAfter:(NSArray<id<BLDataItem>> *)itemsAfter
                        updatedBlock:(nullable BLDataItemUpdatedBlock)updatedBlock;


+ (id<BLDataDiff>)diffForSectionsBefore:(NSArray<id<BLDataSection>> *)sectionsBefore
                          sectionsAfter:(NSArray<id<BLDataSection>> *)sectionsAfter;

+ (id<BLDataDiff>)diffForSectionsBefore:(NSArray<id<BLDataSection>> *)sectionsBefore
                          sectionsAfter:(NSArray<id<BLDataSection>> *)sectionsAfter
                           updatedBlock:(nullable BLDataItemUpdatedBlock)updatedBlock;


+ (id<BLDataDiff>)indexPathDiffWithOriginalDiff:(id<BLDataDiff>)originalDiff
                                  mappingBefore:(id<BLIndexPathMapping>)mappingBefore
                                   mappingAfter:(id<BLIndexPathMapping>)mappingAfter;

+ (id<BLDataDiff>)indexPathDiffForMappingUpdateWithMappedDataBefore:(id<BLData, BLIndexPathMapping>)mappedDataBefore
                                                    mappedDataAfter:(id<BLData, BLIndexPathMapping>)mappedDataAfter;

@end


NS_ASSUME_NONNULL_END