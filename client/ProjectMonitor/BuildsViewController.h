//
//  BuildsViewController.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/4/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BuildsViewController : UITableViewController

- (void)loadWithToken:(NSString*) authenticationToken;

- (IBAction)addSelectedBuildsAction:(id)sender;
- (void) populateWithBuilds:(NSArray *)builds;
- (void)showErrorMessage: (NSError *)error;

@end
