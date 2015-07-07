//
//  ViewController.h
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import "Globals.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface HelloWorldMapViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, CLLocationManagerDelegate, MKMapViewDelegate>

@property (strong, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *heightConstraintMapView;
@property (strong, nonatomic) Globals *tmp;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (strong, nonatomic) CLLocation *location;

@end

