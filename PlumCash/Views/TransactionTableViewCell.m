//
//  TransactionTableViewCell.m
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "TransactionTableViewCell.h"
#import "Transaction.h"

@implementation TransactionTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setTransaction:(Transaction *)transaction {
    _transaction = transaction;
    
    self.textLabel.text = transaction.merchantName;
    self.detailTextLabel.text = [NSString stringWithFormat:@"$%.2f", transaction.amount.floatValue];
}

@end
