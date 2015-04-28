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
#import "Commands.h"


@interface SubscriberViewController ()<CentralDelegate>
@property (strong, readonly) Central *central;
@end


@implementation SubscriberViewController

#pragma mark - CentralDelegate
-(void)didConnectToPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"did connect to peripheral: %@", peripheral.identifier.UUIDString);
    [self updateConnectionStatus:ConnectionStatusConnected];
}

-(void)didDisconnectFromPeripheral:(CBPeripheral *)peripheral
{
    NSLog(@"did disconnect from peripheral: %@", peripheral.identifier.UUIDString);
    [self updateConnectionStatus:ConnectionStatusDisconnected];
}

-(void)didReceiveData:(NSData *)data
{
    NSLog(@"did receive data: %ld", (unsigned long)data.length);
    [self acceptData:data];
}


#pragma mark - Internal API
-(void)routeCommand:(NSString *)command
{
    NSLog(@"routeCommand: %@", command);
    if ([command isEqualToString:self.commands.initialConnectionAwk]) {[self onInitialConnectionAwk];}
}
-(void)acceptData:(NSData *)data {[self routeCommand:[self parseCommand:data]];}
-(NSString *)parseCommand:(NSData *)data {return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];}


#pragma mark - Command Handlers
-(void)onInitialConnectionAwk {[self updateStatus:@"ICA received"];}


#pragma mark - Segue
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"subscriberConnectionStatusSegue"]) {
        self.connectionStatusVC = (ConnectionStatusViewController *)segue.destinationViewController;
    }
}


#pragma mark - Configuration
-(void)configureCentral
{
    NSString *serviceID = [CeruleanAppDelegate appDelegate].subscriptionServiceID;
    NSString *characteristicID = [CeruleanAppDelegate appDelegate].subscriptionCurrentTimeID;
    
    _central = [[Central alloc] initWithDelegate:self
                               serviceUUIDString:serviceID
                       characteristicUUIDStrings:@[characteristicID]];
}


#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureCentral];
}

@end
