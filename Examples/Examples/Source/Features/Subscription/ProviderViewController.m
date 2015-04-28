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
#import "Commands.h"


@interface ProviderViewController ()<PeripheralDelegate>
@property (strong, readonly) Peripheral *provider;
@end


@implementation ProviderViewController

#pragma mark - PeripheralDelegate
-(void)didSubscribeToCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"--> did subscribe");

    [self postMessage:self.commands.initialConnectionAwk];
    [self updateConnectionStatus:ConnectionStatusConnected];
    [self updateStatus:@"ICA posted"];
}

-(void)didUnsubscribeFromCharacteristic:(CBCharacteristic *)characteristic
{
    NSLog(@"<-- did unsubscribe");
    [self updateConnectionStatus:ConnectionStatusDisconnected];
}


#pragma mark - Internal API
-(void)postMessage:(NSString *)message
{
    NSData *value = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.provider updateCharacteristicValue:value];
}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"providerConnectionStatusSegue"]) {
        self.connectionStatusVC = (ConnectionStatusViewController *)segue.destinationViewController;
    }
}


#pragma mark - Configuration
-(void)configureProvider
{
    NSString *serviceID = [CeruleanAppDelegate appDelegate].subscriptionServiceID;
    NSString *characteristicID = [CeruleanAppDelegate appDelegate].subscriptionCurrentTimeID;

    _provider = [[Peripheral alloc] initWithDelegate:self
                            characteristicUUIDString:characteristicID
                                   serviceUUIDString:serviceID];
}


#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureProvider];
}

@end
