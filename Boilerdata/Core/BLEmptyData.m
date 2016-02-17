//
//  BLEmptyData.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 17/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLEmptyData.h"

@implementation BLEmptyData

#pragma mark - Shared instance

+ (instancetype)data {
    static id instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

#pragma mark - BLData

- (NSInteger)numberOfSections {
    return 0;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return 0;
}

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    [NSException raise:NSInternalInconsistencyException format:@"BLEmptyData itemAtIndexPath: is called, it makes no sense"];
    return nil;
}

- (nullable NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId {
    return nil;
}

@end
