//
//  HomeViewController.m
//  ShiShangLife
//
//  Created by VickyCao on 10/2/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "HomeViewController.h"
#import "KBaseViewController+ShowLogin.h"

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showLoginVC];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

@end
