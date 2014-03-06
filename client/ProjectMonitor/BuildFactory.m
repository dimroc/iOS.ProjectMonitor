//
//  BuildFactory.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/6/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildFactory.h"
#import "Build.h"

@implementation BuildFactory

+ (BuildFactory *)initWithToken:(NSString*)token
{
    return [[self alloc] initWithToken:token];
}

- (id)initWithToken:(NSString*)token
{
    self = [self init];
    if (self) {
        self.token = token;
    }
    
    return self;
}

- (void)fetchWithSuccess:(FetchBuildCallback)success failure:(void (^)(NSError *)) failure
{
    [NSException raise:NSInternalInconsistencyException format:@"Must be called from subclass: %@", NSStringFromSelector(_cmd)];
}

- (NSArray *)removeExistingBuilds:(NSArray *)retrievedBuilds
{
    NSMutableSet *savedBuilds = [NSMutableSet setWithArray: [Build saved]];
    
    // Remove saved builds
    NSArray *exclusiveBuilds = _.filter(retrievedBuilds, ^BOOL(Build* build) {
        NSInteger overlaps = [[savedBuilds objectsPassingTest: ^BOOL(id savedBuild, BOOL *stop) {
            return [savedBuild isSimilarTo:build];
        }] count];
        
        return overlaps == 0;
    });
    
    // Sort by project
    NSMutableArray *array = [NSMutableArray arrayWithArray:exclusiveBuilds];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 project] localizedCaseInsensitiveCompare:[obj2 project]];
    }];
    
    return array;
}

@end
