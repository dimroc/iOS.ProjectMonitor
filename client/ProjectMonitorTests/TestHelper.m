//
//  TestHelper.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/5/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "TestHelper.h"

@implementation TestHelper

+ (id)dataFromJSONFileNamed:(NSString *)fileName
{
    //    NSString *resource = [[NSBundle mainBundle] pathForResource:fileName ofType:@"json"];
    
    NSBundle *bundle = [NSBundle bundleForClass:[self class]];
    NSString *resource = [bundle pathForResource:fileName ofType:@"json"];

    NSInputStream *inputStream = [NSInputStream inputStreamWithFileAtPath:resource];
    [inputStream open];
    
    return [NSJSONSerialization JSONObjectWithStream:inputStream options:0 error:nil];
}

@end
