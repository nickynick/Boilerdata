//
//  BLUIKitViewReloader.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 10/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataEventProcessor.h"
#import <UIKit/UIKit.h>

@class BLUITableViewAnimations;

NS_ASSUME_NONNULL_BEGIN


typedef void (^BLCellUpdateBlock)(id cell, NSIndexPath *indexPath);


@interface BLUIKitViewReloader : NSObject <BLDataEventProcessor>

@property (nonatomic, assign) BOOL forceReloadData;

@property (nonatomic, assign) BOOL waitForAnimationCompletion;

@property (nonatomic, assign) BOOL useMoveWhenPossible;
@property (nonatomic, assign) BOOL useCellUpdateBlockForReload;

@property (nonatomic, copy, nullable) BLCellUpdateBlock cellUpdateBlock;

- (instancetype)initWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView animations:(nullable BLUITableViewAnimations *)animations;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END