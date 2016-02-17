//
//  BLUITableViewReloaderEngine.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUIKitViewReloaderEngine.h"
#import "BLUIKitViewReloader.h"
#import <UIKit/UIKit.h>

@class BLUITableViewAnimations;

NS_ASSUME_NONNULL_BEGIN


@interface BLUITableViewReloaderEngine : NSObject <BLUIKitViewReloaderEngine>

- (instancetype)initWithTableView:(UITableView *)tableView
                       animations:(nullable BLUITableViewAnimations *)animations NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END