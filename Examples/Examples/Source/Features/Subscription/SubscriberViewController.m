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
@property (nonatomic, readonly) CGFloat origCircleBottomSpaceConstant;

// Outlets
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleBottomSpaceConstraint;
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
    else if ([command hasPrefix:self.commands.circlePositionY]) {[self updateCirclePosition:command];}
    else if ([command isEqualToString:self.commands.returnCircleToStart]) {[self returnCircleToStartingPosition];}
}
-(void)acceptData:(NSData *)data {[self routeCommand:[self parseCommand:data]];}
-(NSString *)parseCommand:(NSData *)data {return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];}


#pragma mark - Command Handlers
-(void)onInitialConnectionAwk {[self updateStatus:@"ICA received"];}
-(void)updateCirclePosition:(NSString *)command
{
    NSArray *parts = [command componentsSeparatedByString:self.commands.circlePositionY];
    if (parts && parts.count == 2) {
        NSString *positionY = parts[1];
        CGFloat y = [positionY doubleValue];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.circleBottomSpaceConstraint.constant = y;
        });
    }
}
-(void)returnCircleToStartingPosition
{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.circleBottomSpaceConstraint.constant = self.origCircleBottomSpaceConstant;
        [UIView animateWithDuration:0.25
                         animations:^{[self.view layoutIfNeeded];}
                         completion:^(BOOL finished) {}];
    });
}


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

-(void)configureCircleView
{
    self.circleView.layer.cornerRadius = self.circleView.bounds.size.width / 2.0;
    self.circleView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.75].CGColor;
    self.circleView.layer.borderWidth = 1.0;
}


#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _origCircleBottomSpaceConstant = self.circleBottomSpaceConstraint.constant;
    
    [self configureCircleView];
    [self configureCentral];
}

@end
