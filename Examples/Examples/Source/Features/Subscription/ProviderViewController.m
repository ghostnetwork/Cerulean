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
@property (nonatomic, readonly) CGFloat origCircleBottomSpaceConstant;

// Outlets
@property (weak, nonatomic) IBOutlet UIView *circleView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *circleBottomSpaceConstraint;
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
    NSString *characteristicID = [CeruleanAppDelegate appDelegate].subscriptionCurrentTimeID;
    NSData *value = [message dataUsingEncoding:NSUTF8StringEncoding];
    [self.provider updateCharacteristic:characteristicID withValue:value];
}

-(void)updateCirclePosition:(CGFloat)deltaY
{
    CGFloat y = self.origCircleBottomSpaceConstant + (-1.0 * deltaY);
    self.circleBottomSpaceConstraint.constant = y;
    
    NSString *message = [NSString stringWithFormat:@"%@%3.0f", self.commands.circlePositionY, y];
    [self postMessage:message];
}

-(void)returnCircleToOriginalPosition
{
    self.circleBottomSpaceConstraint.constant = self.origCircleBottomSpaceConstant;
    [UIView animateWithDuration:0.25
                     animations:^{[self.view layoutIfNeeded];}
                     completion:^(BOOL finished) {[self postMessage:self.commands.returnCircleToStart];}];
}


#pragma mark - Gestures
-(void)didPan:(UIPanGestureRecognizer *)gesture
{
    CGFloat deltaY = [gesture translationInView:self.view].y;
    switch (gesture.state) {
        case UIGestureRecognizerStateChanged:
            [self updateCirclePosition:deltaY];
            break;
            
        case UIGestureRecognizerStateCancelled:
        case UIGestureRecognizerStateEnded:
        case UIGestureRecognizerStateFailed:
            [self returnCircleToOriginalPosition];
            break;
            
        default:
            break;
    }
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
                                   serviceUUIDString:serviceID
                           characteristicUUIDStrings:@[characteristicID]];
}

-(void)configureCircleView
{
    self.circleView.layer.cornerRadius = self.circleView.bounds.size.width / 2.0;
    self.circleView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.75].CGColor;
    self.circleView.layer.borderWidth = 1.0;
    
    [self configureCirclePanGesture];
}

-(void)configureCirclePanGesture
{
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(didPan:)];
    [self.circleView addGestureRecognizer:pan];
}



#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _origCircleBottomSpaceConstant = self.circleBottomSpaceConstraint.constant;
    
    [self configureCircleView];
    [self configureProvider];
}

@end
