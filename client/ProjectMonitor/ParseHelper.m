//
//  ParseHelper.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 1/29/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "ParseHelper.h"

@implementation ParseHelper

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

+(void)launch:(NSDictionary *)launchOptions     {
    [Parse setApplicationId: [credentials objectForKey: @"ParseApplicationId"]
                  clientKey: [credentials objectForKey: @"ParseClientKey"]];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
}

+ (NSDictionary *)toDictionary:(PFObject*)message
{
    NSArray * allKeys = [message allKeys];
    NSMutableDictionary * retDict = [[NSMutableDictionary alloc] init];
    
    for (NSString * key in allKeys) {
        [retDict setObject:[message objectForKey:key] forKey:key];
    }
    
    return retDict;
}

+ (void)registerForRemoteNotificationWithDeviceToken:(NSData*)deviceToken
{
    // Store the deviceToken in the current installation and save it to Parse.
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    [currentInstallation setDeviceTokenFromData:deviceToken];
    [currentInstallation saveInBackground];
}

+ (void) registerUserForRemoteNotification:(PFUser*)user
{
    PFInstallation *currentInstallation = [PFInstallation currentInstallation];
    
    // Ensure that we only register for installations with devices that can receive
    // push notifications.
    if (currentInstallation && currentInstallation.deviceToken) {
        currentInstallation[@"user"] = user;
        [currentInstallation saveInBackground];
    }
}

@end
