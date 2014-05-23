//
//  TravisClient.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "TravisClient.h"

@interface TravisClient ()
@end

@implementation TravisClient

- (void)retrieveTokenWithGithubToken:(NSString*) token success:(void (^)(NSString* token)) success failure:(void (^)(NSError *)) failure {
    NSLog(@"# Fetching travis tokens with pro set to: %@", _pro ? @"true" : @"false");
    NSString *URLString = [self getGithubAuthorizationUrl];
    AFHTTPRequestOperationManager* manager = [self getHTTPManager];
    NSDictionary *payload = [NSDictionary dictionaryWithObject:token forKey:@"github_token"];
    
    [manager POST:URLString parameters:payload success:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(responseObject[@"access_token"]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"# Error: %@", error);
        failure(error);
    }];
}

- (void)retrieveBuildsWithToken: (NSString*) token andMember: (NSString*) member success:(void (^)(id response)) success failure:(void (^)(NSError *)) failure {
    NSLog(@"# Fetching travis builds with access token: %@", token);
    AFHTTPRequestOperationManager* manager = [self getHTTPManager];
    
    [manager GET:[self getRepoUrl] parameters:[self getParametersWithToken:token andMember:member] success:
     ^(AFHTTPRequestOperation *operation, id responseObject) {
         NSDictionary* dictionary = (NSDictionary*)responseObject;
         success(dictionary[@"repos"]);
     } failure: ^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"# Error: %@", error);
         failure(error);
     }];
}

- (NSString *)getGithubAuthorizationUrl {
    return [NSString stringWithFormat: @"%@auth/github", [self getBaseUrl]];
}

- (NSString*)getRepoUrl
{
    return [NSString stringWithFormat:@"%@/repos", [self getBaseUrl]];
}

- (NSString *)getBaseUrl {
    if (_pro) {
        return @"https://api.travis-ci.com/";
    } else {
        return @"https://api.travis-ci.org/";
    }
}


- (NSDictionary*)getParametersWithToken:(NSString*) token andMember:(NSString*)member {
    return @{@"access_token": token, @"member": member};
}

- (AFHTTPRequestOperationManager*) getHTTPManager {
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/vnd.travis-ci.2+json" forHTTPHeaderField:@"Accept"];
    [serializer setValue:@"iOSProjectMonitor/1.0" forHTTPHeaderField:@"User-Agent"];
    [manager setRequestSerializer:serializer];
    [manager setResponseSerializer: [AFJSONResponseSerializer serializer]];

    return manager;
}

@end