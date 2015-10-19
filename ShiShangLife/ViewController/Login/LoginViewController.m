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
    BOOL isShowPWD;
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

- (void)customButton {
    NSString *registerStr = @"没有账号？现在注册";
    NSMutableAttributedString *registerAttributString = [[NSMutableAttributedString alloc] initWithString:registerStr];
    [registerAttributString addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(registerStr.length - 2, 2)];
    [registerAttributString addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:NSMakeRange(registerStr.length - 2, 2)];
    [registerButton setTitle:registerStr forState:UIControlStateNormal];
    registerButton.titleLabel.attributedText = registerAttributString;
    
    NSAttributedString *forgetPWDAttribute = [[NSAttributedString alloc] initWithString:@"忘记密码" attributes:@{NSUnderlineStyleAttributeName:[NSNumber numberWithInteger:NSUnderlineStyleSingle]}];
    forgetPWDButton.titleLabel.attributedText = forgetPWDAttribute;
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
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    } failded:^(NSString *state, NSString *errmsg) {
        [[iToast makeText:errmsg] show];
    }];
}

- (IBAction)showPassword:(id)sender {
    isShowPWD = !isShowPWD;
    passwordTextField.secureTextEntry = isShowPWD;
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
