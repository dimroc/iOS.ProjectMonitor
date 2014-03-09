//
//  ProjectMonitorPFLogInViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "ProjectMonitorLogInViewController.h"

@interface ProjectMonitorLogInViewController ()

@end

@implementation ProjectMonitorLogInViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [[self.logInView dismissButton] setHidden:YES];
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
}

@end