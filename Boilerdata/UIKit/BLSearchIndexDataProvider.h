//
//  BLSearchIndexDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BLChainDataProvider.h"

NS_ASSUME_NONNULL_BEGIN


@interface BLSearchIndexDataProvider : BLChainDataProvider

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END