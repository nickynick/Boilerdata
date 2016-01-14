//
//  BLUICollectionViewReloaderEngine.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUIKitViewReloaderEngine.h"
#import <UIKit/UIKit.h>

@interface BLUICollectionViewReloaderEngine : NSObject <BLUIKitViewReloaderEngine>

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
