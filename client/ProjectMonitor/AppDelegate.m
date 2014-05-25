//
//  AppDelegate.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 1/29/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "AppDelegate.h"
#import "ParseHelper.h"
#import "Build.h"
#import "Credentials.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [ParseHelper launch:launchOptions];
    [NewRelicAgent startWithApplicationToken: [Credentials objectForKey:@"NewRelicToken"]];
    [MagicalRecord setupAutoMigratingCoreDataStack];
    
    // Register for push notifications
    [application registerForRemoteNotificationTypes:
     UIRemoteNotificationTypeBadge |
     UIRemoteNotificationTypeAlert |
     UIRemoteNotificationTypeSound];
    
    NSLog(@"# Application Documents Directory: %@", [self applicationDocumentsDirectory]);
    NSLog(@"# %@", [MagicalRecord currentStack]);
    
    [Crashlytics startWithAPIKey:[Credentials objectForKey:@"CrashlyticsKey"]];
    
    NSDictionary* userInfo = launchOptions[UIApplicationLaunchOptionsRemoteNotificationKey];
    NSDictionary* apsInfo = [userInfo objectForKey:@"aps"];
    if( [apsInfo objectForKey:@"alert"] != NULL)
    {
        [self application:application didReceiveRemoteNotification:userInfo];
    }
    
    return YES;
}

- (NSString *) applicationDocumentsDirectory
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *basePath = ([paths count] > 0) ? [paths objectAtIndex:0] : nil;
    return basePath;
}

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    [ParseHelper registerForRemoteNotificationWithDeviceToken: deviceToken];
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
    NSLog(@"Did receive remote notification");
    [PFPush handlePush:userInfo];
    
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:PMBuildsDidBecomeActiveNotication object:self];
    
    NSString* objectId = [userInfo objectForKey:@"buildObjectId"];
    if (objectId != nil) {
        NSLog(@"Triggering %@ for object id %@", PMBuildDidBecomeSelected, objectId);
        [center postNotificationName:PMBuildDidBecomeSelected object:objectId];
    }
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];

    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    [center postNotificationName:PMBuildsDidBecomeActiveNotication object:self];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Saves changes in the application's managed object context before the application terminates.
    [MagicalRecord cleanUp];
}

#pragma mark - Facebook Oauth callbacks

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication withSession:[PFFacebookUtils session]];
}

@end
