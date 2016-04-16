//
//  InitialViewController.m
//  PlumCash
//
//  Created by David Hartmann on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "InitialViewController.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "UIViewController+Alert.h"

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet UIButton *facebookButton;


@end

@implementation InitialViewController

#pragma mark - FB SDK Login Button Delegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (result.isCancelled) {
        [self showMessage:NSLocalizedString(@"Login.FacebookCanceled", @"user has to compete FB auth flow") withType:MessageTypeError];
        return;
    }
//    
//    FBSDKGraphRequest *request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"/me/" parameters:@{@"fields": @"id,first_name,last_name,email,gender,birthday",} HTTPMethod:@"GET"];
//    [request startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//        [self fetchData:result intoUser:[User currentUser]];
//        // attempt login
//        DDLogDebug(@"attempt login");
//        [self loginWithUsername:[User currentUser].username password:[User currentUser].password success:^{
//            // -- success: all good
//            DDLogDebug(@"login successful; user: %@", [User currentUser]);
//            [self handleLogin];
}

@end
