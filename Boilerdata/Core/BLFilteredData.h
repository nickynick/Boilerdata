//
//  BLFilteredData.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLProxyData.h"
#import "BLIndexPathMapping.h"

@class BLDataItemFilter;

NS_ASSUME_NONNULL_BEGIN


@interface BLFilteredData : BLProxyData <BLIndexPathMapping>

@property (nonatomic, strong, readonly, nullable) BLDataItemFilter *filter;

@property (nonatomic, readonly, getter = isIdentical) BOOL identical;

- (instancetype)initWithOriginalData:(id<BLData>)originalData
                              filter:(nullable BLDataItemFilter *)filter NS_DESIGNATED_INITIALIZER;

@end


NS_ASSUME_NONNULL_END
