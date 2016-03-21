//
//  BLSectionsDataProvider.m
//  Boilerdata
//
//  Created by Makarov Yury on 21/03/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLSectionsDataProvider.h"
#import "BLBasicDataProvider+Subclassing.h"
#import "BLSectionsData.h"

@implementation BLSectionsDataProvider

- (void)updateWithSections:(NSArray<id<BLDataSection>> *)sections {
    [self updateWithSections:sections updatedItemIds:nil];
}

- (void)updateWithSections:(NSArray<id<BLDataSection>> *)sections updatedItemIds:(NSSet<id<BLDataItemId>> *)precalculatedUpdatedItemIds {
    BLSectionsData *newData = [[BLSectionsData alloc] initWithSections:sections];
    [self updateWithData:newData updatedItemIds:precalculatedUpdatedItemIds];
}

@end
