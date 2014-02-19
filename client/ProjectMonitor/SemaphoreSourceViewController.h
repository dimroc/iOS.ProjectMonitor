//
//  SemaphoreSourceViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"

@interface SemaphoreSourceViewController : UITableViewController <Source, UITextFieldDelegate>

@property (nonatomic, copy) NSString* name;
@property (nonatomic, weak) UIViewController* controller;

@end
