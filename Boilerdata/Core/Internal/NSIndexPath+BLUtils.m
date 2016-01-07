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

- (NSUInteger)bl_row {
    return [self indexAtPosition:1];
}

+ (instancetype)bl_indexPathForRow:(NSUInteger)row inSection:(NSUInteger)section {
    NSUInteger indexes[] = { section, row };
    return [NSIndexPath indexPathWithIndexes:indexes length:2];
}

- (instancetype)bl_shiftBySectionDelta:(NSInteger)sectionDelta rowDelta:(NSInteger)rowDelta {
    NSUInteger indexes[] = { [self indexAtPosition:0] + sectionDelta, [self indexAtPosition:1] + rowDelta };
    return [NSIndexPath indexPathWithIndexes:indexes length:2];
}

@end
