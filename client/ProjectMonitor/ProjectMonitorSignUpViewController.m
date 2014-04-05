//
//  ProjectMonitorSignUpViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "ProjectMonitorSignUpViewController.h"

@interface ProjectMonitorSignUpViewController ()

@end

@implementation ProjectMonitorSignUpViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.signUpView setLogo:[[UIImageView alloc] initWithImage:[UIImage imageNamed:@"logo.png"]]];
    [self.signUpView setBackgroundColor:[UIColor whiteColor]];
    
    [self setBorderColor:self.signUpView.usernameField];
    [self setBorderColor:self.signUpView.passwordField];
    [self setBorderColor:self.signUpView.emailField];
    
    [self.signUpView.usernameField setTextColor:[UIColor blackColor]];
    [self.signUpView.passwordField setTextColor:[UIColor blackColor]];
    [self.signUpView.emailField setTextColor:[UIColor blackColor]];
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

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
}

@end
