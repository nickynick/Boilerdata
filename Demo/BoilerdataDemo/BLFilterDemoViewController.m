//
//  BLFilterDemoViewController.m
//  BoilerdataDemo
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Nick Tymchenko. All rights reserved.
//

#import "BLFilterDemoViewController.h"
#import "NSString+BLDataItem.h"
#import <Boilerdata/Boilerdata.h>

static NSString * const kCellIdentifier = @"cell";


@interface BLFilterDemoViewController () <BLDataObserver, UISearchResultsUpdating>

@property (nonatomic, strong, readonly) BLArrayDataProvider *arrayDataProvider;
@property (nonatomic, strong, readonly) BLFilterDataProvider *filterDataProvider;

@property (nonatomic, strong, readonly) BLSearchIndexDataProvider *topLevelDataProvider;

@property (nonatomic, strong, readonly) NSArray<NSArray<NSString *> *> *itemsOptions;
@property (nonatomic, assign) NSInteger currentItemsOption;

@property (nonatomic, strong, readonly) UISearchController *searchController;

@end


@implementation BLFilterDemoViewController

- (instancetype)init {
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) return nil;
    
    self.title = @"Demo";
    
    [self setupData];
    
    return self;
}

- (void)setupData {
    _arrayDataProvider = [[BLArrayDataProvider alloc] init];

    _filterDataProvider = [[BLFilterDataProvider alloc] initWithDataProvider:_arrayDataProvider];
    
    BLLocalizedIndexedCollationDataProvider *collationDataProvider =
        [[BLLocalizedIndexedCollationDataProvider alloc] initWithDataProvider:_filterDataProvider
                                                             stringifierBlock:^NSString *(NSString *item){
                                                                 return item;
                                                             }];
    
    _topLevelDataProvider = [[BLSearchIndexDataProvider alloc] initWithDataProvider:collationDataProvider];
    _topLevelDataProvider.observer = self;
    
    
    _itemsOptions = @[
        @[ @"One", @"Two", @"Three", @"Four", @"Five", @"Six", @"Seven", @"Eight", @"Nine", @"Ten" ],
        @[ @"One", @"Two", @"Boop", @"Four", @"Five", @"Beep", @"Seven", @"Eight", @"Nine", @"Ten", @"Eleven", @"Twelve" ],
        @[ @"Meow", @"Moo", @"One", @"Two", @"Three", @"Four", @"Five", @"Bok", @"Cock-a-doodle-doo" ]
    ];
    
    [self updateData];
}

- (void)updateData {
    [self.arrayDataProvider updateWithItems:self.itemsOptions[self.currentItemsOption]];
    
    self.currentItemsOption = (self.currentItemsOption + 1) % self.itemsOptions.count;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCellIdentifier];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"Update"
                                                                              style:UIBarButtonItemStylePlain
                                                                             target:self action:@selector(updateData)];
    
    _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    _searchController.searchResultsUpdater = self;
    _searchController.dimsBackgroundDuringPresentation = NO;
    _searchController.hidesNavigationBarDuringPresentation = NO;
    
    self.tableView.tableHeaderView = _searchController.searchBar;
    
    self.definesPresentationContext = YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.topLevelDataProvider.data numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.topLevelDataProvider.data numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCellIdentifier forIndexPath:indexPath];
    cell.textLabel.text = (NSString *) [self.topLevelDataProvider.data itemAtIndexPath:indexPath];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return (NSString *) [self.topLevelDataProvider.data itemForSection:section];
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index {
    if ([title isEqualToString:UITableViewIndexSearch]) {
        [self.tableView scrollRectToVisible:self.searchController.searchBar.frame animated:NO];
    }
    return [self.topLevelDataProvider.data sectionForSectionIndexTitleAtIndex:index];
}

- (NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return [self.topLevelDataProvider.data sectionIndexTitles];
}

#pragma mark - BLDataObserver 

- (id<BLDataEventProcessor>)dataProvider:(id<BLDataProvider>)dataProvider willUpdateWithEvent:(BLDataEvent *)event {
    return [[BLUIKitViewReloader alloc] initWithTableView:self.tableView
                                               animations:[BLUITableViewAnimations withAnimation:UITableViewRowAnimationFade]];
}

#pragma mark - UISearchResultsUpdating

- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    NSString *searchText = searchController.searchBar.text;
    NSPredicate *predicate = searchText.length > 0 ? [NSPredicate predicateWithFormat:@"self contains[cd] %@", searchText] : nil;
    
    [self.filterDataProvider updateWithPredicate:predicate];
}

@end
