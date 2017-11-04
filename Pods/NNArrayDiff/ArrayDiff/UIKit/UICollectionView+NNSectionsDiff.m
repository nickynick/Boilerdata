//
//  UICollectionView+NNSectionsDiff.m
//  ArrayDiff
//
//  Created by Nick Tymchenko on 12/04/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import "UICollectionView+NNSectionsDiff.h"
#import "NNDiffCollectionViewReloader.h"

@implementation UICollectionView (NNSectionsDiff)

- (void)reloadWithSectionsDiff:(NNSectionsDiff *)sectionsDiff {
    [self reloadWithSectionsDiff:sectionsDiff options:nil completion:nil];
}

- (void)reloadWithSectionsDiff:(NNSectionsDiff *)sectionsDiff
                       options:(NNDiffReloadOptions *)options
                    completion:(void (^)(void))completion
{
    if (!options) {
        options = [[NNDiffReloadOptions alloc] init];
    }
    
    NNDiffCollectionViewReloader *reloader = [[NNDiffCollectionViewReloader alloc] initWithCollectionView:self];
    [reloader reloadWithSectionsDiff:sectionsDiff options:options completion:completion];
}

@end
