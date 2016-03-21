//
//  BLDataSection.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 07/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataItem;
@protocol BLSectionItem;

NS_ASSUME_NONNULL_BEGIN


@protocol BLDataSection <NSObject>

@property (nonatomic, readonly) NSArray<id<BLDataItem>> *items;

@property (nonatomic, nullable, readonly) id<BLSectionItem> sectionItem;

@end


@interface BLDataSection : NSObject <BLDataSection>

- (instancetype)initWithItems:(NSArray<id<BLDataItem>> *)items sectionItem:(nullable id<BLSectionItem>)sectionItem NS_DESIGNATED_INITIALIZER;

- (instancetype)init NS_UNAVAILABLE;

@end


NS_ASSUME_NONNULL_END