//
//  BLFilterDataProvider.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 06/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLChainDataProvider.h"

@interface BLFilterDataProvider : BLChainDataProvider

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider;

- (void)updatePredicate:(NSPredicate *)predicate;

@end
