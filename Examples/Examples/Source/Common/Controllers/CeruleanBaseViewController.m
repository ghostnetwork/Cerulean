//
//  CeruleanViewController.m
//  Examples
//
//  Created by Keith Ermel on 4/27/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "CeruleanBaseViewController.h"


@interface CeruleanBaseViewController ()
@end


@implementation CeruleanBaseViewController

#pragma mark - Public API
-(void)updateConnectionStatus:(ConnectionStatus)status
{
    dispatch_async(dispatch_get_main_queue(), ^{[self.connectionStatusVC updateConnectionStatus:status];});
}

-(void)updateStatus:(NSString *)text
{
    dispatch_async(dispatch_get_main_queue(), ^{[self.connectionStatusVC updateStatus:text];});
}


#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    _connectionStatus = ConnectionStatusUnknown;
    _commands = [Commands new];
}

@end
