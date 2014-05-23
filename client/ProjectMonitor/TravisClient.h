//
//  TravisClient.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TravisClient : NSObject

@property (nonatomic, assign) BOOL pro;

- (void)retrieveTokenWithGithubToken:(NSString*) token success:(void (^)(NSString* token)) success failure:(void (^)(NSError *)) failure;

- (void)retrieveBuildsWithToken: (NSString*) token andMember: (NSString*) member success:(void (^)(id response)) success failure:(void (^)(NSError *)) failure;

@end
