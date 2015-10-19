//
//  LoginViewController.m
//  ShiShangLife
//
//  Created by VickyCao on 10/2/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginRequest.h"
#import "iToast.h"
#import "MBProgressHUD.h"

@interface LoginViewController () {
    IBOutlet UITextField *userNameTextField;
    IBOutlet UITextField *passwordTextField;
    
    IBOutlet UIButton *registerButton;
    IBOutlet UIButton *forgetPWDButton;
}

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"登录";
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
//    [rightButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [rightButton setTitle:@"登录" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(doLogin:)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    [self customButton];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)enterHomeScreen:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
    }];
}

- (IBAction)doLogin:(id)sender {
    if (userNameTextField.text.length == 0) {
        [[iToast makeText:@"请输入用户名"] show];
        return;
    }
    if (passwordTextField.text.length == 0) {
        [[iToast makeText:@"请输入密码"] show];
        return;
    }
    [[LoginRequest singleton] doLogin:@{@"user":userNameTextField.text, @"password":passwordTextField.text} complete:^{
        
    } failded:^(NSString *state, NSString *errmsg) {
        
    }];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
