//
//  NNArrayDiffChange+BLDataDiffIndexPathChange.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NNArrayDiffChange+BLDataDiffIndexPathChange.h"

@implementation NNArrayDiffChange (BLDataDiffIndexPathChange)

- (BOOL)isMoved {
    return self.type & NNDiffChangeMove;
}

- (BOOL)isUpdated {
    return self.type & NNDiffChangeUpdate;
}

@end
