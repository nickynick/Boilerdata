//
//  NNDiffReloader.h
//  ArrayDiff
//
//  Created by Nick Tymchenko on 27/04/14.
//  Copyright (c) 2014 Nick Tymchenko. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NNSectionsDiff.h"
#import "NNDiffReloadOptions.h"

@interface NNDiffReloader : NSObject

- (void)reloadWithSectionsDiff:(NNSectionsDiff *)diff
                       options:(NNDiffReloadOptions *)options
                    completion:(void (^)(void))completion;

@end


@interface NNDiffReloader (Abstract)

- (void)performUpdates:(void (^)(void))updates withOptions:(NNDiffReloadOptions *)options completion:(void (^)(void))completion;

- (void)insertSections:(NSIndexSet *)sections;
- (void)deleteSections:(NSIndexSet *)sections;

- (void)insertItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)deleteItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)reloadItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)updateItemsAtIndexPaths:(NSArray *)indexPaths;
- (void)moveItemAtIndexPath:(NSIndexPath *)indexPath toIndexPath:(NSIndexPath *)newIndexPath;

@end
