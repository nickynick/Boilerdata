//
//  BLMutableDataDiffChange.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataDiffChange.h"

@interface BLMutableDataDiffChange : NSObject

@property (nonatomic, assign, getter = isMoved) BOOL moved;
@property (nonatomic, assign, getter = isUpdated) BOOL updated;

@end


@interface BLMutableDataDiffIndexPathChange : BLMutableDataDiffChange <BLDataDiffIndexPathChange>

@property (nonatomic, strong) NSIndexPath *before;
@property (nonatomic, strong) NSIndexPath *after;

- (instancetype)initWithChange:(id<BLDataDiffIndexPathChange>)change;

@end


@interface BLMutableDataDiffSectionChange : BLMutableDataDiffChange <BLDataDiffSectionChange>

@property (nonatomic, assign) NSUInteger before;
@property (nonatomic, assign) NSUInteger after;

- (instancetype)initWithChange:(id<BLDataDiffSectionChange>)change;

@end