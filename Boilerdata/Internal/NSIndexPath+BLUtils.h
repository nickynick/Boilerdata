//
//  NSIndexPath+BLUtils.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

// This category lets us avoid referencing UIKit where we shouldn't.

@interface NSIndexPath (BLUtils)

@property (nonatomic, readonly) NSUInteger bl_section;
@property (nonatomic, readonly) NSUInteger bl_row;

+ (instancetype)bl_indexPathForRow:(NSUInteger)row inSection:(NSUInteger)section;

- (instancetype)bl_shiftBySectionDelta:(NSInteger)sectionDelta rowDelta:(NSInteger)rowDelta;

@end
