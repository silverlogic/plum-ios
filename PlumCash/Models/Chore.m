//
//  Chore.m
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "Chore.h"

@implementation Chore

+ (NSDictionary*)fieldMappings {
    NSDictionary *fields = @{
                             @"id": @"choreId",
                             @"kid": @"kidId",
                             @"name": @"name",
                             @"points": @"points",
                             @"status": @"status"
                             };
    NSMutableDictionary *fieldMappings = [NSMutableDictionary dictionaryWithDictionary:fields];
    return fieldMappings;
}

@end
