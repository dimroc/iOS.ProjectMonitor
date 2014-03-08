//
//  PublicTravisBuildFactory.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "PublicTravisBuildFactory.h"

@implementation PublicTravisBuildFactory

- (NSString*)getTravisBuildType
{
    return @"PublicTravisBuild";
}

- (NSString*)baseUrl
{
    return @"https://api.travis-ci.org";
}

@end