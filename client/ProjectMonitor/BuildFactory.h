//
//  BuildFactory.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/6/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BuildFactory : NSObject

typedef void (^FetchBuildCallback)(NSArray *);

@property (nonatomic, copy) NSString *token;

+ (BuildFactory *)initWithToken:(NSString*)token;
- (id)initWithToken:(NSString*)token;

- (NSArray *)removeExistingBuilds:(NSArray *)existingBuilds;

# pragma mark Abstract methods

- (void)fetchWithSuccess:(FetchBuildCallback)success failure:(void (^)(NSError *)) failure;

@end