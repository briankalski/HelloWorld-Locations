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
    
    //initialize singleton class
    self.tmp = [Globals sharedSingleton];
    
    //set map view properties
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
    
    //set UITableView properties
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
    //set user's location
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 500000, 500000);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    
    [self UpdateLocationsOnMap];
    [self.tableView reloadData];
}

- (void) SetCenterCoordinate:(CGFloat)latitude longitude:(CGFloat)longitude{
    //sets map center after user chooses office location
    CLLocationCoordinate2D locationCoordinate;
    locationCoordinate.latitude = latitude;
    locationCoordinate.longitude = longitude;
    [self.mapView setCenterCoordinate:locationCoordinate animated:YES];
}

#pragma mark - Core Location methods

-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations {
    //update user location
    self.location = locations.lastObject;
    userLatitude = self.location.coordinate.latitude;
    userLongitude = self.location.coordinate.longitude;
}

-(NSNumber*) GetDistanceFromOfficeToUserLocation:(CGFloat)officeLongitude officeLatitude:(CGFloat)officeLatitude {
    //calculates distance from user's location to an office
    CLLocation *location1 = [[CLLocation alloc] initWithLatitude:officeLatitude longitude:officeLongitude];
    CLLocation *location2 = [[CLLocation alloc] initWithLatitude:userLatitude longitude:userLongitude];
    CGFloat distanceMeters = [location2 distanceFromLocation:location1];
    CGFloat distanceMiles =  distanceMeters / 1609.344;
    return [NSNumber numberWithFloat:distanceMiles];
}

- (void) GetLocationListResponse:(NSString*)response{
    //Get response from class that calls web service to retrieve office data
    if([response isEqualToString:@"FAILED"]){
        //web service call failed - load office data from Core Data into shared NSMutableArray
        CoreDataAccess *coreDataAccess = [[CoreDataAccess alloc] init];
        [coreDataAccess LoadSavedLocations];
        [self.tableView reloadData];
    }
    else{
        //web service call was successful - shared NSMutableArray is populated and ready to use
        [self UpdateLocationsOnMap];
        [self.tableView reloadData];
    }
}

-(void) UpdateLocationsOnMap{
    //Loop through office locations and add pins to mapView
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
    return @"";
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
    //set tag to row number so it can be used to pull up location details
    [cell.btnShowDetails setTag:indexPath.row];
    
    //Custom Colors
    [cell.lblOfficeName setTextColor:self.tmp.orangeHWColor];
    [cell.lblOfficeName setFont:[UIFont boldSystemFontOfSize:17]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    //center map on office location pressed
    Locations *location = (Locations*)[self.tmp.arrSavedLocations objectAtIndex:indexPath.row];
    [self SetCenterCoordinate:[location.latitude floatValue] longitude:[location.longitude floatValue]];
}


- (IBAction)ShowLocationDetails:(id)sender {
    //push to Location Details view controller
    UIButton *btnShowDetails = (UIButton*)sender;
    NSInteger row = btnShowDetails.tag;
    
    LocationDetailsViewController *svc = [self.storyboard instantiateViewControllerWithIdentifier:@"LocationDetailsViewController"];
    svc.row = row;
    [self.navigationController pushViewController:svc animated:YES];
}
@end
