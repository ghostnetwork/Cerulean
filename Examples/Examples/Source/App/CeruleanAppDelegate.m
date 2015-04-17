//
//  CeruleanAppDelegate.m
//  Examples - Cerulean
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "CeruleanAppDelegate.h"


@interface CeruleanAppDelegate ()
@end


@implementation CeruleanAppDelegate

#pragma mark - Public API
+(CeruleanAppDelegate *)appDelegate {return (CeruleanAppDelegate *)[UIApplication sharedApplication].delegate;}


#pragma mark - Configuration
-(void)configureIdentifiers
{
    _subscriptionServiceID = @"36DFD93B-34B9-417A-97E2-64895638FE0D";
    _subscriptionCurrentTimeID = @"6AD17B73-98A4-4093-B801-6F36601A6E07";
}


#pragma mark - Application Lifecycle
-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [self configureIdentifiers];
    return YES;
}

-(void)applicationWillResignActive:(UIApplication *)application {}
-(void)applicationDidEnterBackground:(UIApplication *)application {}
-(void)applicationWillEnterForeground:(UIApplication *)application {}
-(void)applicationDidBecomeActive:(UIApplication *)application {}
-(void)applicationWillTerminate:(UIApplication *)application {}

@end
