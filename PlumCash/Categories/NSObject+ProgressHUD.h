//
//  NSObject+ProgressHUD.h
//  PlumCash
//
//  Created by David Hartmann on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"

static const NSUInteger HUDDuration1Second = 1000000;
static const NSUInteger HUDDuration3Seconds = HUDDuration1Second * 3;
static const NSUInteger HUDDuration5Seconds = HUDDuration1Second * 5;
static const NSUInteger HUDDuration10Seconds = HUDDuration1Second * 10;


@interface NSObject (ProgressHUD)

- (void)hideAllHUDs;

- (void)showHud;
- (void)showHudLoading;
- (void)showHudWithTitle:(NSString*)title;
- (void)showHudWithTitle:(NSString*)title message:(NSString*)message;
- (void)showHudWithTitle:(NSString*)title message:(NSString*)message forDuration:(NSUInteger)duration;
- (void)showHudWithTitle:(NSString*)title message:(NSString*)message forDuration:(NSUInteger)duration isDismissable:(BOOL)dismissable;
- (void)showHudWithTitle:(NSString*)title message:(NSString*)message forDuration:(NSUInteger)duration isDismissable:(BOOL)dismissable withColor:(UIColor*)color;
- (void)showHudWithTitle:(NSString*)title message:(NSString*)message forDuration:(NSUInteger)duration isDismissable:(BOOL)dismissable withColor:(UIColor*)color inMode:(MBProgressHUDMode)mode;
- (void)showHudWithTitle:(NSString*)title message:(NSString*)message forDuration:(NSUInteger)duration isDismissable:(BOOL)dismissable withColor:(UIColor*)color inMode:(MBProgressHUDMode)mode inView:(UIView*)view;

- (MBProgressHUD*)showProgressHudWithTitle:(NSString*)title message:(NSString*)message;
- (void)hideProgressHud:(MBProgressHUD*)hud afterSuccess:(BOOL)success;
- (void)hideProgressHud:(MBProgressHUD*)hud afterSuccess:(BOOL)success withTitle:(NSString*)title message:(NSString*)message;

@end
