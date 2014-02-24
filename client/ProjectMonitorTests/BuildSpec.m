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

describe(@"isSimilarTo:", ^{
    context(@"when similar", ^{
        it(@"should be true", ^{
            Build *build1 = [Build MR_createEntity];
            [build1 setProject:@"TestProject"];
            [build1 setBranch:@"Test Branch"];
            [build1 setType:@"SemaphoreBuild"];
            [build1 setCommitAuthor:@"DoesntMatter"];

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
            Build *build1 = [Build MR_createEntity];
            [build1 setProject:@"Another Project"];
            [build1 setBranch:@"Test Branch"];
            [build1 setType:@"SemaphoreBuild"];
            
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