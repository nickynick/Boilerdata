//
//  BLDataDiffChange.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol BLDataDiffChange <NSObject>

@property (nonatomic, readonly, getter = isMoved) BOOL moved;
@property (nonatomic, readonly, getter = isUpdated) BOOL updated;

@end


@protocol BLDataDiffIndexPathChange <BLDataDiffChange>

@property (nonatomic, readonly) NSIndexPath *before;
@property (nonatomic, readonly) NSIndexPath *after;

@end


@protocol BLDataDiffSectionChange <BLDataDiffChange>

@property (nonatomic, readonly) NSUInteger before;
@property (nonatomic, readonly) NSUInteger after;

@end


NS_ASSUME_NONNULL_END