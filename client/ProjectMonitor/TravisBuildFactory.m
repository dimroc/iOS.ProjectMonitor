//
//  TravisBuildFactory.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "TravisBuildFactory.h"
#import "Helper.h"
#import "Build.h"
#import "TravisClient.h"

@interface TravisBuildFactory ()
@end

@implementation TravisBuildFactory

- (id)initWithToken:(NSString *)token andUsername:(NSString*)username {
    self = [super initWithToken:token];
    if (self) {
        [self setUsername:username];
    }
    
    return self;
}

- (void)fetchWithSuccess:(FetchBuildCallback)success failure:(void (^)(NSError *)) failure
{
    TravisClient* client = [[TravisClient alloc] init];
    [client setPro:[self pro]];
    [client retrieveBuildsWithToken:[self token] andMember:_username success:^(id response) {
        [self handleResponseWith:response andRespondWith:success];
    } failure:^(NSError * error) {
        failure(error);
    }];
}

- (void)handleResponseWith:(id)responseObject andRespondWith:(FetchBuildCallback)callback
{
    NSArray *travisBuilds = [self arrayFromResponse:responseObject];
    NSArray* array = [self removeExistingBuilds:travisBuilds];
    dispatch_async(dispatch_get_main_queue(), ^{
        callback(array);
    });
}

- (NSArray *)arrayFromResponse:(NSArray *)response
{
    NSArray* builds = _.arrayMap(response, ^Build* (NSDictionary *entry) {
        return [self fromDictionary:entry];
    });
    
    return builds;
}

- (Build *)fromDictionary:(NSDictionary *)input
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:[self getTravisBuildType] forKey:@"type"];
    [dic setValue:input[@"slug"] forKey:@"project"];
    
    [dic setValue:input[@"last_build_state"] forKey:@"status"];
    
    [dic setValue:[self token] forKey:@"accessToken"];
    [dic setValue:[self generateUrlWithProject:input[@"slug"]] forKey:@"url"];
    
    [dic setValue:[Helper parseDateSafelyFromDictionary:input withKey:@"last_build_started_at"] forKey:@"startedAt"];
    [dic setValue:[Helper parseDateSafelyFromDictionary:input withKey:@"last_build_finished_at"] forKey:@"finishedAt"];
    
    Build *build = [Build MR_createEntity];
    [build setFromDictionary: dic];
    return build;
}

- (NSString *)generateUrlWithProject:(NSString*) project
{
    return [NSString stringWithFormat:@"%@/repos/%@/builds?access_token=%@", [self baseUrl], project, [self token]];
}

- (NSString*)getTravisBuildType
{
    return @"Travis";
}

- (NSString*)baseUrl
{
    return @"https://api.travis-ci.org";
}

- (BOOL) pro
{
    return false;
}

@end