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
        [iToast makeText:@"请输入手机号"];
        return;
    }
    [[LoginRequest singleton] sendVertifyCode:phoneNumberTextField.text complete:^{
        [[iToast makeText:@"验证码已发送"] show];
    } failed:^(NSString *state, NSString *errmsg) {
        [[iToast makeText:errmsg] show];
    }];
}

- (void)resetPWD {
    
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
