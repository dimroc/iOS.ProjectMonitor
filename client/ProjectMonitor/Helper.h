//
//  Helper.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/4/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Helper : NSObject

+ (BOOL)stringValid:(NSString*)value;
+ (NSString*) stringFromDate:(NSDate*)date;
+ (NSDate*) dateFromString:(NSString*)dateString;
+ (NSDate *)parseDateSafelyFromDictionary:(NSDictionary*)json withKey:(NSString*)key;
+ (BOOL)isAnyNull:(id)value;

@end
