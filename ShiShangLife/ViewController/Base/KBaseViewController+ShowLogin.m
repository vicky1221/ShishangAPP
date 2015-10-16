//
//  KBaseViewController+ShowLogin.m
//  ShiShangLife
//
//  Created by VickyCao on 10/2/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "KBaseViewController+ShowLogin.h"

@implementation KBaseViewController (ShowLogin)

//弹出登陆页
-(void)showLoginVC
{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *loginNav = [sb instantiateViewControllerWithIdentifier:@"loginNavi"];
    [self presentViewController:loginNav animated:YES completion:nil];
}

@end
