//
//  BLDataItem.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN


@protocol BLDataItemId <NSObject, NSCopying>

@end


@protocol BLDataItem <NSObject>

@property (nonatomic, readonly) id<BLDataItemId> itemId;

@end


NS_ASSUME_NONNULL_END