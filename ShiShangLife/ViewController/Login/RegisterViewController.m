//
//  RegisterViewController.m
//  ShiShangLife
//
//  Created by VickyCao on 10/2/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "RegisterViewController.h"
#import "LoginRequest.h"

@interface RegisterViewController () {
    IBOutlet UITextField *phoneTextField;
}

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)getVertifycode:(id)sender {
    if (phoneTextField.text.length == 0) {
        return;
    }
    [[LoginRequest singleton] sendVertifyCode:phoneTextField.text complete:^{
        
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
