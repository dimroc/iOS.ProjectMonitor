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
    
    [self.logInView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    [self.logInView setBackgroundColor:[UIColor whiteColor]];
    
    [self setBorderColor:self.logInView.usernameField];
    [self setBorderColor:self.logInView.passwordField];
    
    [self.logInView.usernameField setTextColor:[UIColor blackColor]];
    [self.logInView.passwordField setTextColor:[UIColor blackColor]];
}

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleDefault;
}

- (void)setBorderColor:(UITextField*)field {
    field.layer.cornerRadius=5.0f;
    field.layer.masksToBounds=YES;
    field.layer.borderColor=[[UIColor darkGrayColor]CGColor];
    field.layer.borderWidth= .2f;
    
    CALayer *layer = field.layer;
    layer.shadowOpacity = 0.0;
    layer.backgroundColor = [[UIColor lightTextColor] CGColor];
}

@end