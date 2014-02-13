//
//  BuildSpec.m
//  ProjectMonitor
//
//  Created by Dimitri Roche on 2/13/14.
//  Copyright (c) 2014 Dimitri Roche. All rights reserved.
//

#import "Kiwi.h"

SPEC_BEGIN(BuildSpec)

describe(@"Build", ^{
    describe(@"fromJson", ^{
        context(@"with finished_at null", ^{
            specify(^{
                [[theValue(true) should] equal:theValue(true)];
            });
        });
    });
});

SPEC_END
