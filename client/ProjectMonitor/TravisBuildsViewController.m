//
//  TravisBuildsViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/4/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "TravisBuildsViewController.h"
#import "TravisBuildFactory.h"

@interface TravisBuildsViewController ()

@end

@implementation TravisBuildsViewController : BuildsViewController

- (void) loadWithToken:(NSString*) authenticationToken
{
    BuildFactory* factory = [[TravisBuildFactory alloc] initWithToken:authenticationToken];
    [factory fetchWithSuccess: ^(NSArray* builds){
        [super populateWithBuilds:builds];
    } failure: ^(NSError *error) {
        [super showErrorMessage:error];
    }];
}

@end
