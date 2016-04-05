//
//  BLClassificationDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLClassificationDataProvider.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLClassifiedData.h"
#import "BLDataEvent.h"

@interface BLClassificationDataProvider ()

@property (nonatomic, copy, readonly) BLDataItemClassificationBlock classificationBlock;
@property (nonatomic, copy, readonly) BLSectionItemSortingBlock sectionSortingBlock;

@end


@implementation BLClassificationDataProvider

#pragma mark - Init

- (instancetype)initWithDataProvider:(id<BLDataProvider>)dataProvider
                 classificationBlock:(BLDataItemClassificationBlock)classificationBlock
                 sectionSortingBlock:(BLSectionItemSortingBlock)sectionSortingBlock {
    self = [super init];
    if (!self) return nil;
        
    _classificationBlock = [classificationBlock copy];
    _sectionSortingBlock = [sectionSortingBlock copy];
    
    [self updateInnerDataProvider:dataProvider];
    
    return self;
}

#pragma mark - BLChainDataProvider

- (id<BLData>)transformInnerDataForEvent:(BLDataEvent *)innerEvent withLastQueuedData:(BLClassifiedData *)lastQueuedData {
    return [[BLClassifiedData alloc] initWithOriginalData:innerEvent.newData
                                      classificationBlock:self.classificationBlock
                                      sectionSortingBlock:self.sectionSortingBlock];
}

@end
