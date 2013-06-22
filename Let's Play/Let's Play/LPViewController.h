//
//  LPViewController.h
//  Let's Play
//
//  Created by Atharv Vaish on 6/11/13.
//  Copyright (c) 2013 LP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface LPViewController : UIViewController<CLLocationManagerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (nonatomic, retain) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet UILabel *errors;

@end
