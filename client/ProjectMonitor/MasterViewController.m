//
//  MasterViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 1/29/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "MasterViewController.h"
#import "Build.h"
#import "BuildCell.h"
#import "BuildCollection.h"

@interface MasterViewController ()

@property (strong, nonatomic) BuildCollection *buildCollection;
@property (strong, nonatomic) UIView *addBuildOverlayView;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBuildCollection:[[BuildCollection alloc] init]];
    [self.buildCollection refresh];

    UINib *nib = [UINib nibWithNibName:@"BuildCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"BuildCell"];
    
    // Your scroll view or table view would be a subview of this view
    UINib *emptyViewNib = [UINib nibWithNibName:@"AddBuildOverlayView" bundle:nil];
    [self setAddBuildOverlayView:[emptyViewNib instantiateWithOwner:self options:nil][0]];
    
    [self toggleAddBuildOverlay];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleNewBuild:) name:PMBuildDidSaveNotication object:nil];
}

- (void)forceRefresh
{
    [self toggleAddBuildOverlay];
    [self.refreshControl beginRefreshing];
    [self triggerRefresh];
}

- (void)handleNewBuild:(NSNotification *)notification
{
    [self forceRefresh];
}

- (void)toggleAddBuildOverlay
{
    if ([self.buildCollection isEmpty]) {
        [self.view addSubview:_addBuildOverlayView];
        [self.view bringSubviewToFront:_addBuildOverlayView];
    } else {
        [_addBuildOverlayView removeFromSuperview];
    }
}

- (IBAction)triggerRefresh
{
    __weak MasterViewController *that = self;
    
    [Build refreshSavedBuildsInBackground:^(BOOL succeeded, NSArray *builds) {
        if (succeeded) {
            [[that buildCollection] refresh];
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Failed to refresh"
                                        message:@"Please try again later."
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil] show];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"# Finished refresh");
            [that toggleAddBuildOverlay];
            [that.tableView reloadData];
            [that.refreshControl endRefreshing];
        });
    }];
}

- (void)clearTable
{
    [[self buildCollection] clear];
    [self.tableView reloadData];
}

#pragma mark - ParseUITableViewController

- (void)logInViewController:(PFLogInViewController *)logInController didLogInUser:(PFUser *)user
{
    [super logInViewController:logInController didLogInUser:user];
    [self clearTable];
    [self forceRefresh];
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [super signUpViewController:signUpController didSignUpUser:user]; // Dismiss the PFSignUpViewController
    [self clearTable];
    [self forceRefresh];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.buildCollection onlyPopulated] count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.buildCollection onlyPopulatedTitles][section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.buildCollection onlyPopulated][section] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuildCell";
    BuildCell *cell = (BuildCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    Build* build = [self getBuildForIndexPath:indexPath];
    [cell setFromBuild:build];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"toDetailsView" sender: self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Build* build = [self getBuildForIndexPath:indexPath];
    [build deleteInBackground];
    
    [self.buildCollection refresh];
    [self toggleAddBuildOverlay];
    [self.tableView reloadData];
}
                    
- (Build*)getBuildForIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionBuilds = [self.buildCollection onlyPopulated][indexPath.section];
    return sectionBuilds[indexPath.row];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetailsView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Build *build = [self getBuildForIndexPath:indexPath];
        [[segue destinationViewController] setBuild:build];
    }
}

@end