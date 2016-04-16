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

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *token;
@property (nonatomic, retain) NSNumber *userId;
@property (nonatomic, retain) NSString *imageUrl;
@property (nonatomic, retain) NSData *image;
@property (nonatomic) Gender gender;

+ (User *)currentUser;
+ (void)setCurrentUser:(User *)currentUser;
+ (UIImage*)getPlaceholderImage;

+ (NSDictionary*)fieldMappings;

@end
