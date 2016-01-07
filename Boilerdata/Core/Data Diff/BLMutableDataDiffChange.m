//
//  BLMutableDataDiffChange.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLMutableDataDiffChange.h"

@implementation BLMutableDataDiffChange

- (instancetype)initWithAbstractChange:(id<BLDataDiffChange>)change {
    self = [super init];
    if (!self) return nil;
    
    _moved = change.moved;
    _updated = change.updated;
    
    return self;
}

@end


@implementation BLMutableDataDiffIndexPathChange

- (instancetype)initWithChange:(id<BLDataDiffIndexPathChange>)change {
    self = [super initWithAbstractChange:change];
    if (!self) return nil;
    
    _before = change.before;
    _after = change.after;
    
    return self;
}

@end


@implementation BLMutableDataDiffSectionChange

- (instancetype)initWithChange:(id<BLDataDiffSectionChange>)change {
    self = [super initWithAbstractChange:change];
    if (!self) return nil;
    
    _before = change.before;
    _after = change.after;
    
    return self;
}

@end
