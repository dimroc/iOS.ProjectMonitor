//
//  GithubClient.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GithubClient : NSObject

- (id)initWithUsername:(NSString*)username andPassword:(NSString*)password;
- (void)retrieveTokensWithSuccess:(void (^)(NSString* travisToken, NSString* travisProToken)) success failure:(void (^)(NSError *)) failure;
- (NSDictionary *)parseTokens:(NSDictionary*)input;

@end
