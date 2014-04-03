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
#import "Credentials.h"
#import "PreferencesViewController.h"

@interface MasterViewController ()

@property (strong, nonatomic) BuildCollection *buildCollection;
@property (strong, nonatomic) UIView *addBuildOverlayView;
@property (strong, nonatomic) UINib *buildsHeaderNib;
@property (strong, nonatomic) PTPusher *pusher;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setBuildCollection:[[BuildCollection alloc] init]];
    [self.buildCollection refresh];

    UINib *nib = [UINib nibWithNibName:@"BuildCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"BuildCell"];

    // Get table header view from nib
    [self setBuildsHeaderNib: [UINib nibWithNibName:@"BuildsHeader" bundle:nil]];
    
    UINib *emptyViewNib = [UINib nibWithNibName:@"AddBuildOverlayView" bundle:nil];
    [self setAddBuildOverlayView:[emptyViewNib instantiateWithOwner:self options:nil][0]];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleNewBuild:) name:PMBuildDidSaveNotication object:nil];
    [center addObserver:self selector:@selector(handleLogOut:) name:PMUserDidLogOut object:nil];
    
//    [center addObserver:self selector:@selector(traceAllNotifications:) name:nil object:nil];
    
    [self subscribeToPusherChannel];
}

- (void)unsubscribeFromPusher
{
    if (self.pusher) {
        [self.pusher disconnect];
        [self setPusher:nil];
    }
}

- (void)subscribeToPusherChannel
{
    [self unsubscribeFromPusher];
    
    if (![PFUser currentUser]) {
        NSLog(@"# No user, unable to subscribe to pusher");
        return;
    }
    
    NSString *userId = [[PFUser currentUser] objectId];
    NSString *channelName = [NSString stringWithFormat: @"user_%@", userId];
    NSLog(@"# Subscribing to pusher channel");
    
    self.pusher = [PTPusher pusherWithKey:[Credentials objectForKey:@"PusherKey"] delegate:self encrypted:YES];
    __weak MasterViewController* that = self;
    
    // subscribe to channel and bind to event
    PTPusherChannel *channel = [self.pusher subscribeToChannelNamed:channelName];
    [channel bindToEventNamed:@"update_build" handleWithBlock:^(PTPusherEvent *channelEvent) {
        NSLog(@"# Received updated build for project %@ on branch %@ for user %@",
              [channelEvent.data objectForKey:@"project"],
              [channelEvent.data objectForKey:@"branch"],
              [channelEvent.data objectForKey:@"user"]);
        
        [Build updateSavedBuild:channelEvent.data];
        dispatch_async(dispatch_get_main_queue(), ^{
            [that.buildCollection refresh];
            [that.tableView reloadData];
        });
    }];
    
    [self.pusher connect];
}

- (void)forceRefresh
{
    [self toggleAddBuildOverlay];
    [self triggerRefresh];
}

- (void)traceAllNotifications:(NSNotification *)notification
{
    NSLog(@"# notification: %@", notification);
}

- (void)handleNewBuild:(NSNotification *)notification
{
    [self forceRefresh];
}

- (void)handleLogOut:(NSNotification *)notification
{
    [self unsubscribeFromPusher];
    [self clearTable];
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
    [self subscribeToPusherChannel];
    [self forceRefresh];
}

// Sent to the delegate when a PFUser is signed up.
- (void)signUpViewController:(PFSignUpViewController *)signUpController didSignUpUser:(PFUser *)user
{
    [super signUpViewController:signUpController didSignUpUser:user]; // Dismiss the PFSignUpViewController
    [self subscribeToPusherChannel];
    [self forceRefresh];
}

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.buildCollection onlyPopulated] count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString *title = [self.buildCollection onlyPopulatedTitles][section];
    UIView *view = [self.buildsHeaderNib instantiateWithOwner:self options:nil][0];
    UILabel *label = (UILabel*)[view viewWithTag:50];
    label.text = title;
    return view;
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