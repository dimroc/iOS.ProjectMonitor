//
//  Build.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/14/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

typedef void (^FetchBuildCallback)(NSArray *);
extern NSString * const PMBuildDidSaveNotication;

@interface Build : NSManagedObject

+ (void)fetchFromSemaphore:(NSString*)authenticationToken withCallback:(FetchBuildCallback)callbackBlock;
+ (void)refreshSavedBuildsInBackground:(void (^)(BOOL, NSArray*))callback;
+ (NSArray *)arrayFromJson:(id)json;
+ (Build *)fromJson:(NSDictionary*)json;
+ (NSArray *)all;

@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSString * branch;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * startedAt;
@property (nonatomic, retain) NSDate * finishedAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * objectId;

@property (nonatomic, retain) NSString * commitSha;
@property (nonatomic, retain) NSString * commitAuthor;
@property (nonatomic, retain) NSString * commitEmail;
@property (nonatomic, retain) NSString * commitMessage;

- (NSString *)description;
- (BOOL)isSimilarTo:(Build *)build;
- (void)saveInBackgroundWithBlock: (void (^)(BOOL))mainThreadCallback;
- (void)deleteInBackground;

@end