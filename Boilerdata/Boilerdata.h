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


// Data

#import <Boilerdata/BLData.h>
#import <Boilerdata/BLDataItem.h>

#import <Boilerdata/BLEmptyData.h>
#import <Boilerdata/BLArrayData.h>


// Data Provider

#import <Boilerdata/BLDataProvider.h>
#import <Boilerdata/BLDataObserver.h>
#import <Boilerdata/BLDataEvent.h>
#import <Boilerdata/BLDataEventProcessor.h>

#import <Boilerdata/BLArrayDataProvider.h>
#import <Boilerdata/BLFilterDataProvider.h>


// Data diff

#import <Boilerdata/BLDataDiff.h>
#import <Boilerdata/BLDataDiffChange.h>
#import <Boilerdata/BLMutableDataDiff.h>
#import <Boilerdata/BLMutableDataDiffChange.h>
#import <Boilerdata/BLDataDiffCalculator.h>


// Goodies

#import <Boilerdata/BLUtils.h>
#import <Boilerdata/BLDataSection.h>


// UIKit

#import <Boilerdata/BLUIKitViewReloader.h>
#import <Boilerdata/BLUITableViewAnimations.h>
