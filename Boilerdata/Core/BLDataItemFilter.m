//
//  BLDataItemFilter.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLDataItemFilter.h"
#import "BLDataItem.h"

@interface BLDataItemFilter ()

@property (strong, readonly, nonatomic) NSMutableDictionary<id<BLDataItemId>, NSNumber *> *resultsCache;

@end


@implementation BLDataItemFilter

#pragma mark - Init

- (instancetype)init {
    return [self initWithPredicate:nil];
}

- (instancetype)initWithPredicate:(NSPredicate *)predicate {
    self = [super init];
    if (!self) return nil;
    
    _predicate = predicate;
    
    _resultsCache = [NSMutableDictionary dictionary];
    
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
    BLDataItemFilter *copy = [[BLDataItemFilter allocWithZone:zone] initWithPredicate:self.predicate];
    copy->_resultsCache = [_resultsCache mutableCopy];
    return copy;
}

#pragma mark - Public

- (BOOL)evaluateItem:(id<BLDataItem>)item {
    if (!self.predicate) {
        return YES;
    }
    
    NSNumber *result = self.resultsCache[item.itemId];
    
    if (!result) {
        result = @([self.predicate evaluateWithObject:item]);
        self.resultsCache[item.itemId] = result;
    }
    
    return [result boolValue];
}

- (void)invalidateCachedEvaluationForItemWithId:(id<BLDataItemId>)itemId {
    [self.resultsCache removeObjectForKey:itemId];
}

@end
