//
//  BLUIKitViewReloaderEngine.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUIKitViewReloader.h"

NS_ASSUME_NONNULL_BEGIN


@protocol BLUIKitViewReloaderEngine <NSObject>

@property (nonatomic, copy, nullable) BLCellUpdateBlock cellUpdateBlock;

- (BOOL)shouldForceReloadData;

- (void)reloadData;

- (void)performUpdates:(void (^)(void))updates completion:(void (^)(void))completion;

- (void)insertSections:(NSIndexSet *)sections;
- (void)deleteSections:(NSIndexSet *)sections;
- (void)reloadSections:(NSIndexSet *)sections;
- (void)moveSection:(NSUInteger)section toSection:(NSUInteger)newSection;

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)customReloadItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

@end


NS_ASSUME_NONNULL_END
