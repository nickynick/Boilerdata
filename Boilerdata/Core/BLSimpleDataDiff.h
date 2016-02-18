//
//  BLSimpleDataDiff.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataDiff.h"

NS_ASSUME_NONNULL_BEGIN


@interface BLSimpleDataDiff : NSObject <BLDataDiff>

+ (instancetype)empty;

- (instancetype)initWithNumberOfSections:(NSUInteger)numberOfSections inserted:(BOOL)inserted NS_DESIGNATED_INITIALIZER;

@end


NS_ASSUME_NONNULL_END