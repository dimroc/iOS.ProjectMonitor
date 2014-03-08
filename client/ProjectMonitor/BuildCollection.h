//
//  BuildCollection.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    SemaphoreBuildType = 0,
    PrivateTravisBuildType,
    PublicTravisBuildType
} BuildType;

@interface BuildCollection : NSObject

- (void)refresh;
- (void)clear;
- (NSArray*)onlyPopulated;
- (NSArray*)onlyPopulatedTitles;

@end
