//
//  SemaphoreBuildsViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SemaphoreBuildsViewController.h"
#import "SemaphoreBuildFactory.h"
#import "BuildCell.h"
#import "BlockAlertViewDelegate.h"

@interface SemaphoreBuildsViewController ()

@end

@implementation SemaphoreBuildsViewController : BuildsViewController

- (void) loadWithToken:(NSString*) authenticationToken
{
    [[SemaphoreBuildFactory initWithToken:authenticationToken] fetchWithSuccess: ^(NSArray* builds){
        [super populateWithBuilds:builds];
    } failure: ^(NSError *error) {
        [super showErrorMessage:error];
    }];
}

@end
