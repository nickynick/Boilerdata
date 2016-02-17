//
//  BLUITableViewReloaderEngine.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUITableViewReloaderEngine.h"
#import "BLUITableViewAnimations.h"
#import <UIKitWorkarounds/NNTableViewReloader.h>

@interface BLUITableViewReloaderEngine ()

@property (nonatomic, strong, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) BLUITableViewAnimations *animations;

@property (nonatomic, strong) NNTableViewReloader *reloader;

@end


@implementation BLUITableViewReloaderEngine

#pragma mark - Init

- (instancetype)initWithTableView:(UITableView *)tableView
                       animations:(BLUITableViewAnimations *)animations {
    self = [super init];
    if (!self) return nil;
    
    _tableView = tableView;
    _animations = animations ?: [[BLUITableViewAnimations alloc] init];
    
    return self;
}

#pragma mark - BLUIKitViewReloaderEngine

@synthesize cellUpdateBlock = _cellUpdateBlock;

- (BOOL)shouldForceReloadData {
    // Performing animations offscreen is a heavy performance hit
    return self.tableView.window == nil;
}

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)performUpdates:(void (^)())updates completion:(void (^)())completion {
    self.reloader = [[NNTableViewReloader alloc] initWithTableView:self.tableView cellCustomReloadBlock:self.cellUpdateBlock];
    
    [self.reloader performUpdates:updates completion:^{
        self.reloader = nil;
        
        completion();
    }];
}

- (void)insertSections:(NSIndexSet *)sections {
    [self.reloader insertSections:sections withRowAnimation:self.animations.sectionInsertAnimation];
}

- (void)deleteSections:(NSIndexSet *)sections {
    [self.reloader deleteSections:sections withRowAnimation:self.animations.sectionDeleteAnimation];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [self.reloader reloadSections:sections withRowAnimation:self.animations.sectionReloadAnimation];
}

- (void)moveSection:(NSUInteger)section toSection:(NSUInteger)newSection {
    [self.reloader moveSection:section toSection:newSection];
}

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.reloader insertRowsAtIndexPaths:indexPaths withRowAnimation:self.animations.rowInsertAnimation];
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.reloader deleteRowsAtIndexPaths:indexPaths withRowAnimation:self.animations.rowDeleteAnimation];
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.reloader reloadRowsAtIndexPaths:indexPaths withRowAnimation:self.animations.rowReloadAnimation];
}

- (void)customReloadItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.reloader reloadRowsAtIndexPathsWithCustomBlock:indexPaths];
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self.reloader moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

@end
