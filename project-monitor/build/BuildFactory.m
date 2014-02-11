//
//  BuildFactory.m
//  project-monitor
//
//  Created by Dimitri Roche on 2/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildFactory.h"
#import "Build.h"

@implementation BuildFactory

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

@end
