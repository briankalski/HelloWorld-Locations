//
//  Globals.m
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
//  Singleton class used to share data between various classes

#import "Globals.h"

@implementation Globals

-(id)init{
    if(self = [super init])
    {
        NSUserDefaults *def = [NSUserDefaults standardUserDefaults];
        
        if([def objectForKey:@"managedObjectContext"] == nil){
            [def setObject:self.managedObjectContext forKey:@"managedObjectContext"];
            [def synchronize];
        }
        else{
            self.managedObjectContext = [def objectForKey:@"managedObjectContext"];
        }
        
        if([def objectForKey:@"arrSavedLocations"] == nil){
            [def setObject:self.arrSavedLocations forKey:@"arrSavedLocations"];
            [def synchronize];
        }
        else{
            self.arrSavedLocations = [def objectForKey:@"arrSavedLocations"];
        }
        
        if([def objectForKey:@"blueHWColor"] == nil){
            [def setObject:self.blueHWColor forKey:@"blueHWColor"];
            [def synchronize];
        }
        else{
            self.blueHWColor = [def objectForKey:@"blueHWColor"];
        }
        
        if([def objectForKey:@"orangeHWColor"] == nil){
            [def setObject:self.orangeHWColor forKey:@"orangeHWColor"];
            [def synchronize];
        }
        else{
            self.orangeHWColor = [def objectForKey:@"orangeHWColor"];
        }
    }
    return  self;
}

+ (NSString *)stringByRounding:(NSNumberFormatterRoundingMode)roundingMode toPositionRightOfDecimal:(NSUInteger)position numberToRound:(NSNumber*)numberToRound
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMaximumFractionDigits:position];
    [formatter setRoundingMode:roundingMode];
    NSString *numberString = [formatter stringFromNumber:numberToRound];
    return numberString;
}

+ (Globals *)sharedSingleton {
    static Globals *instance;
    
    static dispatch_once_t donce;
    dispatch_once(&donce, ^{
        instance = [[self alloc] init];
    });
    
    return instance;
}
@end
