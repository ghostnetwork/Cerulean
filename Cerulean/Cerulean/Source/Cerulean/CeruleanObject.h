//
//  BTCommon.h
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>
@import CoreBluetooth;


extern NSString *const kStartOfMessageText;
extern NSString *const kStartSeparatorText;
extern NSString *const kEndOfMessageText;

extern NSUInteger const kMaxChunkSize;

@interface BTObject : NSObject
@property (strong, readonly) NSString *characteristicUUIDString;
@property (strong, readonly) NSString *serviceUUIDString;

-(instancetype)initWithCharacteristicUUIDString:(NSString *)characteristicUUIDString
                              serviceUUIDString:(NSString *)serviceUUIDString;
@end
