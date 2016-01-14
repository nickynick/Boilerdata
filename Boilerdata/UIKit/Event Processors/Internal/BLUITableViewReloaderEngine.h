//
//  BLUITableViewReloaderEngine.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUIKitViewReloaderEngine.h"
#import <UIKit/UIKit.h>

@class BLUITableViewAnimations;


@interface BLUITableViewReloaderEngine : NSObject <BLUIKitViewReloaderEngine>

- (instancetype)initWithTableView:(UITableView *)tableView animations:(BLUITableViewAnimations *)animations;

@end
