//
//  BLUtils.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLData;
@protocol BLDataItem;
@protocol BLDataDiff;

NS_ASSUME_NONNULL_BEGIN


typedef void (^BLDataItemEnumerationBlock)(id<BLDataItem> item, NSIndexPath *indexPath, BOOL *stop);


@interface BLUtils : NSObject

+ (BOOL)dataIsEmpty:(id<BLData>)data;

+ (NSInteger)dataNumberOfItems:(id<BLData>)data;

+ (void)data:(id<BLData>)data enumerateItemsWithBlock:(BLDataItemEnumerationBlock)block;


+ (BOOL)dataDiffIsEmpty:(id<BLDataDiff>)dataDiff;

@end


NS_ASSUME_NONNULL_END