//
//  BuildsViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/4/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildFactory.h"

@interface BuildsViewController : UITableViewController

@property (nonatomic, weak) BuildFactory *buildFactory;

- (void)loadWithFactory:(BuildFactory*) buildFactory;
- (IBAction)addSelectedBuildsAction:(id)sender;

@end
