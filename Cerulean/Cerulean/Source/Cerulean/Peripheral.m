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
@property (copy, nonatomic, readonly) NSArray *characteristics;
@end


@implementation Peripheral

#pragma mark - Public API
-(void)updateCharacteristic:(NSString *)characteristicID withValue:(NSData *)value
{
    NSLog(@"update characteristic [%@]; value: %ld bytes", characteristicID, (unsigned long)value.length);
    CBMutableCharacteristic *c = [self characteristicWithID:characteristicID];
    if (c) {
        [self.peripheralManager updateValue:value forCharacteristic:c onSubscribedCentrals:nil];
    }
}


#pragma mark - CBPeripheralManagerDelegate
-(void)peripheralManagerDidUpdateState:(CBPeripheralManager *)peripheral
{
    if (peripheral.state == CBPeripheralManagerStatePoweredOn) {
        NSLog(@"peripheral ON");
        [self configureCharacteristics];
        [self configureService];
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

-(CBMutableCharacteristic *)characteristicWithID:(NSString *)characteristicID
{
    for (CBMutableCharacteristic *c in self.characteristics) {
        if ([c.UUID.UUIDString isEqualToString:characteristicID]) {return c;}
    }
    return nil;
}


#pragma mark - Configuration
-(void)configureWithDelegate:(id<PeripheralDelegate>)delegate
{
    _delegate = delegate;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _peripheralManager = [[CBPeripheralManager alloc] initWithDelegate:self queue:queue];
}

-(void)configureCharacteristics
{
    NSMutableArray *working = [[NSMutableArray alloc] init];
    for (NSString *characteristicID in self.characteristicUUIDStrings) {
        CBUUID *uuid = [CBUUID UUIDWithString:characteristicID];
        CBMutableCharacteristic *c = [[CBMutableCharacteristic alloc] initWithType:uuid
                                                                        properties:CBCharacteristicPropertyNotify
                                                                             value:nil
                                                                       permissions:CBAttributePermissionsReadable];
        [working addObject:c];
    }
    _characteristics = [NSArray arrayWithArray:working];
}

-(void)configureService
{
    CBUUID *serviceUUID = [CBUUID UUIDWithString:self.serviceUUIDString];
    CBMutableService *transferService = [[CBMutableService alloc] initWithType:serviceUUID
                                                                       primary:YES];
    transferService.characteristics = self.characteristics;
    [self.peripheralManager addService:transferService];
}


#pragma mark - Initialization
-(instancetype)initWithDelegate:(id<PeripheralDelegate>)delegate
              serviceUUIDString:(NSString *)serviceUUIDString
      characteristicUUIDStrings:(NSArray *)characteristicUUIDStrings
{
    self = [super initWithServiceUUIDString:serviceUUIDString characteristicUUIDStrings:characteristicUUIDStrings];
    if (self) {[self configureWithDelegate:delegate];}
    return self;
}

@end
