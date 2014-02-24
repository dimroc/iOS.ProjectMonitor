//
//  SemaphoreBuildSpec.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/23/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Kiwi.h"
#import "SemaphoreBuild.h"

SPEC_BEGIN(SemaphoreBuildSpec)

describe(@".fromJson", ^{
    context(@"with started_at and finished_at null", ^{
        specify(^{
            NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"TestProject", @"project_name",
                                  @"Test Branch", @"branch_name",
                                  @"pending", @"result",
                                  @"www.something.com", @"branch_status_url",
                                  [NSNull null], @"started_at",
                                  [NSNull null], @"finished_at",
                                  nil];
            
            Build *build = [SemaphoreBuild fromDictionary:json];
            [[[build finishedAt] should] beNil];
            [[[build startedAt] should] beNil];
        });
    });
    
    context(@"with started_at and finished_at set to a valid value", ^{
        specify(^{
            NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"TestProject", @"project_name",
                                  @"Test Branch", @"branch_name",
                                  @"pending", @"result",
                                  @"www.something.com", @"branch_status_url",
                                  @"2014-02-07T23:21:42Z", @"started_at",
                                  @"2014-02-07T23:40:00Z", @"finished_at",
                                  nil];
            
            Build *build = [SemaphoreBuild fromDictionary:json];
            
            [[[[build finishedAt] description] should] containString: @"2014"];
            [[[[build startedAt] description] should] containString: @"2014"];
        });
    });
    
    context(@"with finished_at and started_at set to an invalid value", ^{
        specify(^{
            NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"TestProject", @"project_name",
                                  @"Test Branch", @"branch_name",
                                  @"pending", @"result",
                                  @"www.something.com", @"branch_status_url",
                                  @"gibberish", @"started_at",
                                  @"fdsa", @"finished_at",
                                  nil];
            
            Build *build = [SemaphoreBuild fromDictionary:json];
            [[[build finishedAt] should] beNil];
            [[[build startedAt] should] beNil];
        });
    });
});

SPEC_END