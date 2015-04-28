//
//  ConnectionStatusViewController.m
//  Examples
//
//  Created by Keith Ermel on 4/27/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "ConnectionStatusViewController.h"


@interface ConnectionStatusViewController ()
// Outlets
@property (weak, nonatomic) IBOutlet UIView *indicatorView;
@property (weak, nonatomic) IBOutlet UILabel *connectionStatusLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;
@end


@implementation ConnectionStatusViewController

#pragma mark - Public API
-(void)updateConnectionStatus:(ConnectionStatus)status
{
    UIColor *statusColor = [ConnectionColors colorForStatus:status];
    if (statusColor) {self.indicatorView.backgroundColor = statusColor;}
    [self updateConnectionStatusLabel:status];
}

-(void)updateStatus:(NSString *)text {self.statusLabel.text = text;}


#pragma mark - Internal API
-(void)updateConnectionStatusLabel:(ConnectionStatus)status
{
    NSString *statusString = [self stringForStatus:status];
    self.connectionStatusLabel.text = statusString;
}

-(NSString *)stringForStatus:(ConnectionStatus)status
{
    switch (status) {
        case ConnectionStatusConnected: return @"connected";
        case ConnectionStatusDisconnected: return @"disconnected";
        case ConnectionStatusUnknown: return nil;
        default: return @"?";
    }
}


#pragma mark - Configuration
-(void)configureView
{
    [self configureIndicatorView];
    self.connectionStatusLabel.text = @"";
    self.statusLabel.text = @"";
}

-(void)configureIndicatorView
{
    self.indicatorView.layer.cornerRadius = self.indicatorView.bounds.size.width / 2.0;
    self.indicatorView.layer.borderColor = [[UIColor blackColor] colorWithAlphaComponent:0.75].CGColor;
    self.indicatorView.layer.borderWidth = 1.0;
    self.indicatorView.backgroundColor = [ConnectionColors colorForStatus:ConnectionStatusUnknown];
}


#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    [self configureView];
}

@end
