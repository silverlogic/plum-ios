//
//  CategoriesTableViewController.m
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "CategoriesTableViewController.h"
#import "APIClient.h"
#import "Rule.h"
#import "Card.h"

@interface CategoriesTableViewController ()

@property (nonatomic, strong) NSMutableArray <NSString*> *list;
@property (nonatomic, strong) NSMutableArray <NSString*> *selectedCategories;
@property (nonatomic, strong) NSMutableArray <Rule*> *rules;

- (IBAction)savePressed:(id)sender;


@end

@implementation CategoriesTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.list = @[
                  @"MCT_ADULT_ENTERTAINMENT",
                  @"MCT_AIRFARE",
                  @"MCT_ALCOHOL",
                  @"MCT_APPAREL_AND_ACCESSORIES",
                  @"MCT_AUTOMOTIVE",
                  @"MCT_CAR_RENTAL",
                  @"MCT_ELECTRONICS",
                  @"MCT_ENTERTAINMENT_AND_SPORTINGEVENTS",
                  @"MCT_GAMBLING",
                  @"MCT_GAS_AND_PETROLEUM",
                  @"MCT_GROCERY",
                  @"MCT_HOTEL_AND_LODGING",
                  @"MCT_HOUSEHOLD",
                  @"MCT_PERSONAL_CARE",
                  @"MCT_RECREATION",
                  @"MCT_SMOKE_AND_TOBACCO"
                  ].mutableCopy;
    
    self.selectedCategories = @[].mutableCopy;
    
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
    [APIClient getRulesForCard:self.card success:^(NSArray<Rule *> *rules) {
        self.rules = rules.mutableCopy;
        
        [self.selectedCategories removeAllObjects];
        for (Rule *rule in rules) {
            for (NSString *category in rule.categories) {
                [self.selectedCategories addObject:category];
            }
        }
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
    NSString *category = self.list[indexPath.row];
    cell.textLabel.text = NSLocalizedString(category, nil);
    // alternate background colors E6E7E7 / WHIT
    cell.backgroundColor = (indexPath.row % 2 == 1) ?  [UIColor whiteColor] : [UIColor colorWithRed:230/255.0 green:231/255.0 blue:231/255.0 alpha:1];
    if ([self.selectedCategories containsObject:category]) {
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryCheckmark;
    [self.selectedCategories addObject:self.list[indexPath.row]];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryNone;
    [self.selectedCategories removeObject:self.list[indexPath.row]];
}

- (IBAction)savePressed:(id)sender {
    // @TODO: delete rules
    
    Rule *rule = [Rule new];
    rule.type = @"merchant";
    rule.cardId = self.card.cardId;
    for (NSIndexPath *indexPath in self.tableView.indexPathsForSelectedRows) {
        [rule.categories addObject:self.list[indexPath.row]];
    }
    [APIClient createRule:rule success:^(Rule *rule) {
        [self.navigationController popViewControllerAnimated:YES];
    } failure:nil];
}
@end
