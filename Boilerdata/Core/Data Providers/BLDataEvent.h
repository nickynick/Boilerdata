//
//  BLDataEvent.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol BLDataDiff;
@protocol BLStaticDataProvider;


@interface BLDataEvent : NSObject

@property (nonatomic, readonly) id<BLStaticDataProvider> updatedDataProvider;

@property (nonatomic, readonly) id<BLDataDiff> dataDiff;

@property (nonatomic, readonly) NSDictionary *context; // optional arbitrary data from model

- (instancetype)initWithUpdatedDataProvider:(id<BLStaticDataProvider>)updatedDataProvider
                                   dataDiff:(id<BLDataDiff>)dataDiff
                                    context:(NSDictionary *)context;

@end
