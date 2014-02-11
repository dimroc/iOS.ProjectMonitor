//
//  SemaphoreBuildsViewController.h
//  project-monitor
//
//  Created by Dimitri Roche on 2/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildFactory.h"

@interface SemaphoreBuildsViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

- (void) loadWithToken:(NSString*) authenticationToken;

@end
