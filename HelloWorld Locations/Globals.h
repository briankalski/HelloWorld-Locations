//
//  Globals.h
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface Globals : NSObject

@property (nonatomic, assign) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *arrSavedLocations;

+ (NSString *)stringByRounding:(NSNumberFormatterRoundingMode)roundingMode toPositionRightOfDecimal:(NSUInteger)position numberToRound:(NSNumber*)numberToRound;

+ (Globals *) sharedSingleton;
@end
