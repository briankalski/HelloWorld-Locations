//
//  LocationsViewController.m
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import "LocationDetailsViewController.h"
#import "Locations.h"
#import "LocationsTableViewCell.h"
#import "CoreDataAccess.h"
#import "LocationService.h"
#import "LocationsViewController.h"

@interface LocationsViewController ()

@end

@implementation LocationsViewController{
    CGFloat userLatitude;
    CGFloat userLongitude;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"HelloWorld Locations";
    
    self.tmp = [Globals sharedSingleton];
    
    [self.mapView setDelegate:self];
    self.mapView.showsUserLocation = YES;
    
    //Set user's location to determine distance to locations
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
    
    self.location = [[CLLocation alloc] init];
    
    //Update the list of locations
    LocationService *locService = [[LocationService alloc] init];
    locService.delegate = self;
    [locService GetLocationList];
    

    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView reloadData];
    
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    
    //Adjust height of map view to half the screen size and update layout
    self.heightConstraintMapView.constant = self.view.frame.size.height/2;
    [self.view layoutIfNeeded];
    
}

#pragma mark - MKMapView Methods

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500000, 500000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    [self UpdateLocationsOnMap];
    [self.tableView reloadData];
}

- (void) SetCenterCoordinate:(CGFloat)latitude longitude:(CGFloat)longitude{
    CLLocationCoordinate2D locationCoordinate;
    locationCoordinate.latitude = latitude;
    locationCoordinate.longitude = longitude;
    [self.mapView setCenterCoordinate:locationCoordinate animated:YES];
}

#pragma mark - Core Location methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    self.location = locations.lastObject;
    userLatitude = self.location.coordinate.latitude;
    userLongitude = self.location.coordinate.longitude;
}

-(NSNumber*) GetDistanceFromOfficeToUserLocation:(CGFloat)officeLongitude officeLatitude:(CGFloat)officeLatitude {
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:officeLatitude longitude:officeLongitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
    CGFloat distanceMeters = [location2 distanceFromLocation:location1];
    CGFloat distanceMiles =  distanceMeters / 1609.344;
    return [NSNumber numberWithFloat:distanceMiles];
}

- (void) GetLocationListResponse:(NSString*)response{
    if([response isEqualToString:@"FAILED"]){
        CoreDataAccess *coreDataAccess = [[CoreDataAccess alloc] init];
        [coreDataAccess LoadSavedLocations];
        [self.tableView reloadData];
    }
    else{
        [self UpdateLocationsOnMap];
        [self.tableView reloadData];
    }
}

-(void) UpdateLocationsOnMap{
    //Add Pins to MapView
    CLLocationCoordinate2D locationCoordinate;
    MKPointAnnotation *marketAnnotation;
    
    //Add Pins to MapView
    for (Locations *location in self.tmp.arrSavedLocations) {
        marketAnnotation = [[MKPointAnnotation alloc]init];
        locationCoordinate.latitude = [location.latitude floatValue];
        locationCoordinate.longitude = [location.longitude floatValue];
        marketAnnotation.coordinate = locationCoordinate;
        marketAnnotation.title = location.name;
        marketAnnotation.subtitle = location.address;
        
        //Update Locations array with distance to location
        location.distanceToOffice = [self GetDistanceFromOfficeToUserLocation:[location.longitude floatValue] officeLatitude:[location.latitude floatValue]];
        
        [self.mapView addAnnotation:marketAnnotation];
    }
    
    //Sort Locations array by distance to office
    NSSortDescriptor *firstDescriptor = [[NSSortDescriptor alloc] initWithKey:@"distanceToOffice" ascending:YES];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:firstDescriptor,nil];
    self.tmp.arrSavedLocations = (NSMutableArray*)[self.tmp.arrSavedLocations sortedArrayUsingDescriptors:sortDescriptors];
}

#pragma mark - UITableView methods

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"";//@"HelloWorld Locations";
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.tmp.arrSavedLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationsTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"LocationsTableViewCell"];
    
    // Configure the cell...
    if (cell == nil) {
        cell = [[LocationsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LocationsTableViewCell"];
    }
    
    Locations *location = (Locations*)[self.tmp.arrSavedLocations objectAtIndex:indexPath.row];
    
    cell.lblOfficeAddress.text = location.address;
    cell.lblOfficeName.text = location.name;
    cell.lblDistanceToOffice.text = [NSString stringWithFormat:@"%@%@", [Globals stringByRounding:NSNumberFormatterRoundUp toPositionRightOfDecimal:2 numberToRound:location.distanceToOffice], @" miles"];
    [cell.btnShowDetails setTag:indexPath.row];
    
    //Custom Colors
    [cell.lblOfficeName setTextColor:self.tmp.orangeHWColor];
    [cell.lblOfficeName setFont:[UIFont boldSystemFontOfSize:17]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    Locations *location = (Locations*)[self.tmp.arrSavedLocations objectAtIndex:indexPath.row];
    [self SetCenterCoordinate:[location.latitude floatValue] longitude:[location.longitude floatValue]];
}


- (IBAction)ShowLocationDetails:(id)sender {
    UIButton *btnShowDetails = (UIButton*)sender;
    NSInteger row = btnShowDetails.tag;
    
    LocationDetailsViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationDetailsViewController"];
    svc.row = row;
    [self.navigationController pushViewController:svc animated:YES];
}
@end
