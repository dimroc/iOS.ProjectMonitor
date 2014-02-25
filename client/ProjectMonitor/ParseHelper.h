//
//  ParseHelper.h
//  ProjectMonitor
//
//  Created by Dimitri Roche on 1/29/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParseHelper : NSObject

+ (void)launch:(NSDictionary *)launchOptions;
+ (NSDictionary *)toDictionary:(PFObject*)message;
+ (void)registerForRemoteNotificationWithDeviceToken:(NSData*)deviceToken;
+ (void)registerUserForRemoteNotification:(PFUser*)user;

@end
