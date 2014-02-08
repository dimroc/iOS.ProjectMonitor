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

static NSArray* sources;
+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        sources = [[NSArray alloc] initWithObjects:
                   [[SemaphoreSourceViewController alloc] init],
                   nil
        ];
    }
}

+ (NSArray*) sources
{
    return sources.copy;
}

@end