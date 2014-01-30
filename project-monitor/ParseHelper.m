//
//  ParseHelper.m
//  project-monitor
//
//  Created by Dimitri Roche on 1/29/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Parse/Parse.h>
#import "ParseHelper.h"

@implementation ParseHelper

+(void)initialize:(NSDictionary *)launchOptions     {
    [Parse setApplicationId: [credentials objectForKey: @"ParseApplicationId"]
                  clientKey: [credentials objectForKey: @"ParseClientKey"]];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

+(void)saveTestObjectInBackground
{
    PFObject *testObject = [PFObject objectWithClassName:@"TestObject"];
    testObject[@"foo"] = @"bar";
    [testObject saveInBackground];
}

// Class Singleton
// http://stackoverflow.com/questions/145154/what-should-my-objective-c-singleton-look-like
static NSDictionary *credentials;

+ (void)initialize
{
    static BOOL initialized = NO;
    if(!initialized)
    {
        initialized = YES;
        NSString *path = [[NSBundle mainBundle] pathForResource: @"Credentials" ofType: @"plist"];
        credentials =[[NSMutableDictionary alloc] initWithContentsOfFile:path];
    }
}
@end
