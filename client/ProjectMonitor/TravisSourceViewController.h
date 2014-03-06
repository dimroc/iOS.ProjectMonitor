//
//  TravisSourceViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/4/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"

@interface TravisSourceViewController : UITableViewController <Source, UITextFieldDelegate>

@property (nonatomic, copy) NSString* name;
@property (nonatomic, weak) UIViewController* controller;
@property (weak, nonatomic) IBOutlet UITextField *authenticationTokenTextField;

@end
