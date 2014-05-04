//
//  DetailViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 1/29/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "DetailViewController.h"
#import "Build.h"
#import "Helper.h"

@interface DetailViewController ()
- (void)configureView;
@end

@implementation DetailViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    return self;
}

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newBuild
{
    if (_build != newBuild) {
        _build = newBuild;
        
        // Update the view.
        [self configureView];
    }        
}

- (void)configureView
{
    // Update the user interface for the detail item.

  if (self.build) {
      self.nagivationItem.title = [self.build project];
      self.branchLabel.text = [[self.build valueForKey:@"branch"] description];
      
      if ([self.build finishedAt]) {
          self.finishedAtLabel.text =
            [Helper stringFromDate:[self.build valueForKey:@"finishedAt"]];
      } else {
          self.finishedAtLabel.text = @"";
      }

      self.statusLabel.text = [[self.build valueForKey:@"status"] description];
      NSString *shortType = [[self.build valueForKey:@"type"] stringByReplacingOccurrencesOfString:@"Build" withString:@""];
      self.typeLabel.text = shortType;
      self.lastPollLabel.text = [Helper stringFromDate:[self.build valueForKey:@"updatedAt"]];
      
      self.authorLabel.text = [self.build commitAuthor];
      self.emailLabel.text = [self.build commitEmail];
      self.shaLabel.text = [self.build commitSha];
      self.messageLabel.text = [self.build commitMessage];
      [self.messageLabel sizeToFit];
  }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self configureView];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return nil;
}

@end
