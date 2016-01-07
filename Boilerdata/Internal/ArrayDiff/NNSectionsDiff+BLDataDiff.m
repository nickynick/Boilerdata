//
//  NNSectionsDiff+BLDataDiff.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NNSectionsDiff+BLDataDiff.h"
#import "BLMutableDataDiffChange.h"

@implementation NNSectionsDiff (BLDataDiff)

- (NSSet<NSIndexPath *> *)deletedIndexPaths {
    return self.deleted;
}

- (NSSet<NSIndexPath *> *)insertedIndexPaths {
    return self.inserted;
}

- (NSSet<id<BLDataDiffIndexPathChange>> *)changedIndexPaths {
    return self.changed;
}

- (NSSet<id<BLDataDiffSectionChange>> *)changedSections {
    return [NSSet set];
}

@end
