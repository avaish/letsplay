//
//  LPSportsController.m
//  Let's Play
//
//  Created by Atharv Vaish on 6/13/13.
//  Copyright (c) 2013 LP. All rights reserved.
//

#import "LPSportsController.h"

@interface LPSportsController ()

@property (strong, nonatomic) NSMutableArray *sports;
@property (strong, nonatomic) NSMutableArray *sport_ids;

@end

@implementation LPSportsController

@synthesize sport_ids = _sport_ids;
@synthesize sports = _sports;

- (NSMutableArray *)sports
{
  if (!_sports) {
    _sports = [[NSMutableArray alloc] init];
  }
  return _sports;
}

- (NSMutableArray *)sport_ids
{
  if (!_sport_ids) {
    _sport_ids = [[NSMutableArray alloc] init];
  }
  return _sport_ids;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
  
  [super viewDidLoad];
  [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
  
  NSLog(@"anything???");
  
  NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
  NSString *user_id = [prefs stringForKey:@"user_id"];

  NSString *post = [NSString stringWithFormat:
                    @"&user_id=%@", user_id];
  NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding
                        allowLossyConversion:YES];
  NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
  NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
  [request setURL:[NSURL URLWithString:
                   [NSString stringWithFormat:
                    @"http://www.avatarv.com/letsplay/get_sports.php"]]];
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
  }
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData*)data {
  if(NSClassFromString(@"NSJSONSerialization")) {
    NSError *error = nil;
    NSDictionary *json = [NSJSONSerialization
                          JSONObjectWithData:data
                          options:NSJSONReadingMutableLeaves
                          error:&error];
    if ([[json objectForKey:@"source"] isEqualToString:@"get_sports"]) {
      NSArray *resp = [json objectForKey:@"response"];
      for (NSDictionary *s in resp) {
        NSLog([s objectForKey:@"name"]);
        [self.sports addObject:[s objectForKey:@"name"]];
        [self.sport_ids addObject:[s objectForKey:@"id"]];
      }
      [self.tableView reloadData];
    }
  }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSLog(@"GOT HERE 3");
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  NSLog(@"GOT HERE 2");
  NSLog(@"%d", self.sports.count);
  // Return the number of rows in the section.
  return self.sports.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"GOT HERE 1");
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    NSString *cellValue = [self.sports objectAtIndex:indexPath.row];
    cell.textLabel.text = cellValue;
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
