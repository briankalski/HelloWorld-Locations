//
//  GetSavedData.m
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import "Locations.h"
#import "Globals.h"
#import "CoreDataAccess.h"

@implementation CoreDataAccess

-(void) LoadSavedLocations{
    //get data and load it into shared NSMutableArray
    Globals *tmp = [Globals sharedSingleton];
    managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReqA = [[NSFetchRequest alloc] init];
    //_fetchReqA.predicate = [NSPredicate predicateWithFormat:[NSString stringWithFormat:@"%@%@%@",@"name =='", @"RequestType", @"'", nil]];
    NSEntityDescription *entityA = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:managedObjectContext];
    [_fetchReqA setEntity:entityA];
    //sorting
    NSSortDescriptor* sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name" ascending: YES];
    NSArray* sortDescriptors = [[NSArray alloc] initWithObjects: sortDescriptor, nil];
    [_fetchReqA setSortDescriptors:sortDescriptors];
    
    NSArray *arrayTempA = [managedObjectContext executeFetchRequest:_fetchReqA error:nil];
    tmp.arrSavedLocations = [[NSMutableArray alloc] init];
    for(int i = 0; i < [arrayTempA count] ; i++){
        Locations *loc = (Locations*)[arrayTempA objectAtIndex:i];
        [tmp.arrSavedLocations addObject:loc];
    }
}

@end
