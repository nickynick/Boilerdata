//
//  NNArrayDiff+BLDataDiff.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 19/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NNArrayDiff+BLDataDiff.h"

@implementation NNArrayDiff (BLDataDiff)

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
    return self.deleted;
}

- (NSIndexSet *)insertedSections {
    return self.inserted;
}

- (NSSet<id<BLDataDiffSectionChange>> *)changedSections {
    return self.changed;
}

@end
