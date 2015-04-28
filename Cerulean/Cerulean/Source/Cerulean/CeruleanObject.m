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

#pragma mark - Public API
-(NSArray *)configureCharacteristicCBUUIDs
{
    NSMutableArray *working = [[NSMutableArray alloc] init];
    for (NSString *characteristicID in self.characteristicUUIDStrings) {
        CBUUID *uuid = [CBUUID UUIDWithString:characteristicID];
        [working addObject:uuid];
    }
    return [NSArray arrayWithArray:working];
}

-(BOOL)isKnownCharacteristic:(CBCharacteristic *)characteristic
{
    NSString *targetCharacteristicID = characteristic.UUID.UUIDString;
    for (NSString *characteristicID in self.characteristicUUIDStrings) {
        if ([characteristicID isEqualToString:targetCharacteristicID]) {return YES;}
    }
    return NO;
}


#pragma mark - Initialization
-(instancetype)initWithServiceUUIDString:(NSString *)serviceUUIDString
               characteristicUUIDStrings:(NSArray *)characteristicUUIDStrings
{
    self = [super init];
    if (self) {
        _serviceUUIDString = serviceUUIDString;
        _characteristicUUIDStrings = characteristicUUIDStrings;
    }
    return self;
}

@end
