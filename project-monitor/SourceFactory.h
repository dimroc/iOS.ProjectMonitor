//
//  SourceFactory.h
//  project-monitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Source.h"

@interface SourceFactory : NSObject

+ (id<Source>)fetch:(NSString*)name;

@end