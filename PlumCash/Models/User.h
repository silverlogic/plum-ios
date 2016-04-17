//
//  User.h
//  PlumCash
//
//  Created by David Hartmann on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "Card.h"

static NSString *const kPassword = @"password";
static NSString *const kNewPassword = @"new_password";
static NSString *const kPasswordConfirm = @"confirm_new_password";
static NSString *const kEmail = @"email";
static NSString *const kOldPassword = @"old_password";

typedef NS_ENUM(NSUInteger, Gender) {
    GenderMale = 1,
    GenderFemale = 2
};

@interface User : NSObject

@property (nonatomic, strong) NSString *email;
@property (nonatomic, copy) NSString * firstName;
@property (nonatomic, copy) NSString * lastName;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *token;
@property (nonatomic, strong) NSNumber *userId;
@property (nonatomic, copy) NSString *imageUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic) Gender gender;
@property (nonatomic, strong) NSMutableArray <Card*> *cards;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (UIImage*)getPlaceholderImage;

+ (NSDictionary*)fieldMappings;

@end
