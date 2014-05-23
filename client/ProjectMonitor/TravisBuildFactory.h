//
//  TravisBuildFactory.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildFactory.h"
@class Build;

@interface TravisBuildFactory : BuildFactory

@property (nonatomic, strong) NSString* username;

- (id)initWithToken:(NSString *)token andUsername:(NSString*)username;
- (NSArray *)arrayFromResponse:(NSArray *)response;
- (Build *)fromDictionary:(NSDictionary *)dictionary;

@end
