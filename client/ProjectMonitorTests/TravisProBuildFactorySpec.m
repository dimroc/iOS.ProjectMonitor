//
//  TravisProBuildFactory
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/5/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Kiwi.h"
#import "TravisProBuildFactory.h"
#import "TestHelper.h"
#import "Build.h"

SPEC_BEGIN(TravisProBuildFactorySpec)

describe(@"#arrayFromResponse", ^{
    it(@"should return the correct number of builds from the expected response", ^{
        id response = [TestHelper dataFromJSONFileNamed:@"travisRepos"];
        TravisProBuildFactory* factory = [[TravisProBuildFactory alloc] initWithToken:@"gibberish"];
        NSArray *builds = [factory arrayFromResponse:response];
        
        [[theValue([builds count]) should] equal:theValue(2)];
        
        Build *build = [builds objectAtIndex:0];
        [[[build project] should] equal:@"best-org/monolithic_project"];
    });
});

describe(@"#fromDictionary", ^{
    it(@"should return a build from expected parameters", ^{
        id fixtures = [TestHelper dataFromJSONFileNamed:@"travisRepos"];
        TravisProBuildFactory* factory = [[TravisProBuildFactory alloc] initWithToken:@"MyTestToken"];
        Build *build = [factory fromDictionary: [fixtures objectAtIndex:0]];
        
        [[[build project] should] equal:@"best-org/monolithic_project"];
        [[[build status] should] equal:@"passed"];
        [[[build branch] should] beNil];
        [[[build type] should] equal:@"TravisPro"];
        [[[[build finishedAt] description] should] containString: @"2014"];
        [[[[build startedAt] description] should] containString: @"2014"];
        [[[build url] should] equal:@"https://api.travis-ci.com/repos/best-org/monolithic_project/builds?access_token=MyTestToken"];
    });
});

SPEC_END