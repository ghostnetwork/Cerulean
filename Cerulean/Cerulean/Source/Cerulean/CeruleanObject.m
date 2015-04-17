//
//  CeruleanObject.m
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "CeruleanObject.h"


NSString *const kStartOfMessageText         = @"#SOM#";
NSString *const kStartSeparatorText         = @":";
NSString *const kEndOfMessageText           = @"#EOM#";

NSUInteger const kMaxChunkSize              = 20; // bytes


@implementation BTObject

-(instancetype)initWithCharacteristicUUIDString:(NSString *)characteristicUUIDString
                              serviceUUIDString:(NSString *)serviceUUIDString
{
    self = [super init];
    if (self) {
        _characteristicUUIDString = characteristicUUIDString;
        _serviceUUIDString = serviceUUIDString;
    }
    return self;
}

@end
