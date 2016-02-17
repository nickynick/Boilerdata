//
//  BLUITableViewAnimations.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface BLUITableViewAnimations : NSObject

@property (nonatomic, assign) UITableViewRowAnimation rowInsertAnimation;
@property (nonatomic, assign) UITableViewRowAnimation rowDeleteAnimation;
@property (nonatomic, assign) UITableViewRowAnimation rowReloadAnimation;

@property (nonatomic, assign) UITableViewRowAnimation sectionInsertAnimation;
@property (nonatomic, assign) UITableViewRowAnimation sectionDeleteAnimation;
@property (nonatomic, assign) UITableViewRowAnimation sectionReloadAnimation;

+ (instancetype)withAnimation:(UITableViewRowAnimation)animation;

@end
