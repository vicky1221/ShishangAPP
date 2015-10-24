//
//  ForgetPWDViewController.m
//  ShiShangLife
//
//  Created by VickyCao on 10/2/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "ForgetPWDViewController.h"
#import "LoginRequest.h"
#import "iToast.h"

@interface ForgetPWDViewController () {
    IBOutlet UITextField *phoneNumberTextField;
    IBOutlet UITextField *codeTextField;
    IBOutlet UITextField *passwordTextField;
    BOOL isShowPWD;
}

@end

@implementation ForgetPWDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *rightButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    //    [rightButton setImage:[UIImage imageNamed:@"search.png"] forState:UIControlStateNormal];
    [rightButton setTitle:@"登录" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(resetPWD)forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem= rightItem;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)sendCode:(id)sender {
    if (phoneNumberTextField.text.length == 0) {
        [[iToast makeText:@"请输入手机号"] show];
        return;
    }
    [[LoginRequest singleton] sendVertifyCode:phoneNumberTextField.text complete:^{
        [[iToast makeText:@"验证码已发送"] show];
    } failed:^(NSString *state, NSString *errmsg) {
        [[iToast makeText:errmsg] show];
    }];
}

- (IBAction)showPWD:(id)sender {
    passwordTextField.secureTextEntry = isShowPWD;
    isShowPWD = !isShowPWD;
}

- (void)resetPWD {
    if (passwordTextField) {
        // 说明是重置密码
        if (passwordTextField.text.length==0) {
            [[iToast makeText:@"请输入新密码"] show];
            return;
        }
        
        return;
    }
    if (phoneNumberTextField.text.length == 0) {
        [[iToast makeText:@"请输入手机号"] show];
        return;
    }
    if (codeTextField.text.length == 0) {
        [[iToast makeText:@"请输入验证码"] show];
        return;
    }
    [[LoginRequest singleton] checkVertifyCode:phoneNumberTextField.text code:codeTextField.text complete:^{
        [self performSegueWithIdentifier:@"resetpwd" sender:self];
    } failed:^(NSString *state, NSString *errmsg) {
        
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
