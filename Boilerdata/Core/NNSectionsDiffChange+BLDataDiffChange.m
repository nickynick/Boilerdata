//
//  NNSectionsDiffChange+BLDataDiffChange.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 19/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NNSectionsDiffChange+BLDataDiffChange.h"

@implementation NNSectionsDiffChange (BLDataDiffChange)

- (BOOL)isMoved {
    return self.type & NNDiffChangeMove;
}

- (BOOL)isUpdated {
    return self.type & NNDiffChangeUpdate;
}

@end
