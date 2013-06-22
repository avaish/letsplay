//
//  LPViewController.m
//  Let's Play
//
//  Created by Atharv Vaish on 6/11/13.
//  Copyright (c) 2013 LP. All rights reserved.
//

#import "LPViewController.h"
#import "LPHomeViewController.h"

@interface LPViewController ()

@end

@implementation LPViewController

@synthesize locationManager;
@synthesize username;
@synthesize password;
@synthesize errors;

- (IBAction)login {
  errors.text = @"";
  
  NSString *post = [NSString stringWithFormat:
                    @"&username=%@&password=%@",
                    username.text, password.text];
  NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                        allowLossyConversion:YES];
  NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:
                   [NSString stringWithFormat:
                    @"http://www.avatarv.com/letsplay/login.php"]]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/x-www-form-urlencoded"
 forHTTPHeaderField:@"Current-Type"];
  [request setHTTPBody:postData];
  NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request
                                                         delegate:self];
  
  if(conn) {
    NSLog(@"Connection Successful");
  } else {
    NSLog(@"Connection could not be made");
    errors.text = @"connection could not be made";
  }
}

- (IBAction)register {
  errors.text = @"";
  CLLocation *curPos = locationManager.location;
  
  NSString *latitude =
  [[NSNumber numberWithDouble:curPos.coordinate.latitude] stringValue];
  NSString *longitude =
  [[NSNumber numberWithDouble:curPos.coordinate.longitude] stringValue];
  
  NSLog(@"Lat: %@", latitude);
  NSLog(@"Long: %@", longitude);
  NSLog(@"Username: %@", username.text);
  NSLog(@"Password: %@", password.text);
  NSString *post = [NSString stringWithFormat:
                    @"&username=%@&password=%@&llat=%@&llong=%@",
                    username.text, password.text, latitude, longitude];
  NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                        allowLossyConversion:YES];
  NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:
                   [NSString stringWithFormat:
                    @"http://www.avatarv.com/letsplay/register.php"]]];
  [request setHTTPMethod:@"POST"];
  [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
  [request setValue:@"application/x-www-form-urlencoded"
    forHTTPHeaderField:@"Current-Type"];
  [request setHTTPBody:postData];
  NSURLConnection *conn = [[NSURLConnection alloc]initWithRequest:request
                                                         delegate:self];
  if(conn) {
    NSLog(@"Connection Successful");
  } else {
    NSLog(@"Connection could not be made");
    errors.text = @"connection could not be made";
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
  if(NSClassFromString(@"NSJSONSerialization")) {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization
                            JSONObjectWithData:data
                            options:NSJSONReadingMutableLeaves
                            error:&error];
    if ([[json objectForKey:@"source"] isEqualToString:@"register"]) {
      NSString *resp = [json objectForKey:@"response"];
      if ([resp isEqualToString:@"-1"]) {
        errors.text = @"username already exists!";
      } else {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:resp forKey:@"user_id"];
        [prefs synchronize];
        [self performSegueWithIdentifier:@"home_segue" sender:NULL];
      }
    } else {
      NSString *resp = [json objectForKey:@"response"];
      if ([resp isEqualToString:@"-1"]) {
        errors.text = @"username/password not valid";
      } else {
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:resp forKey:@"user_id"];
        [prefs synchronize];
        [self performSegueWithIdentifier:@"home_segue" sender:NULL];
      }
    }
    
  }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
  [textField resignFirstResponder];
  if (textField == username) {
    [password becomeFirstResponder];
  }
  return YES;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
  if (self.locationManager == nil) {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters;
    self.locationManager.delegate = self;
  }
  
  [self.locationManager startUpdatingLocation];
  
  // update last logged in
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSString *user_id = [prefs stringForKey:@"user_id"];
  if (user_id) {
    [self performSegueWithIdentifier:@"home_segue" sender:NULL];
  }
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  
    // Turn off the location manager to save power.
  [self.locationManager stopUpdatingLocation];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
