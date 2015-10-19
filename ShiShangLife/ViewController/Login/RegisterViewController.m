//
//  RegisterViewController.m
//  ShiShangLife
//
//  Created by VickyCao on 10/2/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterViewController2.h"

#import "LoginRequest.h"
#import "iToast.h"
#import "DTInit.h"

@interface RegisterViewController () {
    IBOutlet UITextField *phoneTextField;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [phoneTextField resignFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

// 获取验证码
- (IBAction)getVertifycode:(id)sender {
    if (phoneTextField.text.length == 0) {
        [[iToast makeText:@"手机号不能为空"] show];
        return;
    }
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", isPhoneNumber];
    BOOL isValid = [predicate evaluateWithObject:phoneTextField.text];
    
    if (!isValid) {
        [[iToast makeText:@"请输入正确的电话号码"] show];
        return;
    }
    [[LoginRequest singleton] sendVertifyCode:phoneTextField.text complete:^{
        [[iToast makeText:@"验证码发送成功"] show];
        [self performSegueWithIdentifier:@"doRegister" sender:self];
    } failed:^(NSString *state, NSString *errmsg) {
        [[iToast makeText:errmsg] show];
    }];
    
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.
    RegisterViewController2 *registerVC2 = [segue destinationViewController];
    registerVC2.phoneNumber = phoneTextField.text;
}


@end
