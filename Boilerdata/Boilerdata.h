//
//  Boilerdata.h
//  Boilerdata
//
//  Created by Nick Tymchenko on 05/01/16.
//  Copyright © 2016 Pixty. All rights reserved.
//

// TODO: <> please

// Data item

#import "BLDataItem.h"


// Data diff

#import "BLDataDiff.h"
#import "BLDataDiffChange.h"
#import "BLMutableDataDiff.h"
#import "BLMutableDataDiffChange.h"
#import "BLDataDiffCalculator.h"


// Data provider protocols

#import "BLDataProvider.h"
#import "BLDataObserver.h"
#import "BLDataEvent.h"
#import "BLDataEventProcessor.h"


// Abstract data providers

#import "BLStaticDataProviderProxy.h"
#import "BLAbstractDataProvider.h"
#import "BLChainDataProvider.h"

// Import these headers to build your own subclasses:
/*
#import <Boilerdata/BLStaticDataProviderProxy+Subclassing.h>
#import <Boilerdata/BLAbstractDataProvider+Subclassing.h>
#import <Boilerdata/BLChainDataProvider+Subclassing.h>
 */


// Actual data providers

#import "BLArrayDataProvider.h"
#import "BLFilterDataProvider.h"


// Goodies

#import "BLUtils.h"



// UIKit
// TODO: separate header
#import "BLUIKitViewReloader.h"
#import "BLUITableViewAnimations.h"