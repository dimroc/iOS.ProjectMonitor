//
//  SemaphoreSourceViewController.m
//  project-monitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SemaphoreSourceViewController.h"
#import "SemaphoreBuildsViewController.h"
#import "BuildFactory.h"

@interface SemaphoreSourceViewController ()

@property (weak, nonatomic) IBOutlet UITextField *authenticationTokenTextField;
@property (nonatomic, copy) NSArray *builds;

@end

@implementation SemaphoreSourceViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setName:@"Semaphore"];
    [self setController:self];
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([self authenticationFieldValid]) {
        [textField resignFirstResponder];
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

- (BOOL)authenticationFieldValid
{
    if (self.authenticationTokenTextField.text && self.authenticationTokenTextField.text.length != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }

}

#pragma mark - Navigation

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender
{
    if ([self authenticationFieldValid]) {
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

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    SemaphoreBuildsViewController *buildsController = [segue destinationViewController];
    [buildsController loadWithToken:_authenticationTokenTextField.text];
}

@end
