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
#import "KidDetailViewController.h"
#import "CardIO.h"
#import "Card.h"

static NSString *const kLogoutSegue = @"LogoutSegue";
static NSString *const kLogoutSegueNoAnimation = @"LogoutSegueNoAnimation";

@interface KidsTableViewController () <CardIOPaymentViewControllerDelegate>

@end

@implementation KidsTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.list = [NSMutableArray array];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshPulled) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
    
    if (![APIClient isAuthenticated]) {
        [self logout:NO];
        NSLog(@"missing authentication --> logout");
        return;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    if ([APIClient isAuthenticated]) {
        [self loadKids];
        [self loadCards];
    }
}

- (void)refreshPulled {
    [self loadKids];
}

- (void)loadKids {
    [APIClient getKidsSuccess:^(NSArray<Kid *> *kids) {
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:kids];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        // tough luck
        [self.refreshControl endRefreshing];
    }];
}

- (void)loadCards {
    [APIClient getCardsSuccess:^(NSArray<Card *> *cards) {
        if (cards.count < 1) {
            [self promptForCard];
        }
    } failure:nil];
}

- (void)logout:(BOOL)animated {
    [APIClient cancelAllRequests];
//    [APIClient setToken:nil];
    [User setCurrentUser:nil];
    if (animated) {
        FBSDKLoginManager *loginManager = [[FBSDKLoginManager alloc] init];
        [loginManager logOut];
    }
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.destinationViewController isKindOfClass:[KidDetailViewController class]]) {
        KidDetailViewController *controller = segue.destinationViewController;
        KidTableViewCell *cell = (KidTableViewCell *)[self.tableView cellForRowAtIndexPath:self.tableView.indexPathForSelectedRow];
        controller.kid = cell.kid;
    }
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

- (void)promptForCard {
    CardIOPaymentViewController *scanViewController = [[CardIOPaymentViewController alloc] initWithPaymentDelegate:self];
    scanViewController.hideCardIOLogo = YES;
    scanViewController.collectCVV = NO;
    scanViewController.collectCardholderName = YES;
    [self presentViewController:scanViewController animated:YES completion:nil];
}

#pragma mark - card.io Delegate
- (void)userDidCancelPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    NSLog(@"User canceled payment info");
    // Handle user cancellation here...
    [scanViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)userDidProvideCreditCardInfo:(CardIOCreditCardInfo *)info inPaymentViewController:(CardIOPaymentViewController *)scanViewController {
    // Use the card info...
    Card *card = [Card new];
    card.ownerType = @"parent";
    card.ownerId = [User currentUser].userId;
    card.nameOnCard = info.cardholderName;
    card.number = info.cardNumber;
    card.expirationDate = [NSString stringWithFormat:@"%lu-%02lu-01", (unsigned long)info.expiryYear, (unsigned long)info.expiryMonth];
    [[User currentUser].cards addObject:card];
    
    [APIClient createCard:card success:^(Card *card) {
        //
        [scanViewController dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        // oh no!
        [scanViewController dismissViewControllerAnimated:YES completion:nil];
    }];
}

@end
