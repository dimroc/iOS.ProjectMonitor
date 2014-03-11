//
//  BlockAlertViewDelegate.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/17/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BlockAlertViewDelegate.h"

@implementation BlockAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    _callback(buttonIndex);
}

+ (void)showAlertView:(UIAlertView *)alertView withCallback:(AlertViewCompletionBlock)callback {
    __block BlockAlertViewDelegate *delegate = [[BlockAlertViewDelegate alloc] init];
    alertView.delegate = delegate;
    
    delegate.callback = ^(NSInteger buttonIndex) {
        if (callback) {
            callback(buttonIndex);
        }

        alertView.delegate = nil;
        delegate = nil;
    };
    
    [alertView show];
}

@end