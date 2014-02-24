//
//  SemaphoreBuild.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/23/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "SemaphoreBuild.h"

@implementation SemaphoreBuild

static NSDateFormatter *dateFormatter;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
    }
}

+ (void)fetch:(NSString*)authenticationToken withCallback:(FetchBuildCallback)callbackBlock
{
    NSString *URLString = @"https://semaphoreapp.com/api/v1/projects";
    NSDictionary *parameters = @{@"auth_token": authenticationToken};
    
    NSLog(@"Fetching semaphore builds with auth token: %@", authenticationToken);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleSemaphoreResponseWith:responseObject andRespondWith:callbackBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)handleSemaphoreResponseWith:(id)responseObject andRespondWith:(FetchBuildCallback)callback
{
    NSArray *semaphoreBuilds = [SemaphoreBuild arrayFromJson:responseObject];
    NSMutableSet *savedBuilds = [NSMutableSet setWithArray: [Build saved]];
    
    // Remove saved builds
    NSArray *exclusiveBuilds = _.filter(semaphoreBuilds, ^BOOL(Build* build) {
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
        return [self fromDictionary:buildJson];
    }).unwrap;
    
    return builds;
}

+ (Build *)fromDictionary:(NSDictionary*)json
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    [dic setValue:@"SemaphoreBuild" forKey:@"type"];
    [dic setValue:json[@"project_name"] forKey:@"project"];
    [dic setValue:json[@"branch_name"] forKey:@"branch"];
    [dic setValue:json[@"result"] forKey:@"status"];
    [dic setValue:json[@"branch_status_url"] forKey:@"url"];
    [dic setValue:[self safeParseDateFrom:json withKey:@"started_at"] forKey:@"startedAt"];
    [dic setValue:[self safeParseDateFrom:json withKey:@"finished_at"] forKey:@"finishedAt"];
    
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

+ (NSDate *)safeParseDateFrom:(NSDictionary*)json withKey:(NSString*)key
{
    if (json[key] && json[key] != (id)[NSNull null]) {
        @try {
            NSDate *date = [dateFormatter dateFromString:json[key]];
            return date;
        }
        @catch (NSException *exception) {
            NSLog(@"Failed to parse %@", json[key]);
        }
    }
    
    return nil;
}

@end
