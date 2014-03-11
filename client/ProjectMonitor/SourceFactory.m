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
#import "TravisSourceViewController.h"

@implementation SourceFactory

+ (id<Source>)fetch:(NSString*)name
{
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[self storyboardNameFromName:name] bundle:nil];
    id<Source> source = (id<Source>)[storyboard instantiateInitialViewController];
    [self configureSourceViewController: source FromName:name];
    BuildFactory *buildFactory = [self buildFactoryFromName:name];
    [source setBuildFactory:buildFactory];
    
    return (id<Source>)source;
}

+ (NSString *)storyboardNameFromName:(NSString*)name
{
    NSString *string = [name stringByReplacingOccurrencesOfString:@"Private " withString:@""];
    return [string stringByReplacingOccurrencesOfString:@"Public " withString:@""];
}

+ (void)configureSourceViewController: (id<Source>)source FromName:(NSString*) name {
    if ([name isEqualToString:@"Private Travis"]) {
        [(TravisSourceViewController*)source setPro:true];
    }
}

+ (BuildFactory*)buildFactoryFromName:(NSString*)name
{
    NSString *prefix = [name stringByReplacingOccurrencesOfString:@" " withString:@""];
    return [NSClassFromString([NSString stringWithFormat:@"%@BuildFactory", prefix]) alloc];
}

@end
