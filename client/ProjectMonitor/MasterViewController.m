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

@interface MasterViewController ()

@property (strong, nonatomic) NSArray *semaphoreBuilds;
@property (strong, nonatomic) NSArray *travisBuilds;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self refreshBuilds];
    
    UINib *nib = [UINib nibWithNibName:@"BuildCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"BuildCell"];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleNewBuild:) name:PMBuildDidSaveNotication object:nil];
}

- (void)refreshBuilds
{
    self.semaphoreBuilds = [Build forType:@"SemaphoreBuild"];
    self.travisBuilds = [Build forType:@"TravisBuild"];
}

- (void)forceRefresh
{
    [self.refreshControl beginRefreshing];
    [self triggerRefresh:self.refreshControl];
}

- (void)handleNewBuild:(NSNotification *)notification
{
    [self forceRefresh];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (IBAction)signOut:(id)sender
{
    NSLog(@"# Signing out");
    [PFUser logOut];
    [self showLogIn];
}

- (IBAction)triggerRefresh:(id)sender
{
    UIRefreshControl *refreshControl = (UIRefreshControl*)sender;
    __weak MasterViewController *that = self;
    
    [Build refreshSavedBuildsInBackground:^(BOOL succeeded, NSArray *builds) {
        if (succeeded) {
            [that refreshBuilds];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"# Finished refresh");
                [that.tableView reloadData];
            });
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Failed to refresh"
                                        message:@"Please try again later."
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil] show];
        }
        
        [refreshControl endRefreshing];
    }];
}

- (void)clearTable
{
    self.semaphoreBuilds = [NSArray array];
    self.travisBuilds = [NSArray array];
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
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"Semaphore";
        default:
            return @"Travis";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return [self.semaphoreBuilds count];
        default:
            return [self.travisBuilds count];
    }
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
    
    [self refreshBuilds];
    [self.tableView reloadData];
}
                    
- (Build*)getBuildForIndexPath:(NSIndexPath *)indexPath
{
    Build *build;
    switch (indexPath.section) {
        case 0:
            build = [_semaphoreBuilds objectAtIndex:indexPath.row];
            break;
        case 1:
            build = [_travisBuilds objectAtIndex:indexPath.row];
            break;
        default:
            NSLog(@"Unknown section %@", [indexPath description]);
            @throw([NSException exceptionWithName:NSInternalInconsistencyException reason:@"Unknown section" userInfo: [NSDictionary dictionary]]);
    }
    
    return build;
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