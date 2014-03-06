//
//  SemaphoreBuild.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/23/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildFactory.h"
@class Build;

@interface SemaphoreBuildFactory : BuildFactory

- (Build *)fromDictionary:(NSDictionary*)json;

@end
