//
//  BLDataDiff.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BLDataDiffChange.h"

@protocol BLDataDiff <NSObject>

@property (nonatomic, readonly) NSSet<NSIndexPath *> *deletedIndexPaths;
@property (nonatomic, readonly) NSSet<NSIndexPath *> *insertedIndexPaths;
@property (nonatomic, readonly) NSSet<id<BLDataDiffIndexPathChange>> *changedIndexPaths;

@property (nonatomic, readonly) NSIndexSet *deletedSections;
@property (nonatomic, readonly) NSIndexSet *insertedSections;
@property (nonatomic, readonly) NSSet<id<BLDataDiffSectionChange>> *changedSections;

@end