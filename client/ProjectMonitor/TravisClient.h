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

- (id)initWithToken:(NSString*)token;
- (void)retrieveTokenWithSuccess:(void (^)(NSString* token)) success failure:(void (^)(NSError *)) failure;

@end
