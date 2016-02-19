//
//  BLArrayDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLArrayDataProvider.h"
#import "BLAbstractDataProvider+Subclassing.h"
#import "BLArrayData.h"
#import "BLDataItem.h"
#import "BLDataEvent.h"
#import "BLUtils.h"

@interface BLArrayDataProvider ()

@property (nonatomic, copy, readonly) BLDataItemIsUpdatedBlock isUpdatedBlock;

@end


@implementation BLArrayDataProvider

#pragma mark - Init

- (instancetype)init {
    return [self initWithIsUpdatedBlock:nil];
}

- (instancetype)initWithIsUpdatedBlock:(BLDataItemIsUpdatedBlock)isUpdatedBlock {
    self = [super init];
    if (!self) return nil;
    
    _isUpdatedBlock = [(isUpdatedBlock ?: ^BOOL(id<BLDataItem> oldItem, id<BLDataItem> newItem) {
        return ![oldItem isEqual:newItem];
    }) copy];
    
    return self;
}

#pragma mark - Updates

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items {
    [self updateWithItems:items updatedItemIds:nil];
}

- (void)updateWithItems:(NSArray<id<BLDataItem>> *)items updatedItemIds:(NSSet<id<BLDataItemId>> *)precalculatedUpdatedItemIds {
    [self updateWithBlock:^(__kindof id<BLData> lastQueuedData) {
        BLArrayData *newData = [[BLArrayData alloc] initWithItems:items];
        
        NSSet<id<BLDataItemId>> *updatedItemIds =
            precalculatedUpdatedItemIds ?: [self updatedItemIdsForOldData:lastQueuedData newData:newData];
        
        [self enqueueDataEvent:[[BLDataEvent alloc] initWithOldData:lastQueuedData
                                                            newData:newData
                                                     updatedItemIds:updatedItemIds
                                                            context:nil]];
    }];
}

#pragma mark - Private

- (NSSet<id<BLDataItemId>> *)updatedItemIdsForOldData:(id<BLData>)oldData newData:(id<BLData>)newData {
    NSDictionary<id<BLDataItemId>, id<BLDataItem>> *oldItemsById = [BLUtils dataItemsById:oldData];
    NSDictionary<id<BLDataItemId>, id<BLDataItem>> *newItemsById = [BLUtils dataItemsById:newData];
    
    NSMutableSet<id<BLDataItemId>> *updatedItemIds = [NSMutableSet set];
    
    if (oldItemsById.count < newItemsById.count) {
        [oldItemsById enumerateKeysAndObjectsUsingBlock:^(id<BLDataItemId> itemId, id<BLDataItem> oldItem, BOOL *stop) {
            id<BLDataItem> newItem = newItemsById[itemId];
            if (newItem && self.isUpdatedBlock(oldItem, newItem)) {
                [updatedItemIds addObject:itemId];
            }
        }];
    } else {
        [newItemsById enumerateKeysAndObjectsUsingBlock:^(id<BLDataItemId> itemId, id<BLDataItem> newItem, BOOL *stop) {
            id<BLDataItem> oldItem = oldItemsById[itemId];
            if (oldItem && self.isUpdatedBlock(oldItem, newItem)) {
                [updatedItemIds addObject:itemId];
            }
        }];
    }
    
    return updatedItemIds;
}

@end
