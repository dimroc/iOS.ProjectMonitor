//
//  TravisSourceViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SourceViewController.h"

@interface TravisSourceViewController : UITableViewController <Source, UITextFieldDelegate>

@property (nonatomic, strong) BuildFactory *buildFactory;
@property (weak, nonatomic) IBOutlet UITextField *usernameTextField;
@property (weak, nonatomic) IBOutlet UITextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UITextField *twoFactorTextField;
@property (nonatomic) BOOL pro;

@end
