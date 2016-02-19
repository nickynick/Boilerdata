//
//  BLIndexPathMapping.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 19/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol BLIndexPathMapping <NSObject>

/**
 * Denotes if the mapping leaves all original index paths unchanged.
 */
@property (nonatomic, assign, readonly, getter = isIdentical) BOOL identical;

/**
 * Denotes if the mapping covers all original index paths.
 * In other words: if full = YES, then -originalIndexPathToMapped: will never return nil.
 */
@property (nonatomic, assign, readonly, getter = isFull) BOOL full;

- (nullable NSIndexPath *)originalIndexPathToMapped:(NSIndexPath *)originalIndexPath;

- (NSIndexPath *)mappedIndexPathToOriginal:(NSIndexPath *)mappedIndexPath;

@end


NS_ASSUME_NONNULL_END