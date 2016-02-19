//
//  NNArrayDiffChange+BLDataDiffChange.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NNArrayDiffChange+BLDataDiffChange.h"

@implementation NNArrayDiffChange (BLDataDiffChange)

- (BOOL)isMoved {
    return self.type & NNDiffChangeMove;
}

- (BOOL)isUpdated {
    return self.type & NNDiffChangeUpdate;
}

@end
