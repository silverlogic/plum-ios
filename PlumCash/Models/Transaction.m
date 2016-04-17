//
//  Transaction.m
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "Transaction.h"

@implementation Transaction

+ (NSDictionary*)fieldMappings {
    NSDictionary *fields = @{
                             @"id": @"transactionId",
                             @"card": @"cardId",
                             @"amount": @"amount",
                             @"merchant_name": @"merchantName",
                             @"status": @"status",
                             @"when": @"date"
                             };
    NSMutableDictionary *fieldMappings = [NSMutableDictionary dictionaryWithDictionary:fields];
    return fieldMappings;
}

@end
