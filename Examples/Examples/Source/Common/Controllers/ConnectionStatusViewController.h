//
//  ConnectionStatusViewController.h
//  Examples
//
//  Created by Keith Ermel on 4/27/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Examples-Swift.h"


@interface ConnectionStatusViewController : UIViewController
-(void)updateConnectionStatus:(ConnectionStatus)status;
-(void)updateStatus:(NSString *)text;
@end
