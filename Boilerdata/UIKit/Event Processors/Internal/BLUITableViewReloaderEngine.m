//
//  BLUITableViewReloaderEngine.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUITableViewReloaderEngine.h"
#import "BLUITableViewAnimations.h"

@interface BLUITableViewReloaderEngine ()

@property (nonatomic, readonly) UITableView *tableView;
@property (nonatomic, readonly) BLUITableViewAnimations *animations;

@end


@implementation BLUITableViewReloaderEngine

#pragma mark - Init

- (instancetype)init {
    return [self initWithTableView:nil animations:nil];
}

- (instancetype)initWithTableView:(UITableView *)tableView animations:(BLUITableViewAnimations *)animations {
    NSParameterAssert(tableView != nil);
    
    self = [super init];
    if (!self) return nil;
    
    _tableView = tableView;
    _animations = animations ?: [[BLUITableViewAnimations alloc] init];
    
    return self;
}

#pragma mark - BLUIKitViewReloaderEngine

- (void)reloadData {
    [self.tableView reloadData];
}

- (void)performUpdates:(void (^)())updates completion:(void (^)())completion {
    if (completion) {
        [CATransaction begin];
        [CATransaction setCompletionBlock:completion];
    }
    
    [self.tableView beginUpdates];
    updates();
    [self.tableView endUpdates];
    
    if (completion) {
        [CATransaction commit];
    }
}

- (void)insertSections:(NSIndexSet *)sections {
    [self.tableView insertSections:sections withRowAnimation:self.animations.sectionInsertAnimation];
}

- (void)deleteSections:(NSIndexSet *)sections {
    [self.tableView deleteSections:sections withRowAnimation:self.animations.sectionDeleteAnimation];
}

- (void)reloadSections:(NSIndexSet *)sections {
    [self.tableView reloadSections:sections withRowAnimation:self.animations.sectionReloadAnimation];
}

- (void)moveSection:(NSUInteger)section toSection:(NSUInteger)newSection {
    [self.tableView moveSection:section toSection:newSection];
}

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:self.animations.rowInsertAnimation];
}

- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths {
    [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:self.animations.rowDeleteAnimation];
}

- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths asDeleteAndInsertAtIndexPaths:(NSArray *)insertIndexPaths {
    if (insertIndexPaths) {
        [self.tableView deleteRowsAtIndexPaths:indexPaths withRowAnimation:self.animations.rowReloadAnimation];
        [self.tableView insertRowsAtIndexPaths:insertIndexPaths withRowAnimation:self.animations.rowReloadAnimation];
    } else {
        [self.tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:self.animations.rowReloadAnimation];
    }
}

- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath {
    [self.tableView moveRowAtIndexPath:indexPath toIndexPath:newIndexPath];
}

- (id)cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.tableView cellForRowAtIndexPath:indexPath];
}

@end
