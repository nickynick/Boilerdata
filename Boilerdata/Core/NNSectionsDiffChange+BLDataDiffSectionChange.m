//
//  NNSectionsDiffChange+BLDataDiffSectionChange.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 19/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "NNSectionsDiffChange+BLDataDiffSectionChange.h"

@implementation NNSectionsDiffChange (BLDataDiffIndexPathChange)

- (BOOL)isMoved {
    return self.type & NNDiffChangeMove;
}

- (BOOL)isUpdated {
    return self.type & NNDiffChangeUpdate;
}

@end
