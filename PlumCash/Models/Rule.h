//
//  Rule.h
//  PlumCash
//
//  Created by David Hartmann on 4/17/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Rule : NSObject

@property (nonatomic, strong) NSNumber *ruleId;
@property (nonatomic, strong) NSNumber *cardId;
@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSMutableArray *categories;

+ (NSDictionary*)fieldMappings;

@end
