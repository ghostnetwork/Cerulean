//
//  Peripheral.m
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "Peripheral.h"
#import "NSMutableArray+Queue.h"


@interface Peripheral ()<CBPeripheralManagerDelegate, CBPeripheralDelegate>
@property (strong, readonly) CBPeripheralManager *peripheralManager;
@property (strong, nonatomic) CBMutableCharacteristic *transferCharacteristic;
@end


@implementation Peripheral

#pragma mark - Public API
-(void)updateCharacteristicValue:(NSData *)value
{
    NSLog(@"update characteristic value: %ld bytes", (unsigned long)value.length);
    [self.peripheralManager updateValue:value forCharacteristic:self.transferCharacteristic onSubscribedCentrals:nil];
}


#pragma mark - Internal API
-(void)startAdvertising
{
    NSLog(@"startAdvertising; serviceID: %@", self.serviceUUIDString);
    CBUUID *uuid = [CBUUID UUIDWithString:self.serviceUUIDString];
    [self.peripheralManager startAdvertising:@{CBAdvertisementDataServiceUUIDsKey:@[uuid]}];
}

-(void)stopAdvertising
{
    NSLog(@"stopAdvertising");
    [self.peripheralManager stopAdvertising];
}


#pragma mark - CBPeripheralManagerDelegate
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"peripheral ON");
        [self configureTransferCharacteristic];
        [self configureTransferService];
        [self startAdvertising];
    }
    else if (peripheral.state == CBPeripheralManagerStatePoweredOff) {
        NSLog(@"peripheral OFF");
        [self stopAdvertising];
    }
}


#pragma mark - CBPeripheralDelegate
-(void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"peripheral.services: %@", peripheral.services);
    for (CBService *service in peripheral.services) {
        NSLog(@"    service: %@", service.UUID.UUIDString);
    }
}

    -(void)peripheralManager:(CBPeripheralManager *)peripheral
                     central:(CBCentral *)central
didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"didSubscribeToCharacteristic\n  peripheral: %@\n  central: %@\n  characteristic: %@",
          peripheral, central, characteristic);
    
    [self.delegate didSubscribeToCharacteristic:characteristic];
}

        -(void)peripheralManager:(CBPeripheralManager *)peripheral
                         central:(CBCentral *)central
didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"didUnsubscribeFromCharacteristic\n  peripheral: %@\n  central: %@\n  characteristic: %@",
          peripheral, central, characteristic);
    
    [self.delegate didUnsubscribeFromCharacteristic:characteristic];
}

-(void)peripheralManagerIsReadyToUpdateSubscribers:(CBPeripheralManager *)peripheral
{
}


#pragma mark - Configuration
-(void)configureTransferCharacteristic
{
    CBUUID *characteristicUUID = [CBUUID UUIDWithString:self.characteristicUUIDString];
    self.transferCharacteristic = [[CBMutableCharacteristic alloc] initWithType:characteristicUUID
                                                                     properties:CBCharacteristicPropertyNotify
                                                                          value:nil
                                                                    permissions:CBAttributePermissionsReadable];
}

-(void)configureTransferService
{
    CBUUID *serviceUUID = [CBUUID UUIDWithString:self.serviceUUIDString];
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:serviceUUID
                                                                       primary:YES];
    transferService.characteristics = @[self.transferCharacteristic];
    [self.peripheralManager addService:transferService];
}


#pragma mark - Initialization
-(instancetype)initWithDelegate:(id<PeripheralDelegate>)delegate
       characteristicUUIDString:(NSString *)characteristicUUIDString
              serviceUUIDString:(NSString *)serviceUUIDString
{
    self = [super initWithCharacteristicUUIDString:characteristicUUIDString serviceUUIDString:serviceUUIDString];
    
    if (self) {
        _delegate = delegate;
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:queue];
    }
    
    return self;
}

@end
