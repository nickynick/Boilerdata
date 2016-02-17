//
//  BLUITableViewAnimations.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 14/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLUITableViewAnimations.h"

@implementation BLUITableViewAnimations

- (instancetype)init {
    return [self initWithAnimation:UITableViewRowAnimationAutomatic];
}

- (instancetype)initWithAnimation:(UITableViewRowAnimation)animation {
    self = [super init];
    if (!self) return nil;

    _rowInsertAnimation = animation;
    _rowDeleteAnimation = animation;
    _rowReloadAnimation = animation;
    _sectionInsertAnimation = animation;
    _sectionDeleteAnimation = animation;
    _sectionReloadAnimation = animation;
    
    return self;
}

+ (instancetype)withAnimation:(UITableViewRowAnimation)animation {
    return [[BLUITableViewAnimations alloc] initWithAnimation:animation];
}

@end
