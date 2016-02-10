//
//  BLStaticDataProviderProxy.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLStaticDataProviderProxy.h"
#import "BLStaticDataProviderProxy+Subclassing.h"

@implementation BLStaticDataProviderProxy

#pragma mark - BLStaticDataProvider

- (NSInteger)numberOfSections {
    return [self.staticDataProvider numberOfSections];
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
    return [self.staticDataProvider numberOfItemsInSection:section];
}

- (id<BLDataItem>)itemAtIndexPath:(NSIndexPath *)indexPath {
    return [self.staticDataProvider itemAtIndexPath:indexPath];
}

- (NSIndexPath *)indexPathForItemWithId:(id<BLDataItemId>)itemId {
    return [self.staticDataProvider indexPathForItemWithId:itemId];
}

#pragma mark - Optional methods forwarding

- (BOOL)respondsToSelector:(SEL)aSelector {
    return [super respondsToSelector:aSelector] || [self.staticDataProvider respondsToSelector:aSelector];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    NSMethodSignature *signature = [super methodSignatureForSelector:aSelector];
    if (!signature) {
        signature = [(NSObject *)self.staticDataProvider methodSignatureForSelector:aSelector];
    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    if ([self.staticDataProvider respondsToSelector:anInvocation.selector]) {
        [anInvocation invokeWithTarget:self.staticDataProvider];
    } else {
        [super forwardInvocation:anInvocation];
    }
}

@end
