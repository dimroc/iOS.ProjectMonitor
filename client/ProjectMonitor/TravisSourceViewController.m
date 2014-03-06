//
//  TravisSourceViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/4/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "TravisSourceViewController.h"
#import "BuildsViewController.h"
#import "Helper.h"

@interface TravisSourceViewController ()

@property (nonatomic, copy) NSArray *builds;

@end

@implementation TravisSourceViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    [self setName:@"Travis"];
    [self setController:self];
    return self;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([Helper stringValid: textField.text]) {
        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"toAvailableTravisBuilds" sender:self];
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

#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    BuildsViewController *buildsController = [segue destinationViewController];
    [buildsController loadWithToken:_authenticationTokenTextField.text];
}

@end
