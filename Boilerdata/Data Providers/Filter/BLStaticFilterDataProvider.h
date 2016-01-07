//
//  BLStaticFilterDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLStaticDataProviderProxy.h"

@class BLDataItemFilter;


@interface BLStaticFilterDataProvider : BLStaticDataProviderProxy

@property (nonatomic, readonly) id<BLStaticDataProvider> fullDataProvider;
@property (nonatomic, readonly) BLDataItemFilter *filter;

@property (nonatomic, readonly, getter = isIdentical) BOOL identical;

- (instancetype)initWithFullDataProvider:(id<BLStaticDataProvider>)fullDataProvider filter:(BLDataItemFilter *)filter;

- (NSIndexPath *)filteredIndexPathToFull:(NSIndexPath *)filteredIndexPath;
- (NSIndexPath *)fullIndexPathToFiltered:(NSIndexPath *)fullIndexPath;

@end
