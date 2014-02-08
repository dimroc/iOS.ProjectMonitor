//
//  SemaphoreSourceViewController.h
//  project-monitor
//
//  Created by Dimitri Roche on 2/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BuildSource.h"

@interface SemaphoreSourceViewController : UIViewController <BuildSource>

@property (nonatomic, copy) NSString* name;
@property (nonatomic, weak) UIViewController* controller;

@end
