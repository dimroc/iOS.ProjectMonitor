//
//  BuildCell.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/11/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildCell.h"
#import "Build.h"

@interface BuildCell ()

@property (weak, nonatomic) Build *build;

@end

@implementation BuildCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFromBuild:(Build *)build
{
    [self setBuild:build];
    self.projectLabel.text = self.build.project;
    self.branchLabel.text = self.build.branch;
    self.timeLabel.text = self.build.startedAt.description;
    self.statusImageView.image = [self imageForStatus];
}

- (UIImage*)imageForStatus
{
    if ([[self.build status] isEqual: @"passed"]) {
        return [UIImage imageNamed:@"icon-ok"];
    }
    else if ([[self.build status] isEqualToString: @"failed"]) {
        return [UIImage imageNamed:@"icon-fail"];
    }
    else if ([[self.build status] isEqualToString: @"pending"]) {
        return [UIImage imageNamed:@"icon-undetermined-changing"];
    }
    else {
        return [UIImage imageNamed:@"icon-undetermined"];
    }
}

@end
