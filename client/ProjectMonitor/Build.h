//
//  Build.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/14/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

extern NSString * const PMBuildDidSaveNotication;
extern NSString * const PMBuildDidBecomeSelected;
extern NSString * const PMBuildsDidBecomeActiveNotication;

@interface Build : NSManagedObject

+ (NSArray *)all;
+ (NSArray *)forType:(NSString*)type;
+ (NSArray *)saved;

+ (void)refreshSavedBuildsInBackground:(void (^)(BOOL, NSArray*))callback;
+ (void)updateSavedBuild:(NSDictionary *)dictionary;
+ (void)saveInBackground:(NSArray *)builds withBlock: (void (^)(BOOL))mainThreadCallback;

#pragma mark properties
@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSString * branch;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * startedAt;
@property (nonatomic, retain) NSDate * finishedAt;
@property (nonatomic, retain) NSDate * updatedAt;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * objectId;
@property (nonatomic) BOOL isInvalid;
@property (nonatomic, retain) NSString * invalidMessage;

@property (nonatomic, retain) NSString * commitSha;
@property (nonatomic, retain) NSString * commitAuthor;
@property (nonatomic, retain) NSString * commitEmail;
@property (nonatomic, retain) NSString * commitMessage;

- (NSString *)description;
- (BOOL)isSimilarTo:(Build *)build;
- (void)setFromDictionary:(NSDictionary*)dic;
- (void)deleteInBackground;

@end