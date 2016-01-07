//
//  BLMutableDataDiff.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLMutableDataDiff.h"

@implementation BLMutableDataDiff

#pragma mark - Init

- (instancetype)init {
    return [self initWithDataDiff:nil];
}

- (instancetype)initWithDataDiff:(id<BLDataDiff>)dataDiff {
    self = [super init];
    if (!self) return nil;
    
    _deletedIndexPaths = [dataDiff.deletedIndexPaths mutableCopy] ?: [NSMutableSet set];
    _insertedIndexPaths = [dataDiff.insertedIndexPaths mutableCopy] ?: [NSMutableSet set];
    _changedIndexPaths = [dataDiff.changedIndexPaths mutableCopy] ?: [NSMutableSet set];
    
    _deletedSections = [dataDiff.deletedSections mutableCopy] ?: [NSMutableIndexSet indexSet];
    _insertedSections = [dataDiff.insertedSections mutableCopy] ?: [NSMutableIndexSet indexSet];
    _changedSections = [dataDiff.changedSections mutableCopy] ?: [NSMutableSet set];
    
    return self;
}

#pragma mark - Operations

- (void)addIndexPathsFromDiff:(id<BLDataDiff>)dataDiff {
    [self.deletedIndexPaths unionSet:dataDiff.deletedIndexPaths];
    [self.insertedIndexPaths unionSet:dataDiff.insertedIndexPaths];
    [self.changedIndexPaths unionSet:dataDiff.changedIndexPaths];
}

- (void)addSectionsFromDiff:(id<BLDataDiff>)dataDiff {
    [self.deletedSections addIndexes:dataDiff.deletedSections];
    [self.insertedSections addIndexes:dataDiff.insertedSections];
    [self.changedSections unionSet:dataDiff.changedSections];
}

@end
