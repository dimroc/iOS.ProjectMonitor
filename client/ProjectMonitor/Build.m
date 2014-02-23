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
static NSDateFormatter *dateFormatter;

// Thread safe: https://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/Multithreading/ThreadSafetySummary/ThreadSafetySummary.html
static NSArray* whitelistedKeys;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
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

+ (void)fetchFromSemaphore:(NSString*)authenticationToken withCallback:(void (^)(NSArray *))callbackBlock
{
    NSString *URLString = @"https://semaphoreapp.com/api/v1/projects";
    NSDictionary *parameters = @{@"auth_token": authenticationToken};
    
    NSLog(@"Fetching semaphore builds with auth token: %@", authenticationToken);
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:URLString parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleSemaphoreResponseWith:responseObject andRespondWith:callbackBlock];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

+ (void)handleSemaphoreResponseWith:(id)responseObject andRespondWith:(FetchBuildCallback)callback
{
    NSArray *semaphoreBuilds = [Build arrayFromJson:responseObject];
    NSMutableSet *savedBuilds = [NSMutableSet setWithArray: [Build saved]];
    
    // Remove saved builds
    NSArray *exclusiveBuilds = _.filter(semaphoreBuilds, ^BOOL(Build* build) {
        NSInteger overlaps = [[savedBuilds objectsPassingTest: ^BOOL(id savedBuild, BOOL *stop) {
            return [savedBuild isSimilarTo:build];
        }] count];
        
        return overlaps == 0;
    });
    
    // Sort by project
    NSMutableArray *array = [NSMutableArray arrayWithArray:exclusiveBuilds];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return [[obj1 project] localizedCaseInsensitiveCompare:[obj2 project]];
    }];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        callback(array);
    });
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

+ (NSArray *)arrayFromJson:(id)json
{
    NSArray* builds = _.array(json)
    .map(^NSArray *(NSDictionary *parent) {
        return parent[@"branches"];
    })
    .flatten
    .map(^Build *(NSDictionary *buildJson) {
        return [Build fromJson:buildJson];
    }).unwrap;
    
    return builds;
}

+ (Build *)fromJson:(NSDictionary*)json
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    // Right now, only support semaphore.
    [dic setValue:@"SemaphoreBuild" forKey:@"type"];
    [dic setValue:json[@"project_name"] forKey:@"project"];
    [dic setValue:json[@"branch_name"] forKey:@"branch"];
    [dic setValue:json[@"result"] forKey:@"status"];
    [dic setValue:json[@"branch_status_url"] forKey:@"url"];
    [dic setValue:[Build safeParseDateFrom:json withKey:@"started_at"] forKey:@"startedAt"];
    [dic setValue:[Build safeParseDateFrom:json withKey:@"finished_at"] forKey:@"finishedAt"];
    
    // Load commit info
    NSDictionary *commitInfo = json[@"commit"];
    [dic setValue:commitInfo[@"id"] forKey:@"commitSha"];
    [dic setValue:commitInfo[@"author_name"] forKey:@"commitAuthor"];
    [dic setValue:commitInfo[@"author_email"] forKey:@"commitEmail"];
    [dic setValue:commitInfo[@"message"] forKey:@"commitMessage"];

    Build *build = [Build MR_createEntity];
    [build setFromDictionary: dic];
    return build;
}

+ (NSDate *)safeParseDateFrom:(NSDictionary*)json withKey:(NSString*)key
{
    if (json[key] && json[key] != (id)[NSNull null]) {
        @try {
            NSDate *date = [dateFormatter dateFromString:json[key]];
            return date;
        }
        @catch (NSException *exception) {
            NSLog(@"Failed to parse %@", json[key]);
        }
    }
    
    return nil;
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
}

@end