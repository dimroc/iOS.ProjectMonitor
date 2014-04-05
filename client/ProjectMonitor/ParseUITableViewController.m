//
//  ParseUITableViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "ParseUITableViewController.h"

#import "ProjectMonitorLogInViewController.h"
#import "ProjectMonitorSignUpViewController.h"
#import "ParseHelper.h"

@interface ParseUITableViewController ()

@end

@implementation ParseUITableViewController

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (![PFUser currentUser]) { // No user logged in
        [self showLogIn];
    }
}

-(void)showLogIn
{
    // Create the log in view controller
    ProjectMonitorLogInViewController *logInViewController = [[ProjectMonitorLogInViewController alloc] init];
    [logInViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Create the sign up view controller
    ProjectMonitorSignUpViewController *signUpViewController = [[ProjectMonitorSignUpViewController alloc] init];
    [signUpViewController setDelegate:self]; // Set ourselves as the delegate
    
    // Assign our sign up controller to be displayed from the login controller
    [logInViewController setSignUpController:signUpViewController];

    [logInViewController setFields:
     PFLogInFieldsFacebook |
     PFLogInFieldsTwitter |
     PFLogInFieldsUsernameAndPassword |
     PFLogInFieldsSignUpButton |
     PFLogInFieldsLogInButton |
     PFLogInFieldsPasswordForgotten];
    
    // Present the log in view controller
    [self presentViewController:logInViewController animated:YES completion:NULL];
}

#pragma mark - Parse Login callbacks

// Sent to the delegate to determine whether the log in request should be submitted to the server.
- (BOOL)logInViewController:(PFLogInViewController *)logInController shouldBeginLogInWithUsername:(NSString *)username password:(NSString *)password {
    // Check if both fields are completed
    if (username && password && username.length != 0 && password.length != 0) {
        return YES; // Begin login process
    }
    
    [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                message:@"Please fill in all information."
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
    return NO; // Interrupt login process
}

// Sent to the delegate when a PFUser is logged in.
- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user {
    NSLog(@"# Logging in username: %@", user.username);
    [ParseHelper registerUserForRemoteNotification:user];

    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if ([PFFacebookUtils isLinkedWithUser:user]) {
        // Create request for user's Facebook data
        FBRequest *request = [FBRequest requestForMe];
        
        // Send request to Facebook
        [request startWithCompletionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if (!error) {
                // result is a dictionary with the user's Facebook data
                NSDictionary *userData = (NSDictionary *)result;
                NSString *name = userData[@"name"];
                [defaults setValue:name forKey:@"username"];
            }
        }];
    } else if ([PFTwitterUtils isLinkedWithUser:user]) {
        NSString *twitterScreenName = [[PFTwitterUtils twitter] screenName];
        [defaults setValue:twitterScreenName forKey:@"username"];
    } else {
        [defaults setValue:user.username forKey:@"username"];
    }
}

// Sent to the delegate when the log in attempt fails.
- (void)logInViewController:(PFLogInViewController *)logInController didFailToLogInWithError:(NSError *)error {
    NSLog(@"# Failed to log in...");
    [[[UIAlertView alloc] initWithTitle:@"Login Failed"
                                message:@"Please re-enter your information."
                               delegate:nil
                      cancelButtonTitle:@"ok"
                      otherButtonTitles:nil] show];
}

// Sent to the delegate when the log in screen is dismissed.
- (void)logInViewControllerDidCancelLogIn:(PFLogInViewController *)logInController {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Parse Signup callbacks

// Sent to the delegate to determine whether the sign up request should be submitted to the server.
- (BOOL)signUpViewController:(PFSignUpViewController *)signUpController shouldBeginSignUp:(NSDictionary *)info {
    BOOL informationComplete = YES;
    
    // loop through all of the submitted data
    for (id key in info) {
        NSString *field = [info objectForKey:key];
        if (!field || field.length == 0) { // check completion
            informationComplete = NO;
            break;
        }
    }
    
    // Display an alert if a field wasn't completed
    if (!informationComplete) {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Make sure you fill out all of the information!"
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
    }
    
    return informationComplete;
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user {
//    [self dismissViewControllerAnimated:YES completion:nil];
}

// Sent to the delegate when the sign up attempt fails.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didFailToSignUpWithError:(NSError *)error {
    NSLog(@"# Failed to sign up: %@", error);
}

// Sent to the delegate when the sign up screen is dismissed.
- (void)signUpViewControllerDidCancelSignUp:(PFSignUpViewController *)signUpController {
    NSLog(@"# User dismissed the signUpViewController");
}

#pragma mark - Normal UITableViewController methods

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
