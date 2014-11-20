//
//  GithubClient.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "GithubClient.h"

@interface GithubClient ()
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *password;
@property (nonatomic, strong) NSString *token;
@end

@implementation GithubClient

- (id)initWithUsername:(NSString*)username andPassword:(NSString*)password {
    self  = [self init];
    if (self) {
        [self setUsername:username];
        [self setPassword:password];
        [self setToken:nil];
    }
    
    return self;
}

- (id)initWithUsername:(NSString*)username andPassword:(NSString*)password  andToken:(NSString *)token{
    self  = [self init];
    if (self) {
        [self setUsername:username];
        [self setPassword:password];
        [self setToken:token];
    }
    
    return self;
}

- (void)retrieveTokensWithSuccess:(void (^)(NSString* travisToken, NSString* travisProToken)) success failure:(void (^)(NSError *)) failure {
    NSLog(@"# Fetching github tokens");
    NSString *URLString = @"https://api.github.com/authorizations";

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    AFJSONRequestSerializer *serializer = [AFJSONRequestSerializer serializer];
    [serializer setValue:@"application/vnd.github.v3+json" forHTTPHeaderField:@"Accept"];
    [serializer setAuthorizationHeaderFieldWithUsername:_username password:_password];
    
    if ([_token length] != 0) {
        [serializer setValue:self.token forHTTPHeaderField:@"X-GitHub-OTP"];
    }
    
    [manager setRequestSerializer:serializer];

    [manager GET:URLString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleResponseWith:responseObject andRespondWith:success];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"# Error: %@", error);
        failure(error);
    }];
}

- (void)handleResponseWith:(id)responseObject andRespondWith:(void (^)(NSString* travisToken, NSString* travisProToken))callback
{
    NSDictionary *tokens = [self parseTokens:responseObject];
    callback(tokens[@"Travis CI"], tokens[@"Travis CI Pro"]);
}

- (NSDictionary *)parseTokens:(NSArray*)input {
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    [input bk_each:^(id obj) {
        NSDictionary *app = [obj objectForKey:@"app"];
        NSString *key = [app objectForKey:@"name"];
        NSString *token = [obj objectForKey:@"token"];
        [dic setObject:token forKey:key];
    }];

    return dic;
}

@end