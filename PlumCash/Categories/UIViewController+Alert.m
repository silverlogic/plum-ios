//
//  UIViewController+Alert.m
//  PlumCash
//
//  Created by David Hartmann on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import "UIViewController+Alert.h"

@implementation UIViewController (Alert)

- (void)showMessage:(NSString *)message withTitle:(NSString *)title {
    [[[UIAlertView alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", @"OK") otherButtonTitles:nil] show];
}

- (void)showMessage:(NSString *)message withType:(MessageType)messageType {
    NSString *title;
    switch (messageType) {
        case MessageTypeError:
            title = NSLocalizedString(@"Alert.Title.Error", @"Error");
            break;
        case MessageTypeSuccess:
            title = NSLocalizedString(@"Alert.Title.Success", @"Success");
            break;
        case MessageTypeWarning:
            title = NSLocalizedString(@"Alert.Title.Warning", @"Warning");
            break;
        default:
            break;
    }
    [self showMessage:message withTitle:title];
}

@end
