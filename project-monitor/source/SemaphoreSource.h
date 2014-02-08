//
//  SemaphoreSource.h
//  project-monitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildSource.h"

@interface SemaphoreSource : NSObject<BuildSource>

@property (nonatomic, copy) NSString* name;

@end
