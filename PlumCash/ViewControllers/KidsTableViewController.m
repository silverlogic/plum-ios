//
//  KidsTableViewController.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "KidsTableViewController.h"
#import "KidTableViewCell.h"
#import "Kid.h"
#import "APIClient.h"
#import "User.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

static NSString *const kLogoutSegue = @"LogoutSegue";
static NSString *const kLogoutSegueNoAnimation = @"LogoutSegueNoAnimation";

@interface KidsTableViewController ()

@end

@implementation KidsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
	self.list = [NSMutableArray array];
	[self.list addObjectsFromArray:[Kid mockKids]];
    
//    if (![APIClient isAuthenticated]) {
//        [self logout:NO];
//        NSLog(@"missing authentication --> logout");
//    }
}

- (void)logout:(BOOL)animated {
    [APIClient cancelAllRequests];
    [APIClient setToken:nil];
    [User setCurrentUser:nil];
    FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [self performSegueWithIdentifier:animated ? kLogoutSegue : kLogoutSegueNoAnimation sender:self];
    self.tabBarController.selectedIndex = 0;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	KidTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"KidTableViewCell" forIndexPath:indexPath];
	cell.kid = self.list[indexPath.row];
	// alternate background colors E6E7E7 / WHIT
	cell.backgroundColor = (indexPath.row % 2 == 1) ?  [UIColor whiteColor] : [UIColor colorWithRed:230/255.0 green:231/255.0 blue:231/255.0 alpha:1];
	
    return cell;
}

- (void)setList:(NSMutableArray *)list {
	_list = list;
	
	[self.tableView reloadData];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
