//
//  BLSimpleDataDiff.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLSimpleDataDiff.h"

@interface BLSimpleDataDiff ()

@property (nonatomic, assign, readonly) NSUInteger numberOfSections;

@property (nonatomic, assign, readonly) BOOL inserted;

@end


@implementation BLSimpleDataDiff

#pragma mark - Shared

+ (instancetype)empty {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - Init

- (instancetype)init {
    return [self initWithNumberOfSections:0 inserted:NO];
}

- (instancetype)initWithNumberOfSections:(NSUInteger)numberOfSections inserted:(BOOL)inserted {
    self = [super init];
    if (!self) return nil;
    
    _numberOfSections = numberOfSections;
    _inserted = inserted;
    
    return self;
}

#pragma mark - BLDataDiff

- (NSSet<NSIndexPath *> *)deletedIndexPaths {
    return [NSSet set];
}

- (NSSet<NSIndexPath *> *)insertedIndexPaths {
    return [NSSet set];
}

- (NSSet<id<BLDataDiffIndexPathChange>> *)changedIndexPaths {
    return [NSSet set];
}

- (NSIndexSet *)deletedSections {
    if (!self.inserted && self.numberOfSections > 0) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfSections)];
    } else {
        return [NSIndexSet indexSet];
    }
}

- (NSIndexSet *)insertedSections {
    if (self.inserted && self.numberOfSections > 0) {
        return [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, self.numberOfSections)];
    } else {
        return [NSIndexSet indexSet];
    }
}

- (NSSet<id<BLDataDiffSectionChange>> *)changedSections {
    return [NSSet set];
}

@end
