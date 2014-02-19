//
//  ParseUITableViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParseUITableViewController : UITableViewController <PFLogInViewControllerDelegate, PFSignUpViewControllerDelegate>

- (void)showLogIn;

@end
