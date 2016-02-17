//
//  BLUICollectionViewReloaderEngine.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUIKitViewReloaderEngine.h"
#import "BLUIKitViewReloader.h"
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN


@interface BLUICollectionViewReloaderEngine : NSObject <BLUIKitViewReloaderEngine>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END