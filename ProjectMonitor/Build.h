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

@interface Build : NSManagedObject

+ (void) fetchFromSemaphore:(NSString*)authenticationToken withCallback:(FetchBuildCallback)callbackBlock;
+ (NSArray *)arrayFromCoreData:(NSManagedObjectContext *)context;
+ (NSArray *)arrayFromJson:(id)json;
+ (Build *) fromJson:(NSDictionary*)json;

@property (nonatomic, retain) NSString * project;
@property (nonatomic, retain) NSString * branch;
@property (nonatomic, retain) NSString * type;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSDate * startedAt;
@property (nonatomic, retain) NSString * finishedAt;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSString * objectId;

- (NSString *)description;
- (void)saveInBackgroundWithBlock: (void (^)(BOOL))mainThreadCallback;

@end