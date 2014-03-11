//
//  AddBuildViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "AddBuildViewController.h"
#import "SourceFactory.h"
#import "Source.h"

@interface AddBuildViewController ()

@end

@implementation AddBuildViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - Table view data source

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    NSString *source_name = cell.textLabel.text;
    
    NSLog(@"# Selected %@", source_name);
    id source = [SourceFactory fetch:source_name];

    [[self navigationController] pushViewController:source animated:YES];
}

@end
