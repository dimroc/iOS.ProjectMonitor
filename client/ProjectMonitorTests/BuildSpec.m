//
//  BuildSpec.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/13/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Kiwi.h"
#import "Build.h"

SPEC_BEGIN(BuildSpec)

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
            
            Build *build = [Build fromJson:json];
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
            
            Build *build = [Build fromJson:json];
            
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
            
            Build *build = [Build fromJson:json];
            [[[build finishedAt] should] beNil];
            [[[build startedAt] should] beNil];
        });
    });
});

describe(@"isSimilarTo:", ^{
    context(@"when similar", ^{
        it(@"should be true", ^{
            NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"TestProject", @"project_name",
                                  @"Test Branch", @"branch_name",
                                  @"pending", @"result",
                                  @"www.something.com", @"branch_status_url",
                                  nil];
            
            Build *build1 = [Build fromJson:json];
            Build *build2 = [Build MR_createEntity];
            [build2 setProject:@"TestProject"];
            [build2 setBranch:@"Test Branch"];
            [build2 setType:@"SemaphoreBuild"];
            
            [[theValue([build1 isSimilarTo:build2]) should] equal:theValue(YES)];
            [[theValue([build2 isSimilarTo:build1]) should] equal:theValue(YES)];
        });
    });
    
    context(@"when not similar", ^{
        it(@"should be false", ^{
            NSDictionary *json = [NSDictionary dictionaryWithObjectsAndKeys:
                                  @"Another Project", @"project_name",
                                  @"Test Branch", @"branch_name",
                                  @"pending", @"result",
                                  @"www.something.com", @"branch_status_url",
                                  nil];
            
            Build *build1 = [Build fromJson:json];
            Build *build2 = [Build MR_createEntity];
            [build2 setProject:@"TestProject"];
            [build2 setBranch:@"Test Branch"];
            [build2 setType:@"SemaphoreBuild"];
            
            [[theValue([build1 isSimilarTo:build2]) should] equal:theValue(NO)];
            [[theValue([build2 isSimilarTo:build1]) should] equal:theValue(NO)];
        });
    });
});

SPEC_END