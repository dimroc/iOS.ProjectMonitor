//
//  Build.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/14/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Build.h"
#import "ParseHelper.h"

@implementation Build

@dynamic project;
@dynamic branch;
@dynamic type;
@dynamic url;
@dynamic startedAt;
@dynamic finishedAt;
@dynamic updatedAt;
@dynamic status;
@dynamic objectId;

@dynamic commitSha;
@dynamic commitAuthor;
@dynamic commitEmail;
@dynamic commitMessage;

// [Name of associated class] + [Did | Will] + [UniquePartOfName] + Notification
NSString * const PMBuildDidSaveNotication = @"PMBuildDidSaveNotication";

// Thread safe: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html
static NSArray* whitelistedKeys;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        whitelistedKeys = [NSArray arrayWithObjects:
                           @"type", @"project", @"branch", @"status", @"url",
                           @"startedAt", @"finishedAt", @"commitSha", @"commitMessage",
                           @"commitAuthor", @"commitEmail", nil];
        
    }
}

+ (NSArray *)all
{
    return [Build MR_findAllSortedBy:@"project" ascending:YES];
}

+ (NSArray *)saved
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT objectId = nil"];
    return [Build MR_findAllSortedBy:@"project" ascending:YES withPredicate:predicate];
}

+ (NSArray *)allInContext:(NSManagedObjectContext *)context
{
    return [Build MR_findAllSortedBy:@"project" ascending:YES inContext:context];
}

+ (void)refreshSavedBuildsInBackground:(void (^)(BOOL, NSArray *))callback
{
    // Retrieve from parse
    PFQuery *query = [PFQuery queryWithClassName:@"Build"];
    [query orderByAscending:@"project"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            __block NSArray *refreshedBuilds;
            // Save in Core Data
            [MagicalRecord saveUsingCurrentThreadContextWithBlockAndWait:^(NSManagedObjectContext *localContext) {
                [Build MR_truncateAllInContext:localContext];
                for (PFObject *parseBuild in objects) {
                    Build *build = [Build MR_createInContext:localContext];
                    [build setFromDictionary: [ParseHelper toDictionary: parseBuild]];
                    [build setObjectId: parseBuild.objectId];
                    [build setUpdatedAt: parseBuild.updatedAt];
                }
                
                refreshedBuilds = [Build allInContext:localContext];
            }];
            
            // invoke callback with new builds
            callback(YES, refreshedBuilds);
        } else {
            NSLog(@"Failed to refresh saved builds\n%@", error);
            callback(NO, nil);
        }
    }];
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"Build: ObjectId=%@ Project=%@ Branch=%@ Status=%@ Url=%@", self.objectId, self.project, self.branch, self.status, self.url];
}

- (BOOL)isSimilarTo:(Build *)build
{
    return [[self project] isEqualToString:[build project]] &&
        [[self branch] isEqualToString: [build branch]] &&
        [[self type] isEqualToString: [build type]];
}

- (void)setFromDictionary:(NSDictionary*)dic
{
    for (NSString* key in whitelistedKeys) {
        [self setValue:dic[key] forKey:key];
    }
}

- (void)saveInBackgroundWithBlock:(void (^)(BOOL))mainThreadCallback
{
    NSLog(@"Saving project %@ with branch %@ of type %@", self.project, self.branch, self.type);
    
    PFObject *buildObject = [PFObject objectWithClassName:@"Build"];
    for (NSString* key in whitelistedKeys) {
        buildObject[key] = [self valueForKey:key];
    }
    
    buildObject[@"user"] = [PFUser currentUser];
    buildObject.ACL = [PFACL ACLWithUser:[PFUser currentUser]];
    
    [buildObject saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        [MagicalRecord saveWithBlock:^(NSManagedObjectContext *localContext) {
            if (!succeeded) {
                return;
            }
            
            Build *localBuild = [Build MR_createInContext:localContext];
            assert(localBuild != nil);
            [localBuild setFromDictionary: [ParseHelper toDictionary:buildObject]];
            localBuild.objectId = buildObject.objectId;
        }];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self notifyBuildSaved];
            mainThreadCallback(succeeded);
        });
    }];
}

- (void)notifyBuildSaved
{
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:PMBuildDidSaveNotication object:self];
}

- (void)deleteInBackground
{
    PFObject *object = [PFObject objectWithoutDataWithClassName:@"Build" objectId:[self objectId]];
    [object deleteInBackground];
    [self MR_deleteEntity];
}

@end