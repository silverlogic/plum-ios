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

@interface InitialViewController ()

@property (weak, nonatomic) IBOutlet FBSDKButton *facebookButton;


@end

@implementation InitialViewController

#pragma mark - FB SDK Login Button Delegate
- (void)loginButton:(FBSDKLoginButton *)loginButton didCompleteWithResult:(FBSDKLoginManagerLoginResult *)result error:(NSError *)error {
    [[[UIApplication sharedApplication] keyWindow] endEditing:YES];
    
    if (result.isCancelled) {
        [self showMessage:NSLocalizedString(@"Login.FacebookCanceled", @"user has to compete FB auth flow") withType:MessageTypeError];
        return;
    }
    
//    @TODO: send result.token to API
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
