//
//  Kid.m
//  PlumCash
//
//  Created by Cristina on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "Kid.h"

@implementation Kid

+ (NSDictionary*)fieldMappings {
    NSDictionary *fields = @{
                             @"id": @"userId",
                             @"email": @"email",
                             @"name": @"name",
                             @"first_name": @"firstName",
                             @"last_name": @"lastName",
                             @"password": @"password",
                             @"token": @"token",
                             @"avatar.url": @"imageUrl"
                             };
    NSMutableDictionary *fieldMappings = [NSMutableDictionary dictionaryWithDictionary:fields];
    return fieldMappings;
}


#pragma mark - Mock
+ (NSArray*)mockKids {
	Kid *kid1 = [[Kid alloc] init];
	kid1.profileImageUrl = [NSURL URLWithString:@"http://www.cutecatpix.com/pictures/Cutecatpictures-sad_Cat_Closeup.jpg"];
	kid1.image = [UIImage imageNamed:@"visa"];
	kid1.name = @"Bob";
	kid1.points = 20.0;
	kid1.pointsGoal = 200.0;
	kid1.allowance = 100;
	kid1.spent = 10;
	
	Kid *kid2 = [[Kid alloc] init];
	kid2.profileImageUrl = [NSURL URLWithString:@"http://www.cutecatpix.com/pictures/Cutecatpictures-sad_Cat_Closeup.jpg"];
	kid2.image = [UIImage imageNamed:@"visa"];
	kid2.name = @"Bobbette";
	kid2.points = 20.0;
	kid2.pointsGoal = 200.0;
	kid2.allowance = 100;
	kid2.spent = 10;
	
	return @[ kid1, kid2];
}

+ (Kid*)mockKid {
	return [Kid mockKids][0];
}

@end
