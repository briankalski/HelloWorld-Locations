//
//  LocationsTableViewCell.h
//  HelloWorld Locations
//
//  Created by Brian Kalski on 7/5/15.
//  Copyright (c) 2015 BrianKalski. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface LocationsTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblOfficeName;
@property (strong, nonatomic) IBOutlet UILabel *lblOfficeAddress;
@property (strong, nonatomic) IBOutlet UILabel *lblDistanceToOffice;
@property (strong, nonatomic) IBOutlet UIButton *btnShowDetails;

@end
