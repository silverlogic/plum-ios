//
//  UIViewController+Alert.h
//  PlumCash
//
//  Created by David Hartmann on 4/16/16.
//  Copyright © 2016 SilverLogic. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIAlertView+GRKAlertBlocks.h"

typedef NS_ENUM(NSUInteger, MessageType) {
    MessageTypeError,
    MessageTypeSuccess,
    MessageTypeWarning
};

@interface UIViewController (Alert)

- (void)showMessage:(NSString *)message withTitle:(NSString*)title;
- (void)showMessage:(NSString *)message withType:(MessageType)messageType;

@end
