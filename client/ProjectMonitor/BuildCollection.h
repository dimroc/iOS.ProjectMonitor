//
//  BuildCollection.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Build.h"

typedef enum {
    SemaphoreBuildType = 0,
    TravisBuildType,
    TravisProBuildType
} BuildType;

@interface BuildCollection : NSObject

- (void)refreshFromCoreData;
- (void)clear;
- (NSArray*)onlyPopulated;
- (NSArray*)onlyPopulatedTitles;
- (BOOL)isEmpty;
- (Build*)find:(NSString*)objectId;

@end
