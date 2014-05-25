//
//  BuildCollection.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 3/8/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "BuildCollection.h"
#import "Build.h"

@interface BuildCollection ()
@property (nonatomic, strong) NSArray *buildsByType;
@property (nonatomic, strong) NSArray *buildLabelsByType;
@end

@implementation BuildCollection

- (BOOL)isEmpty
{
    return [[self onlyPopulated] count] <= 0;
}

- (void)refreshFromCoreData
{
    NSMutableArray *array = [NSMutableArray array];
    array[SemaphoreBuildType] = [Build forType:@"Semaphore"];
    array[TravisBuildType] = [Build forType:@"Travis"];
    array[TravisProBuildType] = [Build forType:@"TravisPro"];
    [self setBuildsByType:array];
    
    [self setBuildLabelsByType:[NSArray arrayWithObjects:
                                @"Semaphore", @"Travis",
                                @"Travis Pro", nil]];
}

- (void)clear
{
    [self setBuildLabelsByType:[NSArray array]];
    [self setBuildsByType:[NSArray array]];
}

- (NSArray*)onlyPopulated
{
    return [self.buildsByType bk_select:^BOOL(id obj) {
        return [obj count] > 0;
    }];
}

- (NSArray*)onlyPopulatedTitles
{
    NSInteger index = 0;
    NSMutableArray *populatedTitles = [NSMutableArray array];
    for (NSArray* builds in [self buildsByType]) {
        if ([builds count] > 0) {
            [populatedTitles addObject:[self.buildLabelsByType objectAtIndex:index]];
        }
        
        index++;
    }
    
    return populatedTitles;
}

- (NSString*)description
{
    NSMutableString *string = [NSMutableString string];
    [string appendString:@"BuildCollection: "];
    [self.buildsByType bk_each:^(id obj) {
        [obj bk_each:^(id obj) {
            [string appendString:[obj description]];
        }];
    }];
    
    return string;
}

@end