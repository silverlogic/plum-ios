//
//  APIClient.h
//  PlumCash
//
//  Created by David Hartmann on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <Foundation/Foundation.h>

@class User;
@class Kid;
@class Card;
@class Transaction;
@class Rule;
@class Chore;

typedef NS_ENUM(NSInteger, StatusCode) {
    StatusCodeUnauthorized = 401
};

@interface APIClient : NSObject

///----------------------------------------------
/// @name Configuring the Shared API Client Instance
///----------------------------------------------

/**
 Return the shared instance of the API Client
 
 @return The shared API client instance.
 */
+ (instancetype)sharedClient;

+ (BOOL)isAuthenticated;
+ (NSString*)getToken;
+ (void)setToken:(NSString*)token;

/// Endpoints
+ (void)cancelAllRequests;
+ (void)signUpUser:(User*)user success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure;
+ (void)loginWithUsername:(NSString*)username andPassword:(NSString*)password success:(void (^)(User *user))success failure:(void (^)(NSError *error))failure;
+ (void)updateUser:(User*)user success:(void (^)(User *user))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)forgotPasswordForEmail:(NSString*)email success:(void (^)(bool successful))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)changePassword:(NSString*)oldPassword toPassword:(NSString *)newPassword success:(void (^)(bool successful))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)facebookLogin:(NSString*)token success:(void (^)(User *user))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)createKid:(Kid*)kid success:(void (^)(Kid *kid))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)getKidsSuccess:(void (^)(NSArray<Kid*> *kids))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)createCard:(Card*)card success:(void (^)(Card *card))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)getCardsForKid:(Kid*)kid success:(void (^)(NSArray<Card *> *cards))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)getCardsSuccess:(void (^)(NSArray<Card *> *cards))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)transferAmount:(NSNumber*)amount fromCard:(Card*)sourceCard toCard:(Card*)destinationCard success:(void (^)(BOOL successfully))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)getTransactionsForCard:(Card*)card success:(void (^)(NSArray<Transaction *> *transactions))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)getRulesForCard:(Card*)card success:(void (^)(NSArray<Rule *> *))success failure:(void (^)(NSError *, NSHTTPURLResponse *))failure;
+ (void)createRule:(Rule*)rule success:(void (^)(Rule *rule))success failure:(void (^)(NSError *error, NSHTTPURLResponse *response))failure;
+ (void)getChoresForKid:(Kid*)kid success:(void (^)(NSArray<Chore *> *chores))success failure:(void (^)(NSError *, NSHTTPURLResponse *))failure;

@end
