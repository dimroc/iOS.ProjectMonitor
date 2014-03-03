//
//  SemaphoreBuildsViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SemaphoreBuildsViewController.h"
#import "SemaphoreBuild.h"
#import "BuildCell.h"
#import "BlockAlertViewDelegate.h"

@interface SemaphoreBuildsViewController ()

@property (nonatomic, copy) NSArray* builds;
@property (nonatomic, copy) NSArray* selectedBuilds;

@end

@implementation SemaphoreBuildsViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBuilds:[NSArray array]];
        [self setSelectedBuilds:[NSArray array]];
    }

    return self;
}

- (IBAction)addSelectedBuildsAction:(id)sender;
{
    if ([self.selectedBuilds count] == 0) {
        [self showPleaseSelectBuildsMessage];
    } else {
        [self saveSelectedBuilds];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    UINib *nib = [UINib nibWithNibName:@"BuildCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"BuildCell"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadWithToken:(NSString*) authenticationToken
{
    [SemaphoreBuild fetch: authenticationToken success: ^(NSArray* builds){
        [self populateWithBuilds:builds];
    } failure: ^(NSError *error) {
        [self showErrorMessage:error];
    }];
}

- (void) populateWithBuilds:(NSArray *)builds
{
    [self setBuilds:builds];
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];

    if ([self.builds count] == 0) {
        [self showNoBuildsMessage];
    }
}

- (void)showPleaseSelectBuildsMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"No builds to add"
                              message:@"Please select builds to add."
                              delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil];
    [alertView show];
}

- (void)showNoBuildsMessage
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"No builds to add"
                              message:@"There are no builds to add."
                              delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil];
    
    [BlockAlertViewDelegate showAlertView:alertView withCallback:^(NSInteger buttonIndex) {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }];
}

- (void)showErrorMessage: (NSError *)error
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle: @"Error retrieving builds"
                              message: [error localizedDescription]
                              delegate: nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil];
    
    [BlockAlertViewDelegate showAlertView:alertView withCallback:^(NSInteger buttonIndex) {
        [self.navigationController popViewControllerAnimated:YES];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_builds count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"BuildCell";
    BuildCell *cell = (BuildCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    Build *build = [_builds objectAtIndex:indexPath.row];
    [cell setFromBuild:build];
    
    return cell;
}

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    BuildCell * buildCell = (BuildCell*)[tableView cellForRowAtIndexPath:indexPath];
    BOOL selected = [buildCell toggleChecked];
    
    NSMutableSet *newSelectedBuilds = [NSMutableSet setWithArray:[self selectedBuilds]];
    
    if (selected) {
        [newSelectedBuilds addObject: [buildCell build]];
    } else {
        [newSelectedBuilds removeObject: [buildCell build]];
    }

    [self setSelectedBuilds: [newSelectedBuilds allObjects]];
}

- (void)saveSelectedBuilds
{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [Build saveInBackground: [self selectedBuilds] withBlock:^(BOOL succeeded) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeeded) {
            NSLog(@"# Successfully added builds.");
        } else {
            [[[UIAlertView alloc] initWithTitle:@"Unable to talk to server"
                                        message:@"Please try again when data is available."
                                       delegate:nil
                              cancelButtonTitle:@"ok"
                              otherButtonTitles:nil] show];
        }
        
        [self.navigationController popToRootViewControllerAnimated:TRUE];
    }];
}

@end
