//
//  CeruleanViewController.h
//  Examples
//
//  Created by Keith Ermel on 4/27/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Examples-Swift.h"
#import "Commands.h"
#import "ConnectionStatusViewController.h"


@interface CeruleanBaseViewController : UIViewController
@property (strong, nonatomic) ConnectionStatusViewController *connectionStatusVC;
@property (strong, readonly) Commands *commands;
@property (nonatomic, readonly) ConnectionStatus *connectionStatus;

-(void)updateConnectionStatus:(ConnectionStatus)status;
-(void)updateStatus:(NSString *)text;
@end
