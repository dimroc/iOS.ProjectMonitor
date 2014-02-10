//
//  BuildFactory.h
//  project-monitor
//
//  Created by Dimitri Roche on 2/9/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^FetchBuildCallback)(NSArray *);

@interface BuildFactory : NSObject

+ (void) fetchFromSemaphore:(NSString*)authenticationToken withCallback:(FetchBuildCallback)callbackBlock;

@end
