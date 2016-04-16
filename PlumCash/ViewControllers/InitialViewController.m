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
#import "User.h"
#import "APIClient.h"

@interface InitialViewController () <FBSDKLoginButtonDelegate>

@property (weak, nonatomic) IBOutlet FBSDKLoginButton *facebookButton;


@end

@implementation InitialViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.facebookButton.delegate = self;
    self.facebookButton.readPermissions = @[@"public_profile", @"email"];
}

#pragma mark - FB SDK Login Button Delegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (result.isCancelled) {
        [self showMessage:NSLocalizedString(@"Login.FacebookCanceled", @"user has to compete FB auth flow") withType:MessageTypeError];
        return;
    }
    
    [APIClient facebookLogin:result.token.tokenString success:^(User *user) {
        //
        [self dismissViewControllerAnimated:YES completion:nil];
    } failure:^(NSError *error, NSHTTPURLResponse *response) {
        //
    }];
}

- (void)loginButtonDidLogOut:(FBSDKLoginButton *)loginButton {
    // do nothing
}

@end
