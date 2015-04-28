//
//  Commands.m
//  Examples
//
//  Created by Keith Ermel on 4/27/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "Commands.h"



@implementation Commands

- (instancetype)init
{
    self = [super init];
    if (self) {
        _initialConnectionAwk = @"#ICA#";
        _circlePositionY = @"#CPY#::";
        _returnCircleToStart = @"#RCS#";
    }
    return self;
}
@end
