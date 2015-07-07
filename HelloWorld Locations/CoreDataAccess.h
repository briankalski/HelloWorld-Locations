//
//  GetSavedData.h
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface CoreDataAccess : NSObject{
    NSManagedObjectContext *managedObjectContext;
}

-(void) LoadSavedLocations;

@end
