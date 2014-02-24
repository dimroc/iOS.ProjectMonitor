//
//  SemaphoreBuild.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/23/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Build.h"

@interface SemaphoreBuild : Build

+ (void)fetch:(NSString*)authenticationToken withCallback:(FetchBuildCallback)callbackBlock;
+ (Build *)fromDictionary:(NSDictionary*)json;

@end
