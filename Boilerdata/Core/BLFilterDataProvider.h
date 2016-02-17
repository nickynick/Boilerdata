//
//  BLFilterDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataProvider.h"

NS_ASSUME_NONNULL_BEGIN


@interface BLFilterDataProvider : BLChainDataProvider

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

- (void)updateWithPredicate:(nullable NSPredicate *)predicate;

@end


NS_ASSUME_NONNULL_END