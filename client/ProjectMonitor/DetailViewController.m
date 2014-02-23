//
//  DetailViewController.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 1/29/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "DetailViewController.h"
#import "Build.h"

@interface DetailViewController ()
@property NSDateFormatter *dateFormatter;
- (void)configureView;
@end

@implementation DetailViewController

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    self.dateFormatter = [[NSDateFormatter alloc] init];
    [self.dateFormatter setDateFormat:@"MMM dd, yyyy h:mm a"];
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
            [self.dateFormatter stringFromDate:[self.build valueForKey:@"finishedAt"]];
      }

      self.statusLabel.text = [[self.build valueForKey:@"status"] description];
      NSString *shortType = [[self.build valueForKey:@"type"] stringByReplacingOccurrencesOfString:@"Build" withString:@""];
      self.typeLabel.text = shortType;
      self.lastPollLabel.text = [self.dateFormatter stringFromDate:[self.build valueForKey:@"updatedAt"]];
      
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
	// Do any additional setup after loading the view, typically from a nib.
  [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
