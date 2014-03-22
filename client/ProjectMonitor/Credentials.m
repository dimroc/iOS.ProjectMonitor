//
//  Credentials.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/11/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Credentials.h"

@implementation Credentials

// Class Singleton
// http://stackoverflow.com/questions/145154/what-should-my-objective-c-singleton-look-like
static NSDictionary *credentials;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        NSString *pathForResource;
        
#ifdef DEBUG
        pathForResource = @"Credentials.debug";
#else
        pathForResource = @"Credentials.release";
#endif
        
        NSString *path = [[NSBundle mainBundle] pathForResource: pathForResource ofType: @"plist"];
        credentials =[[NSDictionary alloc] initWithContentsOfFile:path];
    }
}

+ (NSString*)objectForKey:(NSString*)key {
    return [credentials objectForKey:key];
}

@end
