//
//  BLSectionsData.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 20/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataSection;

NS_ASSUME_NONNULL_BEGIN


@interface BLSectionsData : NSObject

@property (nonatomic, copy, readonly) NSArray<id<BLDataSection>> *sections;

- (instancetype)initWithSections:(nullable NSArray<id<BLDataSection>> *)sections NS_DESIGNATED_INITIALIZER;

@end


NS_ASSUME_NONNULL_END