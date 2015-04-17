//
//  SubscriptionViewController.m
//  Examples
//
//  Created by Keith Ermel on 4/16/15.
//  Copyright (c) 2015 Keith Ermel. All rights reserved.
//

#import "SubscriptionViewController.h"


@interface SubscriptionViewController ()

// Outlets
@property (weak, nonatomic) IBOutlet UIView *centeringView;
@end


@implementation SubscriptionViewController

#pragma mark - View Lifecycle
-(void)viewDidLoad
{
    [super viewDidLoad];
    
    self.centeringView.layer.cornerRadius = self.centeringView.bounds.size.width / 2.0;
}

@end
