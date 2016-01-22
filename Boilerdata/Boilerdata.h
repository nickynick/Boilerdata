//
//  Boilerdata.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 22/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

#import <UIKit/UIKit.h>

//! Project version number for Boilerdata.
FOUNDATION_EXPORT double BoilerdataVersionNumber;

//! Project version string for Boilerdata.
FOUNDATION_EXPORT const unsigned char BoilerdataVersionString[];


// Data item

#import <Boilerdata/BLDataItem.h>


// Data diff

#import <Boilerdata/BLDataDiff.h>
#import <Boilerdata/BLDataDiffChange.h>
#import <Boilerdata/BLMutableDataDiff.h>
#import <Boilerdata/BLMutableDataDiffChange.h>
#import <Boilerdata/BLDataDiffCalculator.h>


// Data provider protocols

#import <Boilerdata/BLDataProvider.h>
#import <Boilerdata/BLDataObserver.h>
#import <Boilerdata/BLDataEvent.h>
#import <Boilerdata/BLDataEventProcessor.h>


// Abstract data providers

#import <Boilerdata/BLStaticDataProviderProxy.h>
#import <Boilerdata/BLAbstractDataProvider.h>
#import <Boilerdata/BLChainDataProvider.h>

// Import these headers to build your own subclasses:
/*
#import <Boilerdata/BLStaticDataProviderProxy+Subclassing.h>
#import <Boilerdata/BLAbstractDataProvider+Subclassing.h>
#import <Boilerdata/BLChainDataProvider+Subclassing.h>
 */


// Actual data providers

#import <Boilerdata/BLArrayDataProvider.h>
#import <Boilerdata/BLFilterDataProvider.h>


// Goodies

#import <Boilerdata/BLUtils.h>


// UIKit

#import <Boilerdata/BLUIKitViewReloader.h>
#import <Boilerdata/BLUITableViewAnimations.h>
