//
//  BLClassifiedData.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 19/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLProxyData.h"
#import "BLIndexPathMapping.h"
#import "BLClassificationDataProvider.h"

NS_ASSUME_NONNULL_BEGIN


@interface BLClassifiedData : BLProxyData <BLIndexPathMapping>

- (instancetype)initWithOriginalData:(id<BLData>)originalData
                 classificationBlock:(BLDataItemClassificationBlock)classificationBlock
                 sectionSortingBlock:(nullable BLSectionItemSortingBlock)sectionSortingBlock NS_DESIGNATED_INITIALIZER;

- (instancetype)initWithOriginalData:(id<BLData>)originalData NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END