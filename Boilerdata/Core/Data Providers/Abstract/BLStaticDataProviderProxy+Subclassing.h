//
//  BLStaticDataProviderProxy+Subclassing.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLStaticDataProviderProxy.h"

@interface BLStaticDataProviderProxy (Subclassing)

@property (nonatomic, strong) id<BLStaticDataProvider> staticDataProvider;

@end
