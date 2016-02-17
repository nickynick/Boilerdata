//
//  BLProxyData.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 17/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLProxyData.h"

@implementation BLProxyData

#pragma mark - Init

- (instancetype)initWithOriginalData:(id<BLData>)originalData {
    self = [super init];
    if (!self) return nil;
    
    _originalData = originalData;
    
    return self;
}

#pragma mark - BLData

- (NSInteger)numberOfSections {
    return [self.originalData numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.originalData numberOfItemsInSection:section];
}

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.originalData itemAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId {
    return [self.originalData indexPathForItemWithId:itemId];
}

#pragma mark - Optional methods forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.originalData respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [(NSObject *)self.originalData methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.originalData respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.originalData];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
