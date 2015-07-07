//
//  Locations.h
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/7/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Locations : NSManagedObject

@property (nonatomic, retain) NSString * address;
@property (nonatomic, retain) NSString * address2;
@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * distanceToOffice;
@property (nonatomic, retain) NSString * fax;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * office_image;
@property (nonatomic, retain) NSString * phone;
@property (nonatomic, retain) NSString * state;
@property (nonatomic, retain) NSString * zip_postal_code;

@end
