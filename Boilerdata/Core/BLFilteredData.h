//
//  BLFilteredData.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLProxyData.h"

@class BLDataItemFilter;

NS_ASSUME_NONNULL_BEGIN


@interface BLFilteredData : BLProxyData

@property (nonatomic, strong, readonly, nullable) BLDataItemFilter *filter;

@property (nonatomic, readonly, getter = isIdentical) BOOL identical;

- (instancetype)initWithOriginalData:(id<BLData>)originalData
                              filter:(nullable BLDataItemFilter *)filter NS_DESIGNATED_INITIALIZER;

- (NSIndexPath *)filteredIndexPathToOriginal:(NSIndexPath *)filteredIndexPath;

- (nullable NSIndexPath *)originalIndexPathToFiltered:(NSIndexPath *)originalIndexPath;

@end


NS_ASSUME_NONNULL_END
