//
//  APIClient.m
//  PlumCash
//
//  Created by David Hartmann on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "APIClient.h"
#import <RestKit/RestKit.h>
#import "RKCLLocationValueTransformer.h"
#import "AFHTTPClient.h"
#import "RKPathMatcher.h"
#import "ExtendedError.h"
#import "User.h"
#import "Kid.h"

//////////////////////////////////
// Shared Instance
static APIClient  *_sharedClient = nil;
static void (^_defaultFailureBlock)(RKObjectRequestOperation *operation, NSError *error) = nil;
static NSString *const apiUrl = @"http://6fe345e1.ngrok.io/v1/";

// Default Headers
static NSString *const kAuthorization = @"Authorization";

// API Parameters
static NSString *const kResults		= @"results";
static NSString *const kPageSize	= @"page_size";
static NSString *const kPage		= @"page";


// Endpoints
static NSString *const kFacebookEndpoint = @"login/facebook";
static NSString *const kSignupEndpoint = @"register";
static NSString *const kLoginEndpoint = @"login";
static NSString *const kForgotPasswordEndpoint = @"forgot-password";
static NSString *const kChangePasswordEndpoint = @"users/change-password";
static NSString *const kUserEndpoint = @"users/:userId";
static NSString *const kMeEndpoint = @"users/me";
static NSString *const kKidsEndpoint = @"kids";
static NSString *const kKidEndpoint = @"kid/:kidId";

typedef NS_ENUM(NSUInteger, PageSize) {
    PageSizeDefault  = 20,
    PageSizeSmall    = 10,
    PageSizeMedium   = 300,
    PageSizeLarge    = 1000
};

@interface APIClient ()


@end

@implementation APIClient

- (instancetype)init {
    self = [super init];
    if (self) {
        // initialize stuff here
        [self initRestKit];
        
        [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
        
        _defaultFailureBlock = ^(RKObjectRequestOperation *operation, NSError *error) {
            // Transport error or server error handled by errorDescriptor
            [[[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Alert.Title.Error", @"Alert Error title") message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"Alert.OK", @"Alert OK button title") otherButtonTitles:nil] show];
        };
    }
    
    return self;
}

+ (instancetype)sharedClient {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[APIClient alloc] init];
        // Do any other initialisation stuff here
    });
    return _sharedClient;
}

- (void)initRestKit {
#ifdef DEBUG
    RKLogConfigureByName("RestKit/Network*", RKLogLevelTrace);
    RKLogConfigureByName("RestKit/ObjectMapping", RKLogLevelTrace);
#endif
    
    [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookieAcceptPolicy:NSHTTPCookieAcceptPolicyNever];
    
    NSIndexSet *successStatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassSuccessful); // Anything in 2xx
    NSIndexSet *error400StatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassClientError); // Anything in 4xx
    NSIndexSet *error500StatusCodes = RKStatusCodeIndexSetForClass(RKStatusCodeClassServerError); // Anything in 5xx
    
    /* ********************************************* */
    /* ********* MAPPINGS ************************** */
    /* ERROR */
    RKObjectMapping *errorMapping = [RKObjectMapping mappingForClass:[ExtendedError class]];
    // The entire value at the source key path containing the errors maps to the message
    [errorMapping addAttributeMappingsFromDictionary:[ExtendedError fieldMappings]];
    // Any response in the 4xx status code range with an "errors" key path uses
    RKResponseDescriptor *error400Descriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:error400StatusCodes];
    RKResponseDescriptor *error500Descriptor = [RKResponseDescriptor responseDescriptorWithMapping:errorMapping method:RKRequestMethodAny pathPattern:nil keyPath:nil statusCodes:error500StatusCodes];
    
    /* EMPTY */
    RKObjectMapping *emptyResponseMapping = [RKObjectMapping mappingForClass:[NSDictionary class]];
    
    /* USER */
    RKObjectMapping *userResponseMapping = [RKObjectMapping mappingForClass:[User class]];
    [userResponseMapping addAttributeMappingsFromDictionary:[User fieldMappings]];
    
    /* KID */
    RKObjectMapping *kidResponseMapping = [RKObjectMapping mappingForClass:[Kid class]];
    [kidResponseMapping addAttributeMappingsFromDictionary:[Kid fieldMappings]];
    
    /* ********************************************* */
    /* ********* RESPONSE DESCRIPTORS ************** */
    /* SIGNUP */
    RKResponseDescriptor *signupResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userResponseMapping method:RKRequestMethodPOST pathPattern:kSignupEndpoint keyPath:nil statusCodes:successStatusCodes];
    RKResponseDescriptor *facebookResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userResponseMapping method:RKRequestMethodPOST pathPattern:kFacebookEndpoint keyPath:nil statusCodes:successStatusCodes];
    /* LOGIN */
    RKResponseDescriptor *loginResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userResponseMapping method:RKRequestMethodPOST pathPattern:kLoginEndpoint keyPath:nil statusCodes:successStatusCodes];
    /* FORGOT PASSWORD */
    RKResponseDescriptor *forgotPasswordResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:emptyResponseMapping method:RKRequestMethodPOST pathPattern:kForgotPasswordEndpoint keyPath:nil statusCodes:successStatusCodes];
    /* CHANGE PASSWORD */
    RKResponseDescriptor *changePasswordResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:emptyResponseMapping method:RKRequestMethodPOST pathPattern:kChangePasswordEndpoint keyPath:nil statusCodes:successStatusCodes];
    /* USER */
    RKResponseDescriptor *userResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userResponseMapping method:RKRequestMethodPATCH pathPattern:kUserEndpoint keyPath:nil statusCodes:successStatusCodes];
    RKResponseDescriptor *meResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:userResponseMapping method:RKRequestMethodGET pathPattern:kMeEndpoint keyPath:nil statusCodes:successStatusCodes];
    /* KID */
    RKResponseDescriptor *kidsResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:kidResponseMapping method:RKRequestMethodAny pathPattern:kKidsEndpoint keyPath:kResults statusCodes:successStatusCodes];
    RKResponseDescriptor *kidResponseDescriptor = [RKResponseDescriptor responseDescriptorWithMapping:kidResponseMapping method:RKRequestMethodAny pathPattern:kKidEndpoint keyPath:nil statusCodes:successStatusCodes];
    
    /* ********************************************* */
    /* ********** REQUEST DESCRIPTORS ************** */
    /* KID */
    RKObjectMapping *kidRequestMapping = [kidResponseMapping inverseMapping];
    // prevents null from being sent when not set
    kidRequestMapping.assignsDefaultValueForMissingAttributes = NO;
    RKRequestDescriptor *kidRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:kidRequestMapping objectClass:[Kid class] rootKeyPath:nil method:RKRequestMethodAny];
    
    /* USER */
//    RKObjectMapping *userRequestMapping = [RKObjectMapping mappingForClass:[NSMutableDictionary class]];
//    [userRequestMapping addAttributeMappingsFromDictionary:[User requestFieldMappings]];
//    // prevents null from being sent when not set
//    userRequestMapping.assignsDefaultValueForMissingAttributes = NO;
//    RKRequestDescriptor *userRequestDescriptor = [RKRequestDescriptor requestDescriptorWithMapping:userRequestMapping objectClass:[User class] rootKeyPath:nil method:RKRequestMethodAny];
    
    /* ********************************************* */
    RKObjectManager *manager = [RKObjectManager managerWithBaseURL:[NSURL URLWithString:apiUrl]];
    manager.requestSerializationMIMEType = RKMIMETypeJSON;
    
    // Add our descriptors to the manager
    [manager addRequestDescriptorsFromArray:@[
                                              kidRequestDescriptor,
//                                              userRequestDescriptor
                                              ]];
    [manager addResponseDescriptorsFromArray:@[
                                               facebookResponseDescriptor,
                                               loginResponseDescriptor,
                                               signupResponseDescriptor,
                                               forgotPasswordResponseDescriptor,
                                               changePasswordResponseDescriptor,
                                               userResponseDescriptor,
                                               meResponseDescriptor,
                                               kidsResponseDescriptor,
                                               kidResponseDescriptor,
                                               error400Descriptor,
                                               error500Descriptor
                                               ]];
    
    // Pagination mapping
    RKObjectMapping *paginationMapping = [RKObjectMapping mappingForClass:[RKPaginator class]];
    [paginationMapping addAttributeMappingsFromDictionary:@{
                                                            @"page_size": @"perPage",
                                                            @"total_pages": @"pageCount",
                                                            @"count": @"objectCount"
                                                            }];
    [manager setPaginationMapping:paginationMapping];
    
    if ([APIClient isAuthenticated]) {
        NSString *token = [APIClient getToken];
        [[manager HTTPClient] setDefaultHeader:kAuthorization value:[NSString stringWithFormat:@"Token %@", token]];
    }
}

#pragma mark - API Endpoints
+ (void)cancelAllRequests {
    [[RKObjectManager sharedManager].operationQueue cancelAllOperations];
}

+ (void)getMe:(void (^)(User *))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure {
    [[RKObjectManager sharedManager] getObject:[User currentUser] path:kMeEndpoint parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation.HTTPRequestOperation.response);
        } else {
            _defaultFailureBlock(operation, error);
        }
    }];
}

+ (void)facebookLogin:(NSString *)token success:(void (^)(User *))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure {
    NSDictionary *params = @{ @"token": token };
    [[RKObjectManager sharedManager] postObject:nil path:kFacebookEndpoint parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        User *user = mappingResult.firstObject;
        [APIClient setToken:user.token];
        [APIClient getMe:^(User *user) {
            if (success) {
                success(mappingResult.firstObject);
            }
        } failure:^(NSError *error, NSHTTPURLResponse *response) {
            if (failure) {
                failure(error, operation.HTTPRequestOperation.response);
            } else {
                _defaultFailureBlock(operation, error);
            }
        }];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation.HTTPRequestOperation.response);
        } else {
            _defaultFailureBlock(operation, error);
        }
    }];
}

+ (void)signUpUser:(User*)user  success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure {
    [[RKObjectManager sharedManager] postObject:user path:kSignupEndpoint parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        //        User *user = mappingResult.firstObject;
        [APIClient loginWithUsername:user.email andPassword:user.password success:^(User *user) {
            if (success) {
                success(user);
            }
        } failure:^(NSError *error) {
            if (failure) {
                failure(error);
            } else {
                _defaultFailureBlock(operation, error);
            }
        }];
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        } else {
            _defaultFailureBlock(operation, error);
        }
    }];
}

+ (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[kEmail] = username;
    params[kPassword] = password;
    
    [[RKObjectManager sharedManager] postObject:nil path:kLoginEndpoint parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        User *user = mappingResult.firstObject;
        [APIClient setToken:user.token];
        user.password = password;
        [User setCurrentUser:user];
        if (success) {
            success(user);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        } else {
            _defaultFailureBlock(operation, error);
        }
    }];
}

+ (void)updateUser:(User*)user success:(void (^)(User *user))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure {
    [[RKObjectManager sharedManager] patchObject:user path:RKPathFromPatternWithObject(kUserEndpoint, user) parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.firstObject);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation.HTTPRequestOperation.response);
        } else {
            _defaultFailureBlock(operation, error);
        }
    }];
}

+ (void)forgotPasswordForEmail:(NSString *)email success:(void (^)(bool successful))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure {
    NSDictionary *params = @{
                             kEmail: email
                             };
    [[RKObjectManager sharedManager] postObject:nil path:kForgotPasswordEndpoint parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(YES);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation.HTTPRequestOperation.response);
        } else {
            _defaultFailureBlock(operation, error);
        }
    }];
}

+ (void)changePassword:(NSString*)oldPassword toPassword:(NSString *)newPassword success:(void (^)(bool successful))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure {
    NSDictionary *params = @{
                             kOldPassword: oldPassword,
                             kPassword: newPassword
                             };
    [[RKObjectManager sharedManager] postObject:nil	path:kChangePasswordEndpoint parameters:params success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        [User currentUser].password = newPassword;
        if (success) {
            success(YES);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation.HTTPRequestOperation.response);
        } else {
            _defaultFailureBlock(operation, error);
        }
    }];
}

+ (void)getKidsSuccess:(void (^)(NSArray<Kid *> *))success failure:(void (^)(NSError *, NSHTTPURLResponse *))failure {
    [[RKObjectManager sharedManager] getObject:[User currentUser] path:kKidsEndpoint parameters:nil success:^(RKObjectRequestOperation *operation, RKMappingResult *mappingResult) {
        if (success) {
            success(mappingResult.array);
        }
    } failure:^(RKObjectRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error, operation.HTTPRequestOperation.response);
        } else {
            _defaultFailureBlock(operation, error);
        }
    }];
}


#pragma mark - Helpers
+ (BOOL)isAuthenticated {
    return ([self getToken] != nil);
}

+ (NSString*)getToken {
    NSString *token = [[NSUserDefaults standardUserDefaults] valueForKey:@"token"];
    return token;
}
+ (void)setToken:(NSString*)token {
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"token"];
    
    RKObjectManager *manager = [RKObjectManager sharedManager];
    if (token) {
        [[manager HTTPClient] setDefaultHeader:kAuthorization value:[NSString stringWithFormat:@"Token %@", token]];
    } else {
        [[manager HTTPClient] clearAuthorizationHeader];
    }
}


@end
