//
//  SemaphoreBuild.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/23/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SemaphoreBuildFactory.h"
#import "Build.h"
#import "Helper.h"

@implementation SemaphoreBuildFactory : BuildFactory

- (void)fetchWithSuccess:(FetchBuildCallback)success failure:(void (^)(NSError *))failure
{
    NSString *URLString = @"https://semaphoreapp.com/api/v1/projects";
    NSDictionary *parameters = @{@"auth_token": [self token]};
    
    NSLog(@"# Fetching semaphore builds with auth token: %@", [self token]);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleResponseWith:responseObject andRespondWith:success];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"# Error: %@", error);
        dispatch_async(dispatch_get_main_queue(), ^{
            failure(error);
        });
    }];
}

- (void)handleResponseWith:(id)responseObject andRespondWith:(FetchBuildCallback)callback
{
    NSArray *semaphoreBuilds = [self arrayFromJson:responseObject];
    NSArray *array = [self removeExistingBuilds:semaphoreBuilds];
    dispatch_async(dispatch_get_main_queue(), ^{
        callback(array);
    });
}


- (NSArray *)arrayFromJson:(id)json
{
    NSArray* builds = _.array(json)
    .map(^NSArray *(NSDictionary *parent) {
        return parent[@"branches"];
    })
    .flatten
    .map(^Build *(NSDictionary *buildJson) {
        return [self fromDictionary:buildJson];
    }).unwrap;
    
    return builds;
}

- (Build *)fromDictionary:(NSDictionary*)json
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@"Semaphore" forKey:@"type"];
    [dic setValue:[self token] forKey:@"accessToken"];
    
    [dic setValue:json[@"project_name"] forKey:@"project"];
    [dic setValue:json[@"branch_name"] forKey:@"branch"];
    [dic setValue:json[@"result"] forKey:@"status"];
    [dic setValue:json[@"branch_status_url"] forKey:@"url"];

    [dic setValue:[Helper parseDateSafelyFromDictionary:json withKey:@"started_at"] forKey:@"startedAt"];
    [dic setValue:[Helper parseDateSafelyFromDictionary:json withKey:@"finished_at"] forKey:@"finishedAt"];
    
    // Load commit info
    NSDictionary *commitInfo = json[@"commit"];
    [dic setValue:commitInfo[@"id"] forKey:@"commitSha"];
    [dic setValue:commitInfo[@"author_name"] forKey:@"commitAuthor"];
    [dic setValue:commitInfo[@"author_email"] forKey:@"commitEmail"];
    [dic setValue:commitInfo[@"message"] forKey:@"commitMessage"];
    
    Build *build = [Build MR_createEntity];
    [build setFromDictionary: dic];
    return build;
}

@end
