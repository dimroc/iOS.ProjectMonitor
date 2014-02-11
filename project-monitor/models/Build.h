//
//  Build.h
//  project-monitor
//
//  Created by Dimitri Roche on 2/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Build : NSObject

+ (NSArray *)arrayFromJson:(id)json;
+ (Build *) fromJson:(NSDictionary*)json;

@property (nonatomic, strong) NSString* project;
@property (nonatomic, strong) NSString* branch;
@property (nonatomic, strong) NSString* status;
@property (nonatomic, strong) NSString* branchStatusUrl;

- (NSString *)description;

@end
