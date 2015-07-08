//
//  LocationDetailsViewController.m
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/7/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import "Locations.h"
#import "LocationDetailsViewController.h"

@interface LocationDetailsViewController ()

@end

@implementation LocationDetailsViewController{
    NSString *phoneNumber;
    CGFloat latitudeOffice;
    CGFloat longitudeOffice;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tmp = [Globals sharedSingleton];
    
    //Populate fields
    Locations *loc = (Locations*)[self.tmp.arrSavedLocations objectAtIndex:self.row];
    self.title = loc.name;
    self.lblOfficeName.text = loc.name;
    self.lblOfficeAddress.text = [NSString stringWithFormat:@"%@%@%@", loc.address, @" ", loc.address2];
    self.lblOfficeAddress2.text = [NSString stringWithFormat:@"%@%@%@", loc.city, @" ", loc.state];
    self.lblDistanceToUserLocation.text = [NSString stringWithFormat:@"%@%@", [Globals stringByRounding:NSNumberFormatterRoundUp toPositionRightOfDecimal:2 numberToRound:loc.distanceToOffice], @" miles"];
    phoneNumber = loc.phone;
    latitudeOffice = [loc.latitude floatValue];
    longitudeOffice = [loc.longitude floatValue];
    [self LoadOfficeImage:loc.office_image];
    
    //Set Custom Colors and Font Attributes
    [self.lblOfficeName setTextColor:self.tmp.orangeHWColor];
    [self.lblOfficeName setFont:[UIFont boldSystemFontOfSize:17]];
    
    //Add Location to Map
    CLLocationCoordinate2D locationCoordinate;
    MKPointAnnotation *marketAnnotation;
    marketAnnotation = [[MKPointAnnotation alloc]init];
    locationCoordinate.latitude = [loc.latitude floatValue];
    locationCoordinate.longitude = [loc.longitude floatValue];
    marketAnnotation.coordinate = locationCoordinate;
    marketAnnotation.title = loc.name;
    marketAnnotation.subtitle = loc.address;
    
    [self.mapView addAnnotation:marketAnnotation];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) LoadOfficeImage:(NSString*)imageURL{
    dispatch_queue_t imageQueue = dispatch_queue_create("Image Queue",NULL);
    dispatch_async(imageQueue, ^{
        
        NSURL *url = [NSURL URLWithString:imageURL];
        NSData *imageData = [NSData dataWithContentsOfURL:url];
        UIImage *image = [UIImage imageWithData:imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            // Update the UI
            [self.imageViewOfficeImage setImage:image];
        });
        
    });
}


- (IBAction)CallOffice:(id)sender{
    NSString *phoneNumberString = [phoneNumber stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [phoneNumber length])];
    NSURL *phoneNum = [NSURL URLWithString:[@"telprompt://" stringByAppendingString:phoneNumberString]];
    [[UIApplication sharedApplication] openURL:phoneNum];
}

- (IBAction)GetDirections:(id)sender {
    //first create latitude longitude object
    CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake(latitudeOffice,longitudeOffice);
    
    //create MKMapItem out of coordinates
    MKPlacemark* placeMark = [[MKPlacemark alloc] initWithCoordinate:coordinate addressDictionary:nil];
    MKMapItem* destination =  [[MKMapItem alloc] initWithPlacemark:placeMark];
    
    [destination openInMapsWithLaunchOptions:@{MKLaunchOptionsDirectionsModeKey:MKLaunchOptionsDirectionsModeDriving}];
    
}
@end
