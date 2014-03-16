//
//  PreferencesViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "PreferencesViewController.h"

@interface PreferencesViewController ()

@end

@implementation PreferencesViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *username = [defaults objectForKey:@"username"];
    
    if (username == nil) {
        username = [[PFUser currentUser] username];
    }
        
    [self.loggedInLabel setText:username];
}

- (IBAction)signOut:(id)sender
{
    NSLog(@"# Signing out");
    [PFUser logOut];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"username"];
    [self dismissModal:self];
}

- (IBAction)dismissModal:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showAuthorInfo:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/dimroc"]];
}

- (IBAction)showSourceInfo:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/dimroc/iOS.ProjectMonitor"]];
}

@end
