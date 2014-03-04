//
//  Helper.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/4/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Helper.h"

@implementation Helper

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

@end
