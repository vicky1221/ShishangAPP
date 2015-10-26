//
//  RegisterViewController2.m
//  ShiShangLife
//
//  Created by VickyCao on 10/19/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "RegisterViewController2.h"
#import "LoginRequest.h"
#import "iToast.h"

@interface RegisterViewController2() {
    IBOutlet UITextField *codeTextField;
    IBOutlet UITextField *paswordTextField;
    IBOutlet UITextField *userNameTextField;
}

@end

@implementation RegisterViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 右边按钮
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    //    [rightButton setTitle:@"登录" forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"done"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(sendRegisterInfo)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    self.navigationItem.rightBarButtonItem= rightItem;
}

- (void)sendRegisterInfo {
    if (codeTextField.text.length == 0) {
        [[iToast makeText:@"请输入验证码"] show];
        return;
    }
    if (paswordTextField.text.length == 0) {
        [[iToast makeText:@"请输入密码"] show];
        return;
    }
    if (userNameTextField.text.length == 0) {
        [[iToast makeText:@"请输入用户名"] show];
        return;
    }
    [[LoginRequest singleton] registerUser:self.phoneNumber password:paswordTextField.text code:codeTextField.text userName:userNameTextField.text complete:^{
        [[iToast makeText:@"注册成功"] show];
        [self.navigationController popToRootViewControllerAnimated:YES];
    } failed:^(NSString *state, NSString *errmsg) {
        [[iToast makeText:errmsg] show];
    }];
}

@end
