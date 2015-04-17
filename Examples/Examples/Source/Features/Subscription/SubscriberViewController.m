//
//  SubscriberViewController.m
//  Examples
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

@import Cerulean;
#import "SubscriberViewController.h"
#import "CeruleanAppDelegate.h"


@interface SubscriberViewController ()<CentralDelegate>
@property (strong, readonly) Central *central;
@end


@implementation SubscriberViewController

#pragma mark - CentralDelegate
-(void)didConnectToPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"did connect to peripheral: %@", peripheral.identifier.UUIDString);
}

-(void)didDisconnectFromPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"did disconnect from peripheral: %@", peripheral.identifier.UUIDString);
}

-(void)didReceiveData:(NSData *)data
{
    NSLog(@"did receive data: %ld", (unsigned long)data.length);
}


#pragma mark - Configuration
-(void)configureCentral
{
    NSString *serviceID = [CeruleanAppDelegate appDelegate].subscriptionServiceID;
    NSString *characteristicID = [CeruleanAppDelegate appDelegate].subscriptionCurrentTimeID;
    
    _central = [[Central alloc] initWithDelegate:self
                        characteristicUUIDString:characteristicID
                               serviceUUIDString:serviceID];
}


#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureCentral];
}

@end
