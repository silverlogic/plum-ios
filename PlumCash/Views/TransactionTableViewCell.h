//
//  TransactionTableViewCell.h
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Transaction;

@interface TransactionTableViewCell : UITableViewCell

@property (nonatomic, strong) Transaction *transaction;

@end
