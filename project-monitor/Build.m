//
//  Build.m
//  project-monitor
//
//  Created by Dimitri Roche on 2/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Build.h"

@implementation Build

+ (void) fetchFromSemaphore:(NSString*)authenticationToken withCallback:(void (^)(NSArray *))callbackBlock
{
    NSString *URLString = @"https://semaphoreapp.com/api/v1/projects";
    NSDictionary *parameters = @{@"auth_token": authenticationToken};
    
    NSLog(@"Fetching semaphore builds with auth token: %@", authenticationToken);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self successCallback:operation with:responseObject andRespondWith:callbackBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void) successCallback:(AFHTTPRequestOperation *)operation with: (id) responseObject andRespondWith: (FetchBuildCallback) callback
{
    NSArray *array = [Build arrayFromJson:responseObject];
    dispatch_async(dispatch_get_main_queue(), ^{
        callback(array);
    });
}

+ (NSArray *)arrayFromJson:(id)json
{
    NSArray* builds = _.array(json)
    .map(^NSArray *(NSDictionary *parent) {
        return parent[@"branches"];
    })
    .flatten
    .map(^Build *(NSDictionary *buildJson) {
        return [Build fromJson:buildJson];
    }).unwrap;
    
    return builds;
}

+ (Build *) fromJson:(NSDictionary*)json
{
    Build *build = [[Build alloc] init];
    [build setProject:json[@"project_name"]];
    [build setBranch:json[@"branch_name"]];
    [build setStatus:json[@"result"]];
    [build setBranchStatusUrl:json[@"branch_status_url"]];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    
    NSDate *startedAt = [dateFormatter dateFromString:json[@"started_at"]];
    [build setStartedAt:startedAt];
    
    if (json[@"finished_at"]) {
        NSDate *finishedAt = [dateFormatter dateFromString:json[@"finished_at"]];
        [build setFinishedAt:finishedAt];
    }
    
    return build;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"Build: Project=%@ Branch=%@ Status=%@ BranchStatusUrl=%@", _project, _branch, _status, _branchStatusUrl];
}

@end
