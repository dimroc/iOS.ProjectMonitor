//
//  Build.m
//  project-monitor
//
//  Created by Dimitri Roche on 2/10/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Build.h"

@implementation Build

+ (NSArray *)arrayFromJson:(id)json
{
    NSArray* builds = _.array(json)
    .map(^NSArray *(NSDictionary *parent) {
        return parent[@"branches"];
    })
    .flatten
    .map(^Build *(NSDictionary *buildJson) {
        return [Build fromJson:buildJson];
    }).unwrap;
    
    return builds;
}

+ (Build *) fromJson:(NSDictionary*)json
{
    Build *build = [[Build alloc] init];
    [build setProject:json[@"project_name"]];
    [build setBranch:json[@"branch_name"]];
    [build setStatus:json[@"result"]];
    [build setBranchStatusUrl:json[@"branch_status_url"]];
    return build;
}

- (NSString *)description
{
    return [NSString stringWithFormat: @"Build: Project=%@ Branch=%@ Status=%@ BranchStatusUrl=%@", _project, _branch, _status, _branchStatusUrl];
}

@end
