//
//  TravisSourceViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "TravisSourceViewController.h"
#import "GithubClient.h"
#import "BlockAlertViewDelegate.h"
#import "BuildsViewController.h"
#import "Helper.h"
#import "TravisClient.h"
#import "TravisBuildFactory.h"

@interface TravisSourceViewController ()
@property (nonatomic, copy) NSString *currentToken;
@end

@implementation TravisSourceViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([Helper stringValid: textField.text]) {
        [self getTravisTokens:self];
        return YES;
    }
    else {
        [[[UIAlertView alloc] initWithTitle:@"Missing Information"
                                    message:@"Please fill in all information."
                                   delegate:nil
                          cancelButtonTitle:@"ok"
                          otherButtonTitles:nil] show];
        return NO;
    }
}

- (IBAction)getTravisTokens:(id)sender {
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    __weak TravisSourceViewController *that = self;
    
    // Callback hell. Clean up with ReactiveCocoa.
    GithubClient* client = [[GithubClient alloc] initWithUsername:_usernameTextField.text andPassword:_passwordTextField.text];
    [client retrieveTokensWithSuccess:^(NSString *githubTravisToken, NSString *githubTravisProToken) {
        
        NSString *githubToken = _pro ? githubTravisProToken : githubTravisToken;
        if (githubToken == nil) {
            [that showNoTokenFound];
            [MBProgressHUD hideHUDForView:that.view animated:YES];
            return;
        }
        
        TravisClient *travisClient = [[TravisClient alloc] initWithToken:githubToken];
        [travisClient setPro:_pro];
        
        [travisClient retrieveTokenWithSuccess:^(NSString *token) {
            [that showBuildsControllerWithToken:token];
            [MBProgressHUD hideHUDForView:that.view animated:YES];
        } failure:^(NSError *error) {
            [that showUnableToRetrieveTokenError:error];
            [MBProgressHUD hideHUDForView:that.view animated:YES];
        }];
    } failure:^(NSError *error) {
        [that showUnableToRetrieveTokenError:error];
        [MBProgressHUD hideHUDForView:that.view animated:YES];
    }];
}

- (void)showBuildsControllerWithToken:(NSString*)token {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setCurrentToken:token];
        [self performSegueWithIdentifier:@"toAvailableTravisBuilds" sender:self];
    });
}

- (void)showUnableToRetrieveTokenError:(NSError*)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView* alert =
        [[UIAlertView alloc] initWithTitle:@"Unable to talk to Github"
                                   message:[error localizedDescription]
                                  delegate:nil
                         cancelButtonTitle:@"ok"
                         otherButtonTitles:nil];
        
        [BlockAlertViewDelegate showAlertView:alert withCallback:nil];
    });
}

- (void)showNoTokenFound {
    dispatch_async(dispatch_get_main_queue(), ^{
        UIAlertView* alert =
        [[UIAlertView alloc] initWithTitle:@"Unauthorized by Github"
                                   message:@"Github authorization not found. You must sign up to Travis through the website before adding builds."
                                  delegate:nil
                         cancelButtonTitle:@"ok"
                         otherButtonTitles:nil];
        
        [BlockAlertViewDelegate showAlertView:alert withCallback:nil];
    });
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BuildsViewController *buildsController = [segue destinationViewController];
    [buildsController loadWithFactory:[(TravisBuildFactory*)self.buildFactory initWithToken:self.currentToken andUsername:_usernameTextField.text]];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end