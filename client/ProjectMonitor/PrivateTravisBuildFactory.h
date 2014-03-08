//
//  TravisBuild.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/5/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildFactory.h"
@class Build;

@interface PrivateTravisBuildFactory : BuildFactory

// Public just for testing. Don't judge me.
- (NSArray *)arrayFromResponse:(NSDictionary *)response;
- (Build *)fromDictionary:(NSDictionary *)dictionary;

@end
