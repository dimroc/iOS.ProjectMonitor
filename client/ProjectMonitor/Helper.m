//
//  Helper.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/4/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Helper.h"

@implementation Helper

static NSDateFormatter *dateFormatter;
dispatch_queue_t dateFormatterQueue;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatterQueue = dispatch_queue_create("com.iOS.ProjectMonitor.Helper.dateFormatter", NULL);
    }
}

+ (BOOL)stringValid:(NSString*)value
{
    if (value && value != 0)
    {
        return YES;
    }
    else
    {
        return NO;
    }
    
}

+ (NSDate *)parseDateSafelyFromDictionary:(NSDictionary*)dic withKey:(NSString*)key
{
    if (dic && dic[key] && dic[key] != (id)[NSNull null]) {
        @try {
            NSDate *date = [self dateFromString:dic[key]];
            return date;
        }
        @catch (NSException *exception) {
            NSLog(@"# Failed to parse %@", dic[key]);
        }
    }
    
    return nil;
}

#pragma mark date helpers

// Rather than recreating a DateFormatter everywhere, we'll reuse the same one in a thread safe manner.
// Serial queues are better than sync apparently, no thread contention.
// Apple: "If you need to synchronize parts of your code, use a serial dispatch queue instead of a lock."
// https://developer.apple.com/library/mac/documentation/general/conceptual/concurrencyprogrammingguide/OperationQueues/OperationQueues.html
+ (NSString*) stringFromDate:(NSDate*)date
{
    __block NSString *rval;
    dispatch_sync(dateFormatterQueue, ^{
        [dateFormatter setTimeZone:[NSTimeZone localTimeZone]];
        [dateFormatter setDateFormat:@"MMM dd, yyyy h:mm a"];
        rval = [dateFormatter stringFromDate:date];
    });
    
    return rval;
}

+ (NSDate*) dateFromString:(NSString*)dateString
{
    __block NSDate *rval;
    dispatch_sync(dateFormatterQueue, ^{
        [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ssZZZ"];
        rval = [dateFormatter dateFromString:dateString];
    });
    
    return rval;
}

+ (BOOL)isAnyNull:(id)value
{
    return !value || value == (id)[NSNull null];
}

@end
