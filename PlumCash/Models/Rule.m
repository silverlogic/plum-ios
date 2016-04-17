//
//  Rule.m
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "Rule.h"

@implementation Rule

- (instancetype)init {
    self = [super init];
    if (self) {
        _categories = [NSMutableArray array];
    }
    return self;
}

+ (NSDictionary*)fieldMappings {
    NSDictionary *fields = @{
                             @"id": @"ruleId",
                             @"card": @"cardId",
                             @"type": @"type",
                             @"categories": @"categories"
                             };
    NSMutableDictionary *fieldMappings = [NSMutableDictionary dictionaryWithDictionary:fields];
    return fieldMappings;
}

@end
