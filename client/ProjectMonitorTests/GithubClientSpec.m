//
//  GithubClientSpec.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/5/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Kiwi.h"
#import "GithubClient.h"
#import "TestHelper.h"

SPEC_BEGIN(GithubClientSpec)

describe(@"#parseTokens", ^{
    it(@"should return all tokens", ^{
        id response = [TestHelper dataFromJSONFileNamed:@"githubAuthorizations"];
        
        GithubClient *client = [[GithubClient alloc] init];
        NSDictionary *tokens = [client parseTokens:response];
        
        [[[[tokens objectForKey:@"Travis CI"] description] should] equal:@"tokenfortravis"];
        [[[[tokens objectForKey:@"Travis CI Pro"] description] should] equal:@"tokenfortravispro"];
        [[[[tokens objectForKey:@"gittip"]description] should] equal:@"tokenforgittip"];
    });
});

SPEC_END