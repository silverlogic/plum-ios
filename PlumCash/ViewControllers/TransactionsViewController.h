//
//  TransactionsViewController.h
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Card.h"

@interface TransactionsViewController : UITableViewController

@property (nonatomic, strong) Card *card;

@end
