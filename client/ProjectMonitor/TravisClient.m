//
//  TravisClient.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "TravisClient.h"

@interface TravisClient ()
@property (nonatomic, copy) NSString *token;
@end

@implementation TravisClient

- (id)initWithToken:(NSString*)token {
    self = [self init];
    if (self) {
        [self setToken:token];
    }
    return self;
}

- (void)retrieveTokenWithSuccess:(void (^)(NSString* token)) success failure:(void (^)(NSError *)) failure {
    NSLog(@"# Fetching travis tokens with pro set to: %@", _pro ? @"true" : @"false");
    NSString *URLString = [self getUrl];
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    NSDictionary *payload = [NSDictionary dictionaryWithObject:_token forKey:@"github_token"];
    
    [manager POST:URLString parameters:payload success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleResponseWith:responseObject andRespondWith:success];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"# Error: %@", error);
        failure(error);
    }];
}

- (void)handleResponseWith:(id)responseObject andRespondWith:(void (^)(NSString* token))callback
{
    callback(responseObject[@"access_token"]);
}

- (NSString *)getUrl {
    if (_pro) {
        return @"https://api.travis-ci.com/auth/github";
    } else {
        return @"https://api.travis-ci.org/auth/github";
    }
}

@end