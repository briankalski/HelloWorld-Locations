//
//  LocationService.m
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import "CoreDataAccess.h"
#import "Globals.h"
#import "Locations.h"
#import "JSONKit.h"
#import "LocationService.h"

@implementation LocationService

-(void) GetLocationList {
    NSString *postString = @"http://www.helloworld.com/helloworld_locations.json";
    
    NSURL *theURL = [NSURL URLWithString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSMutableURLRequest* request = [[NSMutableURLRequest alloc] init];
    
    [request setURL:theURL];
    
    [request setCachePolicy:NSURLRequestReloadIgnoringLocalCacheData];
    
    [request setTimeoutInterval:2];
    
    (void)[[NSURLConnection alloc] initWithRequest:request delegate:self];
    
}


- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // A response has been received, this is where we initialize the instance var you created
    // so that we can append data to it in the didReceiveData method
    // Furthermore, this method is called each time there is a redirect so reinitializing it
    // also serves to clear it
    responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    // Append the new data to the instance variable you declared
    [responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection
                  willCacheResponse:(NSCachedURLResponse*)cachedResponse {
    // Return nil to indicate not necessary to store a cached response for this connection
    return nil;
}

-(void) DeleteLocationObjectsFromEntity{
    //delete object from entity
    Globals *tmp = [Globals sharedSingleton];
    managedObjectContext = tmp.managedObjectContext;
    NSFetchRequest *_fetchReq = [[NSFetchRequest alloc] init];
    NSError *error;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Locations" inManagedObjectContext:managedObjectContext];
    [_fetchReq setEntity:entity];
    
    NSArray *arrayTemp = [managedObjectContext executeFetchRequest:_fetchReq error:&error];
    for (NSManagedObject * rec in arrayTemp) {
        [managedObjectContext deleteObject:rec];
    }
    
    [managedObjectContext save:nil];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection {
    Globals *tmp = [Globals sharedSingleton];
    
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    formatter.numberStyle = NSNumberFormatterDecimalStyle;
    
    NSDictionary *resultsDictionary = [responseData objectFromJSONData];
    
    NSArray *ddList = [[NSArray alloc] init];
    ddList = [resultsDictionary objectForKey:@"locations"];
    
    [self DeleteLocationObjectsFromEntity];
    
    for(NSDictionary *occ in ddList){
        Locations *loc = [NSEntityDescription insertNewObjectForEntityForName:@"Locations" inManagedObjectContext:managedObjectContext];
        
        loc.name = [occ objectForKey:@"name"];
        loc.address = [occ objectForKey:@"address"];
        loc.address2 = [occ objectForKey:@"address2"];
        loc.city = [occ objectForKey:@"city"];
        loc.state = [occ objectForKey:@"state"];
        loc.zip_postal_code = [occ objectForKey:@"zip_postal_code"];
        loc.phone = [occ objectForKey:@"phone"];
        loc.fax = [occ objectForKey:@"fax"];
        loc.latitude = [formatter numberFromString:[occ objectForKey:@"latitude"]];
        loc.longitude = [formatter numberFromString:[occ objectForKey:@"longitude"]];
        loc.office_image = [occ objectForKey:@"office_image"];
        
        if(tmp.arrSavedLocations == nil){
            tmp.arrSavedLocations = [[NSMutableArray alloc]init];
        }
        
        [tmp.arrSavedLocations addObject:loc];
    }
    [managedObjectContext save:nil];
    
    [self ReturnResponse:@"success"];
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self ReturnResponse:@"FAILED"];
}

-(void)ReturnResponse:(NSString *) response{
    [self.delegate performSelector:@selector(GetLocationListResponse:) withObject:response];
}


@end

