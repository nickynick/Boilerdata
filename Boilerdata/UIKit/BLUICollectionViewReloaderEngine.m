//
//  BLUICollectionViewReloaderEngine.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUICollectionViewReloaderEngine.h"
#import <UIKitWorkarounds/NNCollectionViewReloader.h>

@interface BLUICollectionViewReloaderEngine ()

@property (nonatomic, strong ,readonly) UICollectionView *collectionView;

@property (nonatomic, strong) NNCollectionViewReloader *reloader;

@end


@implementation BLUICollectionViewReloaderEngine

#pragma mark - Init

- (instancetype)initWithCollectionView:(UICollectionView *)collectionView {
    self = [super init];
    if (!self) return nil;
    
    _collectionView = collectionView;
    
    return self;
}

#pragma mark - BLUIKitViewReloaderEngine

@synthesize cellUpdateBlock = _cellUpdateBlock;

- (BOOL)shouldForceReloadData {
    // Performing animations offscreen is a heavy performance hit
    return self.collectionView.window == nil;
}

- (void)reloadData {
    [self.collectionView reloadData];
}

- (void)performUpdates:(void (^)())updates completion:(void (^)())completion {
    self.reloader = [[NNCollectionViewReloader alloc] initWithCollectionView:self.collectionView cellCustomReloadBlock:self.cellUpdateBlock];
    
    [self.reloader performUpdates:updates completion:^{
        self.reloader = nil;
        
        completion();
    }];
}

- (void)insertSections:(NSIndexSet *)sections {
    [self.reloader insertSections:sections];
}

- (void)deleteSections:(NSIndexSet *)sections {
    [self.reloader deleteSections:sections];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [self.reloader reloadSections:sections];
}

- (void)moveSection:(NSUInteger)section toSection:(NSUInteger)newSection {
    [self.reloader moveSection:section toSection:newSection];
}

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.reloader insertItemsAtIndexPaths:indexPaths];
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.reloader deleteItemsAtIndexPaths:indexPaths];
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.reloader reloadItemsAtIndexPaths:indexPaths];
}

- (void)customReloadItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.reloader reloadItemsAtIndexPathsWithCustomBlock:indexPaths];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self.reloader moveItemAtIndexPath:indexPath toIndexPath:newIndexPath];
}

@end
