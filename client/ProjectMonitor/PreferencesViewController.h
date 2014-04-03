//
//  PreferencesViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const PMUserDidLogOut;

@interface PreferencesViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UILabel *loggedInLabel;

@end
