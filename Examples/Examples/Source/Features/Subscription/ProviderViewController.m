//
//  ProviderViewController.m
//  Examples
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

@import Cerulean;
#import "ProviderViewController.h"
#import "CeruleanAppDelegate.h"


@interface ProviderViewController ()<PeripheralDelegate>
@property (strong, readonly) Peripheral *peripheral;
@end


@implementation ProviderViewController

#pragma mark - PeripheralDelegate
-(void)peripheral:(CBPeripheralManager *)peripheral didSubscribe:(CBCharacteristic *)characteristic
{
    
}

-(void)peripheral:(CBPeripheralManager *)peripheral didUnsubscribe:(CBCharacteristic *)characteristic
{
    
}

#pragma mark - PeripheralDelegate
-(void)didSubscribe:(CBCharacteristic *)characteristic
{
    NSLog(@"did subscribe: %@", characteristic.UUID.UUIDString);
}

-(void)didUnsubscribe:(CBCharacteristic *)characteristic
{
    NSLog(@"did unubscribe: %@", characteristic.UUID.UUIDString);
}


#pragma mark - Configuration
-(void)configurePeripheral
{
    NSString *serviceID = [CeruleanAppDelegate appDelegate].subscriptionServiceID;
    NSString *characteristicID = [CeruleanAppDelegate appDelegate].subscriptionCurrentTimeID;

    _peripheral = [[Peripheral alloc] initWithDelegate:self
                              characteristicUUIDString:characteristicID
                                     serviceUUIDString:serviceID];
}


#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configurePeripheral];
}

@end
