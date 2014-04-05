//
//  PMInfo.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 4/5/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "PMInfo.h"

@implementation PMInfo

// Class Singleton
// http://stackoverflow.com/questions/145154/what-should-my-objective-c-singleton-look-like
static NSDictionary *infos;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        NSString *pathForResource;
        
#ifdef DEBUG
        pathForResource = @"ProjectMonitor-Info.debug";
#else
        pathForResource = @"ProjectMonitor-Info.release";
#endif
        
        NSString *path = [[NSBundle mainBundle] pathForResource: pathForResource ofType: @"plist"];
        infos =[[NSDictionary alloc] initWithContentsOfFile:path];
    }
}

+ (NSString*)objectForKey:(NSString*)key {
    return [infos objectForKey:key];
}

@end
