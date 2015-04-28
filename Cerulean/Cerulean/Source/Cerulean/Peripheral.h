//
//  Peripheral.h
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CeruleanObject.h"

@protocol PeripheralDelegate <NSObject>
-(void)didSubscribeToCharacteristic:(CBCharacteristic *)characteristic;
-(void)didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic;
@end


@interface Peripheral : BTObject
@property (weak, nonatomic) id<PeripheralDelegate> delegate;

-(void)updateCharacteristic:(NSString *)characteristicID withValue:(NSData *)value;
-(void)stopAdvertising;

-(instancetype)initWithDelegate:(id<PeripheralDelegate>)delegate
              serviceUUIDString:(NSString *)serviceUUIDString
      characteristicUUIDStrings:(NSArray *)characteristicUUIDStrings;
@end
