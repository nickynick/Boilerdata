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


@interface BLUIKitViewReloader : NSObject <BLDataEventProcessor>

@property (nonatomic, assign) BOOL forceReloadData;

@property (nonatomic, assign) BOOL waitForAnimationCompletion;

@property (nonatomic, assign) BOOL useMoveWhenPossible;
@property (nonatomic, assign) BOOL useUpdateBlockForReload;

@property (nonatomic, copy) void (^cellUpdateBlock)(id cell, NSIndexPath *indexPath);

- (instancetype)initWithTableView:(UITableView *)tableView;
- (instancetype)initWithTableView:(UITableView *)tableView animations:(BLUITableViewAnimations *)animations;

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView;

@end
