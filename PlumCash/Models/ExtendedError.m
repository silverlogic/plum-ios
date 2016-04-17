//
//  ExtendedError.m
//  PlumCash
//
//  Created by David Hartmann on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "ExtendedError.h"

@implementation ExtendedError

+ (NSDictionary*)fieldMappings {
    NSMutableDictionary *fieldMappings = [NSMutableDictionary dictionary];
    [fieldMappings addEntriesFromDictionary:@{
                                              @"detail": @"detail",
                                              @"id": @"userId",
                                              @"first_name": @"firstName",
                                              @"last_name": @"lastName",
                                              @"name": @"name",
                                              @"email": @"email",
                                              @"token": @"token",
                                              @"password": @"password",
                                              @"photo": @"profileImageUrl",
                                              @"non_field_errors": @"nonFieldErrors",
                                              @"image": @"image",
                                              @"old_password": @"oldPassword",
                                              @"push_token": @"deviceToken"
                                              }];
    return fieldMappings;
}

- (void)setFirstName:(NSArray *)firstName {
    _firstName = firstName;
    
    [self appendErrors:firstName forKey:@"Firstname"];
}
- (void)setLastName:(NSArray *)lastName {
    _lastName = lastName;
    
    [self appendErrors:lastName forKey:@"Lastname"];
}
- (void)setName:(NSArray *)name {
    _name = name;
    
    [self appendErrors:name forKey:@"Name"];
}
- (void)setEmail:(NSArray *)email {
    _email = email;
    
    [self appendErrors:email forKey:@"Email"];
}
- (void)setToken:(NSArray *)token {
    _token = token;
    
    [self appendErrors:token forKey:@"Token"];
}
- (void)setPassword:(NSArray *)password {
    _password = password;
    
    [self appendErrors:password forKey:@"Password"];
}
- (void)setOldPassword:(NSArray *)oldPassword {
    _oldPassword = oldPassword;
    
    [self appendErrors:oldPassword forKey:@"Old Password"];
}
- (void)setImage:(NSArray *)image {
    _image = image;
    
    [self appendErrors:image forKey:@"Image"];
}

- (void)setValidationErrorsDict:(NSDictionary *)validationErrorsDict {
    _validationErrorsDict = validationErrorsDict;
    
    if (!self.errorMessage) {
        self.errorMessage = @"";
    }
    
    for (NSDictionary *errorField in validationErrorsDict) {
        self.errorMessage = [self.errorMessage stringByAppendingFormat:@"%@.\n", [validationErrorsDict objectForKey:errorField]];
    }
}

- (void)setNonFieldErrors:(NSArray *)nonFieldErrors {
    _nonFieldErrors = nonFieldErrors;
    
    [self appendErrors:nonFieldErrors forKey:nil];
}

- (void)setDetail:(NSString *)detail {
    _detail = detail;
    
    if (!self.errorMessage) {
        self.errorMessage = @"";
    }
    self.errorMessage = [self.errorMessage stringByAppendingFormat:@"Attention: %@\n", detail];
}
- (void)setError:(NSString *)error {
    _error = error;
    
    if (!self.errorMessage) {
        self.errorMessage = @"";
    }
    self.errorMessage = [self.errorMessage stringByAppendingFormat:@"Error: %@\n", error];
}

#pragma mark - Helpers
- (void)appendErrors:(NSArray*)errors forKey:(NSString*)key {
    if (!self.errorMessage) {
        self.errorMessage = @"";
    }
    
    for (NSString *errorMessage in errors) {
        self.errorMessage = (key ? [self.errorMessage stringByAppendingFormat:@"%@: %@\n", key, errorMessage] : [self.errorMessage stringByAppendingFormat:@"%@\n", errorMessage]);
    }
}

@end
