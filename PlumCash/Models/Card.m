//
//  Card.m
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "Card.h"

@implementation Card

+ (NSDictionary*)fieldMappings {
    NSDictionary *fields = @{
                             @"id": @"cardId",
                             @"owner_type": @"ownerType",
                             @"owner_id": @"ownerId",
                             @"name_on_card": @"nameOnCard",
                             @"number": @"number",
                             @"expiration_date": @"expirationDate",
                             @"type": @"type",
                             @"sub_type": @"subType",
                             @"amount_on_card": @"allowance",
                             @"amount_spent": @"spent"
                             };
    NSMutableDictionary *fieldMappings = [NSMutableDictionary dictionaryWithDictionary:fields];
    return fieldMappings;
}

@end
