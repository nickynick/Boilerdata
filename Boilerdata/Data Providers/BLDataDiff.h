//
//  BLDataDiff.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataDiff <NSObject>

@property (nonatomic, readonly) NSSet *deletedIndexPaths;
@property (nonatomic, readonly) NSSet *insertedIndexPaths;
@property (nonatomic, readonly) NSSet *changedIndexPaths;

@property (nonatomic, readonly) NSIndexSet *deletedSections;
@property (nonatomic, readonly) NSIndexSet *insertedSections;
@property (nonatomic, readonly) NSIndexSet *changedSections;

@end
