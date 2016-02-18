//
//  BLClassificationDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataProvider.h"

@protocol BLDataItem;
@protocol BLSectionItem;

NS_ASSUME_NONNULL_BEGIN


typedef id<BLSectionItem> _Nonnull (^BLDataItemClassificationBlock)(id<BLDataItem> dataItem);

typedef NSArray<id<BLSectionItem>> * _Nonnull (^BLSectionItemSortingBlock)(NSArray<id<BLSectionItem>> *sectionItems);


@interface BLClassificationDataProvider : BLChainDataProvider

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider
                 classificationBlock:(BLDataItemClassificationBlock)classificationBlock
                 sectionSortingBlock:(nullable BLSectionItemSortingBlock)sectionSortingBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END