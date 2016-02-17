//
//  BLProxyData.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 17/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLData.h"

NS_ASSUME_NONNULL_BEGIN


@interface BLProxyData : NSObject <BLData>

@property (nonatomic, strong, readonly) id<BLData> originalData;

- (instancetype)initWithOriginalData:(id<BLData>)originalData NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END