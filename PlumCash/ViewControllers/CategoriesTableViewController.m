//
//  CategoriesTableViewController.m
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "APIClient.h"

@interface CategoriesTableViewController ()

@property (nonatomic, strong) NSMutableArray <NSString*> *list;

- (IBAction)savePressed:(id)sender;


@end

@implementation CategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = [NSMutableArray array];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshPulled) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadRules];
}

- (void)refreshPulled {
    [self loadRules];
}

- (void)loadRules {
    [APIClient getRulesSuccess:^(NSArray<Rule *> *rules) {
        [self.list removeAllObjects];
//        [self.list addObjectsFromArray:transactions];
        [self.tableView reloadData];
        [self.refreshControl endRefreshing];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        // tough luck
        [self.refreshControl endRefreshing];
    }];
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = NSLocalizedString(self.list[indexPath.row], nil);
    // alternate background colors E6E7E7 / WHIT
    cell.backgroundColor = (indexPath.row % 2 == 1) ?  [UIColor whiteColor] : [UIColor colorWithRed:230/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    
    return cell;
}

- (IBAction)savePressed:(id)sender {
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        //
    }
    
}
@end
