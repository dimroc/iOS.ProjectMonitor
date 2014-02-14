//
//  SemaphoreBuildsViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SemaphoreBuildsViewController.h"
#import "Build.h"
#import "BuildCell.h"

@interface SemaphoreBuildsViewController ()

@property (nonatomic, copy) NSArray* builds;

@end

@implementation SemaphoreBuildsViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setBuilds:[NSArray array]];
    }

    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadWithToken:(NSString*) authenticationToken
{
    [Build fetchFromSemaphore: authenticationToken withCallback: ^(NSArray* builds){
        [self handleBuilds:builds];
    }];
}

- (void) handleBuilds:(NSArray *)builds
{
    [self setBuilds:builds];
    [self.tableView reloadData];
    [MBProgressHUD hideHUDForView:self.view animated:YES];
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BuildCell *cell = (BuildCell*)[tableView cellForRowAtIndexPath:indexPath];
    Build *build = [cell build];
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    [build saveInBackgroundWithBlock:^(BOOL succeeded) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (succeeded) {
            NSLog(@"Successfully added build.");
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
