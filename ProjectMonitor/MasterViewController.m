//
//  MasterViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 1/29/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "MasterViewController.h"
#import "DetailViewController.h"
#import "Build.h"
#import "BuildCell.h"

@interface MasterViewController ()

@property (strong, nonatomic) NSArray *builds;

@end

@implementation MasterViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.detailViewController = (DetailViewController *)[[self.splitViewController.viewControllers lastObject] topViewController];
    self.builds = [Build all];
    
    UINib *nib = [UINib nibWithNibName:@"BuildCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"BuildCell"];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center addObserver:self selector:@selector(handleNewBuild:) name:PMBuildDidSaveNotication object:nil];
    
    [self forceRefresh];
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
    NSLog(@"Signing out");
    [PFUser logOut];
    [self showLogIn];
}

- (IBAction)triggerRefresh:(id)sender
{
    NSLog(@"triggered a refresh");
    UIRefreshControl *refreshControl = (UIRefreshControl*)sender;
    __weak MasterViewController *that = self;
    
    [Build refreshSavedBuildsInBackground:^(BOOL succeeded, NSArray *builds) {
        if (succeeded) {
            [that setBuilds:builds];
            dispatch_async(dispatch_get_main_queue(), ^{
                NSLog(@"Finished refresh");
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

#pragma mark - Table View

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.builds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuildCell";
    BuildCell *cell = (BuildCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Build *build = [_builds objectAtIndex:indexPath.row];
    [cell setFromBuild:build];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier: @"toDetailsView" sender: self];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    Build *build = [self.builds objectAtIndex:indexPath.row];
    [build deleteInBackground];
    NSMutableArray *mutableCopy = [NSMutableArray arrayWithArray:self.builds];
    [mutableCopy removeObjectAtIndex:indexPath.row];
    [self setBuilds: [NSArray arrayWithArray:mutableCopy]];
    [self.tableView reloadData];
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"toDetailsView"]) {
        NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
        Build *build = [[self builds] objectAtIndex:indexPath.row];
        [[segue destinationViewController] setBuild:build];
    }
}

@end