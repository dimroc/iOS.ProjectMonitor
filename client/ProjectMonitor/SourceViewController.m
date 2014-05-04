//
//  SemaphoreSourceViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SourceViewController.h"
#import "BuildsViewController.h"
#import "Build.h"
#import "Helper.h"

@interface SourceViewController ()
@end

@implementation SourceViewController

NSString *const SemaphoreTokenDefault = @"semaphoreToken";

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

- (IBAction)showSemaphoreDocumentationInfo:(id)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://semaphoreapp.com/docs/api_authentication.html"]];
}

- (IBAction)retrieveBuildsWithEnteredToken:(id)sender {
    [self textFieldShouldReturn:self.authenticationTokenTextField];
}

- (void)viewDidLoad {
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [self.authenticationTokenTextField setText:[defaults objectForKey:SemaphoreTokenDefault]];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([Helper stringValid: textField.text]) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setValue:textField.text forKey:SemaphoreTokenDefault];

        [textField resignFirstResponder];
        [self performSegueWithIdentifier:@"toAvailableSemaphoreBuilds" sender:self];
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
    [buildsController loadWithFactory:[self.buildFactory initWithToken:_authenticationTokenTextField.text]];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
