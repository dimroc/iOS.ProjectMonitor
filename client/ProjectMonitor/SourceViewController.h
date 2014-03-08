//
//  SemaphoreSourceViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "BuildFactory.h"

@interface SourceViewController : UITableViewController <Source, UITextFieldDelegate>

@property (nonatomic, copy) NSString* name;
@property (nonatomic, weak) UIViewController* controller;
@property (nonatomic, strong) BuildFactory *buildFactory;
@property (weak, nonatomic) IBOutlet UITextField *authenticationTokenTextField;

@end
