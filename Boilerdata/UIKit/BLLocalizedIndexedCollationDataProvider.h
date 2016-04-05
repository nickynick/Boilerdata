//
//  BLLocalizedIndexedCollationDataProvider.h
//  Boilerdata
//
//  Created by Makarov Yury on 01/04/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLClassificationDataProvider.h"

NS_ASSUME_NONNULL_BEGIN

typedef NSString * _Nonnull (^BLDataItemStringifierBlock)(id<BLDataItem> dataItem);

@interface BLLocalizedIndexedCollationDataProvider : BLClassificationDataProvider

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider
                    stringifierBlock:(BLDataItemStringifierBlock)stringifierBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider
                 classificationBlock:(BLDataItemClassificationBlock)classificationBlock
                 sectionSortingBlock:(nullable BLSectionItemSortingBlock)sectionSortingBlock NS_UNAVAILABLE;

@end

NS_ASSUME_NONNULL_END