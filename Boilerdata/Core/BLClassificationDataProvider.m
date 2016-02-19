//
//  BLClassificationDataProvider.m
//  Boilerdata
//
//  Created by Nick Tymchenko on 18/02/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import "BLClassificationDataProvider.h"
#import "BLAbstractDataProvider+Subclassing.h"
#import "BLChainDataProvider+Subclassing.h"
#import "BLClassifiedData.h"
#import "BLDataEvent.h"
#import "BLDataDiffCalculator.h"
#import "BLMutableDataDiff.h"
#import "BLUtils.h"

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
    
    [self updateInnerDataProvider:dataProvider];
    
    _classificationBlock = [classificationBlock copy];
    _sectionSortingBlock = [sectionSortingBlock copy];
    
    return self;
}

#pragma mark - BLAbstractDataProvider

- (id<BLData>)createInitialData {
    return [[BLClassifiedData alloc] initWithOriginalData:self.lastQueuedInnerData
                                      classificationBlock:self.classificationBlock
                                      sectionSortingBlock:self.sectionSortingBlock];
}

#pragma mark - Chaining

- (BLDataEvent *)handleInnerDataEvent:(BLDataEvent *)event {
    BLClassifiedData *oldData = self.lastQueuedData;
    BLClassifiedData *newData = [[BLClassifiedData alloc] initWithOriginalData:event.updatedData
                                                           classificationBlock:self.classificationBlock
                                                           sectionSortingBlock:self.sectionSortingBlock];
    
    id<BLDataDiff> dataDiff = [self dataDiffForInnerDiff:event.dataDiff oldData:oldData newData:newData];
    
    return [[BLDataEvent alloc] initWithUpdatedData:newData dataDiff:dataDiff context:event.context];
}

#pragma mark - Private

- (id<BLDataDiff>)dataDiffForInnerDiff:(id<BLDataDiff>)innerDataDiff oldData:(BLClassifiedData *)oldData newData:(BLClassifiedData *)newData {
    BLMutableDataDiff *dataDiff = [[BLMutableDataDiff alloc] init];
    
    [dataDiff addSectionsFromDiff:[BLDataDiffCalculator sectionDiffForSectionItemsBefore:[BLUtils dataSectionItems:oldData]
                                                                       sectionItemsAfter:[BLUtils dataSectionItems:newData]]];
    
    [dataDiff addIndexPathsFromDiff:[BLDataDiffCalculator indexPathDiffWithOriginalDiff:innerDataDiff
                                                                          mappingBefore:oldData
                                                                           mappingAfter:newData]];
    
    return dataDiff;
}

@end
