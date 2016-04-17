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
@property CGFloat allowance;
@property CGFloat spent;
@property (nonatomic, strong) NSMutableArray *cards;

+ (NSArray*)mockKids;
+ (Kid*)mockKid;
+ (NSDictionary*)fieldMappings;

@end
