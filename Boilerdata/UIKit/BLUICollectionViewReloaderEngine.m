//
//  BLUICollectionViewReloaderEngine.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUICollectionViewReloaderEngine.h"

@interface BLUICollectionViewReloaderEngine ()

@property (nonatomic, readonly) UICollectionView *collectionView;

@end


@implementation BLUICollectionViewReloaderEngine

#pragma mark - Init

- (instancetype)init {
    return [self initWithCollectionView:nil];
}

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    NSParameterAssert(collectionView != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _collectionView = collectionView;
    
    return self;
}

#pragma mark - BLUIKitViewReloaderEngine

- (BOOL)shouldForceReloadData {
    // Performing animations offscreen is a heavy performance hit
    return self.collectionView.window == nil;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)performUpdates:(void (^)())updates completion:(void (^)())completion {
    [self.collectionView performBatchUpdates:updates completion:^(__unused BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)insertSections:(NSIndexSet *)sections {
    [self.collectionView insertSections:sections];
}

- (void)deleteSections:(NSIndexSet *)sections {
    [self.collectionView deleteSections:sections];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [self.collectionView reloadSections:sections];
}

- (void)moveSection:(NSUInteger)section toSection:(NSUInteger)newSection {
    [self.collectionView moveSection:section toSection:newSection];
}

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.collectionView insertItemsAtIndexPaths:indexPaths];
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.collectionView deleteItemsAtIndexPaths:indexPaths];
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths asDeleteAndInsertAtIndexPaths:(NSArray *)insertIndexPaths {
    if (insertIndexPaths) {
        [self.collectionView deleteItemsAtIndexPaths:indexPaths];
        [self.collectionView insertItemsAtIndexPaths:insertIndexPaths];
    } else {
        [self.collectionView reloadItemsAtIndexPaths:indexPaths];
    }
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (id)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.collectionView cellForItemAtIndexPath:indexPath];
}

@end
