//
//  CeruleanAppDelegate.h
//  Examples - Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface CeruleanAppDelegate : UIResponder <UIApplicationDelegate>
@property (strong, nonatomic) UIWindow *window;
@property (copy, readonly) NSString *subscriptionServiceID;
@property (copy, readonly) NSString *subscriptionCurrentTimeID;

+(CeruleanAppDelegate *)appDelegate;
@end

