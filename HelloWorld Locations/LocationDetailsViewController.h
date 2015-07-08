//
//  LocationDetailsViewController.h
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/7/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import "Globals.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>

@interface LocationDetailsViewController : UIViewController<CLLocationManagerDelegate>
@property (strong, nonatomic) Globals *tmp;
@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UILabel *lblOfficeName;
@property (strong, nonatomic) IBOutlet UILabel *lblOfficeAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblDistanceToUserLocation;
@property (strong, nonatomic) IBOutlet UIButton *btnCallOffice;
@property (strong, nonatomic) IBOutlet UIImageView *imageViewOfficeImage;
@property (strong, nonatomic) IBOutlet UILabel *lblOfficeAddress2;
@property (strong, nonatomic) IBOutlet UIButton *btnDirections;
- (IBAction)CallOffice:(id)sender;
- (IBAction)GetDirections:(id)sender;
@property (nonatomic) NSInteger row;



@end
