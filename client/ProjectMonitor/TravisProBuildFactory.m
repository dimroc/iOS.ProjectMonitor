//
//  TravisProBuildFactory
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/5/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "TravisProBuildFactory.h"

@interface TravisProBuildFactory ()

@end

@implementation TravisProBuildFactory

- (NSString*)getTravisBuildType
{
    return @"PrivateTravis";
}

- (NSString*)baseUrl
{
    return @"https://api.travis-ci.com";
}

@end
