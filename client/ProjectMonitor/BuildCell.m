//
//  BuildCell.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/11/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildCell.h"
#import "Build.h"
#import "Helper.h"

@interface BuildCell ()

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
    [self setSelectionStyle:UITableViewCellSelectionStyleNone];
}

- (void)setFromBuild:(Build *)build
{
    [self setBuild:build];
    self.projectLabel.text = self.build.project;
    self.branchLabel.text = self.build.branch;
    self.timeLabel.text = [Helper stringFromDate: self.build.startedAt];
    self.statusImageView.image = [self imageForStatus];
}

- (BOOL)toggleChecked
{
    if (self.accessoryType == UITableViewCellAccessoryCheckmark) {
        // Already checked
        [self toggleDetails: false];
        self.accessoryType = UITableViewCellAccessoryNone;
        return NO;
    } else {
        [self toggleDetails: true];
        self.accessoryType = UITableViewCellAccessoryCheckmark;
        return YES;
    }
}

- (void)toggleDetails:(BOOL)hidden
{
    if (hidden) {
        self.timeLabel.hidden = true;
        self.statusImageView.hidden = true;
    } else {
        self.timeLabel.hidden = false;
        self.statusImageView.hidden = false;
    }
}

- (UIImage*)imageForStatus
{
    NSString * imageName = [self.build status] ? [self.build status] : @"undetermined";
    imageName = [NSString stringWithFormat:@"icon-%@",[self.build status]];
    UIImage *image = [UIImage imageNamed: imageName];
    if (image) {
        return image;
    } else {
        NSLog(@"# Unable to load build image for status %@.", [self.build status]);
        return [UIImage imageNamed: @"icon-undetermined"];
    }
}

@end