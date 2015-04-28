//
//  Central.h
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CeruleanObject.h"


@protocol CentralDelegate <NSObject>
-(void)didConnectToPeripheral:(CBPeripheral *)peripheral;
-(void)didDisconnectFromPeripheral:(CBPeripheral *)peripheral;
-(void)didReceiveData:(NSData *)data;
@end

@interface Central : BTObject
@property (weak, nonatomic) id<CentralDelegate> delegate;


-(instancetype)initWithDelegate:(id<CentralDelegate>)delegate
              serviceUUIDString:(NSString *)serviceUUIDString
      characteristicUUIDStrings:(NSArray *)characteristicUUIDStrings;
@end
