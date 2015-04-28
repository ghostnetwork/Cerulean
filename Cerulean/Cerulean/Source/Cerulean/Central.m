//
//  Central.m
//  Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "Central.h"


@interface Central ()<CBCentralManagerDelegate, CBPeripheralDelegate>
@property (strong, readonly, nonatomic) CBCentralManager *centralManager;
@property (strong) CBPeripheral *sendingPeripheral;
@end


@implementation Central

#pragma mark - CBCentralManagerDelegate
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    if (central.state == CBCentralManagerStatePoweredOn) {
        NSLog(@"central ON");
        [self startScanningForPeripherals];
    }
    else if (central.state == CBCentralManagerStatePoweredOff) {
        NSLog(@"central OFF");
        [self stopScanningForPeripherals];
    }
}

-(void)centralManager:(CBCentralManager *)central
didDiscoverPeripheral:(CBPeripheral *)peripheral
    advertisementData:(NSDictionary *)advertisementData
                 RSSI:(NSNumber *)RSSI
{
    if (self.sendingPeripheral != peripheral) {
        NSLog(@"Discovered %@ at %@", peripheral.identifier.UUIDString, RSSI);
        self.sendingPeripheral = peripheral;
        
        NSLog(@"Connecting to peripheral %@", peripheral);
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

-(void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"didConnectPeripheral: %@", peripheral);
    
    [self.centralManager stopScan];
    NSLog(@"Scanning stopped");
    
    peripheral.delegate = self;
    [peripheral discoverServices:@[[CBUUID UUIDWithString:self.serviceUUIDString]]];
    
    [self.delegate didConnectToPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"<-- disconnected from: %@ [%@]", peripheral.name, error);
    
    [self.delegate didDisconnectFromPeripheral:peripheral];
}

-(void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error
{
    NSLog(@"failed to connect to peripheral: %@; error: [%@]", peripheral.name, error);
}

-(void)centralManager:(CBCentralManager *)central didRetrieveConnectedPeripherals:(NSArray *)peripherals
{
    NSLog(@"did retrieve connected peripherals: %@", peripherals);
}

-(void)centralManager:(CBCentralManager *)central didRetrievePeripherals:(NSArray *)peripherals
{
    NSLog(@"did retrieve peripherals: %@", peripherals);
}


#pragma mark - CBPeripheralDelegate
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    NSLog(@"didDiscoverServices: %@", peripheral.services);
    NSArray *characteristicCBUUIDs = [self configureCharacteristicCBUUIDs];
    for (CBService *service in peripheral.services) {
        [peripheral discoverCharacteristics:characteristicCBUUIDs
                                 forService:service];
    }
}

                  - (void)peripheral:(CBPeripheral *)peripheral
didDiscoverCharacteristicsForService:(CBService *)service
                               error:(NSError *)error
{
    for (CBCharacteristic *characteristic in service.characteristics) {
        if ([self isKnownCharacteristic:characteristic]) {
            NSLog(@"subscribed to characteristic: %@", characteristic);
            [peripheral setNotifyValue:YES forCharacteristic:characteristic];
        }
    }
}

             - (void)peripheral:(CBPeripheral *)peripheral
didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic
                          error:(NSError *)error
{
    if (error) {
        NSLog(@"Error discovering characteristics: %@", [error localizedDescription]);
        return;
    }
    
    [self.delegate didReceiveData:characteristic.value];
}

-(void)peripheral:(CBPeripheral *)peripheral didModifyServices:(NSArray *)invalidatedServices
{
    NSLog(@"didModifyServices: %@", invalidatedServices);
}


#pragma mark - Internal API
-(void)startScanningForPeripherals
{
    NSLog(@"scanning for peripheral; serviceID: %@", self.serviceUUIDString);
    CBUUID *uuid = [CBUUID UUIDWithString:self.serviceUUIDString];
    [self.centralManager scanForPeripheralsWithServices:@[uuid]
                                                options:@{CBCentralManagerScanOptionAllowDuplicatesKey:@YES }];
}

-(void)stopScanningForPeripherals
{
    NSLog(@"stopping scanning for peripheral");
    [self.centralManager stopScan];
}


#pragma mark - Configuration
-(void)configureWithDelegate:(id<CentralDelegate>)delegate
{
    _delegate = delegate;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    _centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
}


#pragma mark - Initialization
-(instancetype)initWithDelegate:(id<CentralDelegate>)delegate
              serviceUUIDString:(NSString *)serviceUUIDString
      characteristicUUIDStrings:(NSArray *)characteristicUUIDStrings
{
    self = [super initWithServiceUUIDString:serviceUUIDString characteristicUUIDStrings:characteristicUUIDStrings];
    if (self) {[self configureWithDelegate:delegate];}
    return self;
}

@end
