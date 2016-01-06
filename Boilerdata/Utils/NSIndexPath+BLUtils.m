//
//  NSIndexPath+BLUtils.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NSIndexPath+BLUtils.h"

@implementation NSIndexPath (BLUtils)

- (NSUInteger)bl_section {
    return [self indexAtPosition:0];
}

- (NSUInteger)bl_item {
    return [self indexAtPosition:1];
}

+ (instancetype)bl_indexPathForItem:(NSUInteger)item inSection:(NSUInteger)section {
    NSUInteger indexes[] = { section, item };
    return [NSIndexPath indexPathWithIndexes:indexes length:2];
}

@end
