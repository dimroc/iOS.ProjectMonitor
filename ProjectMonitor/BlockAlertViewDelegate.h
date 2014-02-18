//
//  BlockAlertViewDelegate.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/17/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^AlertViewCompletionBlock)(NSInteger buttonIndex);

@interface BlockAlertViewDelegate : NSObject<UIAlertViewDelegate>

@property (strong,nonatomic) AlertViewCompletionBlock callback;

+ (void)showAlertView:(UIAlertView *)alertView withCallback:(AlertViewCompletionBlock)callback;

@end
