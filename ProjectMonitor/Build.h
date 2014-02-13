//
//  Build.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchBuildCallback)(NSArray *);

@interface Build : NSObject

+ (void) fetchFromSemaphore:(NSString*)authenticationToken withCallback:(FetchBuildCallback)callbackBlock;
+ (NSArray *)arrayFromJson:(id)json;
+ (Build *) fromJson:(NSDictionary*)json;

@property (nonatomic, strong) NSString* project;
@property (nonatomic, strong) NSString* branch;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* branchStatusUrl;
@property (nonatomic, strong) NSDate* startedAt;
@property (nonatomic, strong) NSDate* finishedAt;

- (NSString *)description;

@end
