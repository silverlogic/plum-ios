//
//  TransactionsViewController.m
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "TransactionsViewController.h"
#import "APIClient.h"
#import "Transaction.h"
#import "TransactionTableViewCell.h"

@interface TransactionsViewController ()

@property (nonatomic, strong) NSMutableArray <Transaction*> *list;

@end

@implementation TransactionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = [NSMutableArray array];
    
    UIRefreshControl *refreshControl = [UIRefreshControl new];
    [refreshControl addTarget:self action:@selector(refreshPulled) forControlEvents:UIControlEventValueChanged];
    self.refreshControl = refreshControl;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self loadTransactions];
}

- (void)refreshPulled {
    [self loadTransactions];
}

- (void)loadTransactions {
    if (!self.card) {
        return;
    }
    [APIClient getTransactionsForCard:self.card success:^(NSArray<Transaction *> *transactions) {
        [self.list removeAllObjects];
        [self.list addObjectsFromArray:transactions];
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
    TransactionTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TransactionTableViewCell" forIndexPath:indexPath];
    cell.transaction = self.list[indexPath.row];
    // alternate background colors E6E7E7 / WHIT
    cell.backgroundColor = (indexPath.row % 2 == 1) ?  [UIColor whiteColor] : [UIColor colorWithRed:230/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    
    return cell;
}

@end
