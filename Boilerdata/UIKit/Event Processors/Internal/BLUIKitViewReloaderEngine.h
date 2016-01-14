//
//  BLUIKitViewReloaderEngine.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLUIKitViewReloaderEngine <NSObject>

- (void)reloadData;

- (void)performUpdates:(void (^)())updates completion:(void (^)())completion;

- (void)insertSections:(NSIndexSet *)sections;
- (void)deleteSections:(NSIndexSet *)sections;
- (void)reloadSections:(NSIndexSet *)sections;
- (void)moveSection:(NSUInteger)section toSection:(NSUInteger)newSection;

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths asDeleteAndInsertAtIndexPaths:(NSArray *)insertIndexPaths;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

- (id)cellForItemAtIndexPath:(NSIndexPath *)indexPath;

@end
