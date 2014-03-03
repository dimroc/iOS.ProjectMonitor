//
//  SemaphoreBuildsViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Build.h"

@interface SemaphoreBuildsViewController : UITableViewController

- (void)loadWithToken:(NSString*) authenticationToken;
- (IBAction)addSelectedBuildsAction:(id)sender;

@end
