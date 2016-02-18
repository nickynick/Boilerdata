//
//  NSString+BLDataItem.m
//  BoilerdataDemo
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Nick Tymchenko. All rights reserved.
//

#import "NSString+BLDataItem.h"

@implementation NSString (BLDataItem)

- (id<BLDataItemId>)itemId {
    return self;
}

@end
