//
//  Kid.h
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "User.h"

@interface Kid : User

@property (nonatomic, strong) NSNumber *kidId;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *profileImage;
@property (nonatomic, strong) NSURL *profileImageUrl;
@property CGFloat points;
@property CGFloat pointsGoal;
@property (nonatomic, strong) NSNumber *allowance;
@property (nonatomic, strong) NSNumber *spent;
@property (nonatomic, strong) NSNumber *defaultAllowance;
@property (nonatomic, strong) NSNumber *savingsMatch;

+ (NSArray*)mockKids;
+ (Kid*)mockKid;
+ (NSDictionary*)fieldMappings;

@end
