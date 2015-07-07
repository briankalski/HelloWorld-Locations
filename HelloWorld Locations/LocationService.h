//
//  LocationService.h
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@protocol LocationServiceProtocol

@required
-(void) GetLocationListResponse:(NSString *) response;

@end

@interface LocationService : NSObject<NSXMLParserDelegate>{
    NSMutableData *webData;
    NSMutableString *soapResults;
    NSURLConnection *conn;
    NSMutableData *responseData;
    NSManagedObjectContext *managedObjectContext;
    
    //---xml parsing---
    NSXMLParser *xmlParser;
    BOOL elementFound;
}

@property (nonatomic,strong) id delegate;

-(void) GetLocationList;

@end
