//
//  BuildFactory.m
//  project-monitor
//
//  Created by Dimitri Roche on 2/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildFactory.h"

@implementation BuildFactory

+ (void) fetchFromSemaphore:(NSString*)authenticationToken withCallback:(void (^)(NSArray *))callbackBlock
{
    NSLog(@"Fetching semaphore builds with auth token: %@", authenticationToken);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);

    dispatch_async(queue, ^{
        NSArray* array = [self fetchFromSemaphoreHttp:authenticationToken];
        callbackBlock(array);
    });
}

+ (NSArray*) fetchFromSemaphoreHttp:(NSString*)authenticationToken
{
    NSArray* array = [NSArray arrayWithObject: @"test"];
    return array;
}

@end
