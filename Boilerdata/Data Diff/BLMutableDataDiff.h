//
//  BLMutableDataDiff.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataDiff.h"

@interface BLMutableDataDiff : NSObject <BLDataDiff>

@property (nonatomic, readonly) NSMutableSet<NSIndexPath *> *deletedIndexPaths;
@property (nonatomic, readonly) NSMutableSet<NSIndexPath *> *insertedIndexPaths;
@property (nonatomic, readonly) NSMutableSet<id<BLDataDiffIndexPathChange>> *changedIndexPaths;

@property (nonatomic, readonly) NSMutableIndexSet *deletedSections;
@property (nonatomic, readonly) NSMutableIndexSet *insertedSections;
@property (nonatomic, readonly) NSMutableSet<id<BLDataDiffSectionChange>> *changedSections;

- (instancetype)initWithDataDiff:(id<BLDataDiff>)dataDiff;

- (void)addIndexPathsFromDiff:(id<BLDataDiff>)dataDiff;
- (void)addSectionsFromDiff:(id<BLDataDiff>)dataDiff;

// TODO: shift, union, etc.

@end
