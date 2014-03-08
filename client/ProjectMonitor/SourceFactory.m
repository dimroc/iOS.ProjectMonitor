//
//  SourceFactory.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SourceFactory.h"
#import "SourceViewController.h"
#import "BuildFactory.h"

@implementation SourceFactory

+ (id<Source>)fetch:(NSString*)name
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Source" bundle:nil];
    id<Source> source = (id<Source>)[storyboard instantiateInitialViewController];
    BuildFactory *buildFactory = [self buildFactoryFromName:name];
    [source setBuildFactory:buildFactory];
    
    return (id<Source>)source;
}

+ (BuildFactory*)buildFactoryFromName:(NSString*)name
{
    NSString *prefix = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [NSClassFromString([NSString stringWithFormat:@"%@BuildFactory", prefix]) alloc];
}

@end
