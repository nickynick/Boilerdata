//
//  BLMutableDataDiff.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataDiff.h"

NS_ASSUME_NONNULL_BEGIN


@interface BLMutableDataDiff : NSObject <BLDataDiff>

@property (nonatomic, strong, readonly) NSMutableSet<NSIndexPath *> *deletedIndexPaths;
@property (nonatomic, strong, readonly) NSMutableSet<NSIndexPath *> *insertedIndexPaths;
@property (nonatomic, strong, readonly) NSMutableSet<id<BLDataDiffIndexPathChange>> *changedIndexPaths;

@property (nonatomic, strong, readonly) NSMutableIndexSet *deletedSections;
@property (nonatomic, strong, readonly) NSMutableIndexSet *insertedSections;
@property (nonatomic, strong, readonly) NSMutableSet<id<BLDataDiffSectionChange>> *changedSections;

- (instancetype)initWithDataDiff:(nullable id<BLDataDiff>)dataDiff NS_DESIGNATED_INITIALIZER;

- (void)addIndexPathsFromDiff:(id<BLDataDiff>)dataDiff;
- (void)addSectionsFromDiff:(id<BLDataDiff>)dataDiff;

- (void)shiftBySectionDelta:(NSInteger)sectionDelta rowDelta:(NSInteger)rowDelta;

// TODO: union, etc.

@end


NS_ASSUME_NONNULL_END