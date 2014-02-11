//
//  SourceFactory.m
//  project-monitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SourceFactory.h"
#import "SemaphoreSourceViewController.h"

@implementation SourceFactory

+ (id<Source>)fetch:(NSString*)name
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:name bundle:nil];
    UIViewController *source = [storyboard instantiateInitialViewController];
    return (id<Source>)source;
}

@end