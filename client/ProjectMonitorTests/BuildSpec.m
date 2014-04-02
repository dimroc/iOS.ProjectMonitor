//
//  BuildSpec.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/13/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Kiwi.h"
#import "Build.h"
#import "TestHelper.h"

SPEC_BEGIN(BuildSpec)

describe(@"isSimilarTo:", ^{
    context(@"when similar", ^{
        it(@"should be true", ^{
            Build *build1 = [Build MR_createEntity];
            [build1 setProject:@"TestProject"];
            [build1 setUrl:@"http://test"];
            [build1 setType:@"Semaphore"];
            [build1 setCommitAuthor:@"DoesntMatter"];

            Build *build2 = [Build MR_createEntity];
            [build2 setProject:@"TestProject"];
            [build2 setUrl:@"http://test"];
            [build2 setType:@"Semaphore"];
            
            [[theValue([build1 isSimilarTo:build2]) should] equal:theValue(YES)];
            [[theValue([build2 isSimilarTo:build1]) should] equal:theValue(YES)];
        });
    });
    
    context(@"when not similar", ^{
        it(@"should be false", ^{
            Build *build1 = [Build MR_createEntity];
            [build1 setProject:@"Another Project"];
            [build1 setType:@"Semaphore"];
            
            Build *build2 = [Build MR_createEntity];
            [build2 setProject:@"TestProject"];
            [build2 setUrl:@"http://iexist"];
            [build2 setType:@"Semaphore"];
            
            [[theValue([build1 isSimilarTo:build2]) should] equal:theValue(NO)];
            [[theValue([build2 isSimilarTo:build1]) should] equal:theValue(NO)];
        });
    });
});

describe(@"updateSavedBuild:", ^{
    beforeEach(^{
        [Build MR_truncateAll];
        // Force the default context to persist to the data store
        // to prevent annoying race conditions with core data.
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    });
    
    afterEach(^{
        [Build MR_truncateAll];
        [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
    });

    context(@"when the build already exists", ^{
        it(@"should update the build", ^{
            [[theValue([[Build MR_findAll] count]) should] equal: theValue(0)];

            Build *original = [Build MR_createEntity];
            [original setProject:@"rubbish project"];
            [original setObjectId:@"PusherPayloadObjectId"];
            [original setProject:@"Project To Be Overridden"];
            [original setStatus:@"passed"];
            [original setType:@"Semaphore"];
            [original setUrl:@"http://someurl"];
            [original setUpdatedAt:[NSDate date]];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            [[theValue([[Build MR_findAll] count]) should] equal: theValue(1)];
            
            id response = [TestHelper dataFromJSONFileNamed:@"pusherPayload"];
            [Build updateSavedBuild:response];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

            NSArray* finalBuilds = [Build MR_findAll];
            [[theValue([finalBuilds count]) should] equal: theValue(1)];
            
            Build *final = finalBuilds[0];
            [[final.project should] equal:@"bulk_update"];
        });
    });
    
    context(@"when the build does not exist", ^{
        it(@"should create the build", ^{
            [Build MR_truncateAll];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];

            id response = [TestHelper dataFromJSONFileNamed:@"pusherPayload"];
            [Build updateSavedBuild:response];
            [[NSManagedObjectContext MR_defaultContext] MR_saveToPersistentStoreAndWait];
            
            Build* final = [Build MR_findFirstByAttribute:@"objectId" withValue:@"PusherPayloadObjectId"];
            [[final.project should] equal:@"bulk_update"];
        });
    });
});

SPEC_END