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
    NSString* objectId = [userInfo objectForKey:@"buildObjectId"];

    if( [apsInfo objectForKey:@"alert"] != NULL && objectId != nil)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            // Horrible, but I'm too lazy to probably coordinate the creation of the MasterViewController instance.
            // This is only an issue when launching the app from a push notification and navigating to a deep link.
            sleep(1);
            NSLog(@"Triggering %@ for object id %@", PMBuildDidBecomeSelected, objectId);
            NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
            [center postNotificationName:PMBuildDidBecomeSelected object:objectId];
        });
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
    [PFPush handlePush:userInfo];   // Do not run when launching application from APNS.
    NSNotificationCenter *center = [NSNotificationCenter defaultCenter];
    
    NSString* objectId = [userInfo objectForKey:@"buildObjectId"];
    if (objectId != nil) {
        [center postNotificationName:PMBuildDidBecomeSelected object:objectId];
    } else {
        [center postNotificationName:PMBuildsDidBecomeActiveNotication object:self];
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
