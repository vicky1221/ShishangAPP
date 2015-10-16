//
//  LoginRequest.m
//  ShiShangLife
//
//  Created by VickyCao on 10/9/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "LoginRequest.h"

@implementation LoginRequest

static int dologin;
static int dovertify;
static int checkvertify;
static int doregister;

- (id)init
{
    self  = [super initWithDelegate:self];
    if (self) {
//        self.examReport = [[ExamReportData alloc] init];
//        self.examReport.configArray = [NSMutableArray array];
    }
    return self;
}

+ (instancetype)singleton {
    static dispatch_once_t onceToken;
    static LoginRequest *instance;
    dispatch_once(&onceToken, ^{
        instance = [[LoginRequest alloc] init];
    });
    
    return instance;
}

/**
 *  登陆
 */
- (void)doLogin:(NSDictionary *)loginDic complete:(Complete)complete failded:(Failed)failed {
    _complete = complete;
    _failed = failed;
    NSString *uri = [NSString stringWithFormat:@"/User/Login"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:loginDic];
    dic[@"sign"] = [[NSString stringWithFormat:@"%@%@%@",loginDic[@"user"], loginDic[@"password"], DTKEY] MD5Digest];
    [self startPost:uri params:dic tag:&dologin];
}

/**
 *  发送验证码
 */
- (void)sendVertifyCode:(NSString *)phoneNum complete:(Complete)complete failed:(Failed)failed {
    _complete = complete;
    _failed = failed;
    NSString *uri = [NSString stringWithFormat:@"/User/GainCode"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = phoneNum;
    dic[@"sign"] = [[NSString stringWithFormat:@"%@%@", phoneNum, DTKEY] MD5Digest];
    [self startPost:uri params:dic tag:&dovertify];
}

/**
 *  验证验证码
 */
- (void)checkVertifyCode:(NSString *)phoneNum code:(NSString *)code complete:(Complete)complete failed:(Failed)failed {
    _complete = complete;
    _failed = failed;
    NSString *uri = [NSString stringWithFormat:@"/User/CheckCode"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = phoneNum;
    dic[@"code"] = code;
    dic[@"sign"] = [[NSString stringWithFormat:@"%@%@%@", phoneNum, code, DTKEY] MD5Digest];
    [self startPost:uri params:dic tag:&checkvertify];
}

/**
 *  注册
 */
- (void)registerUser:(NSString *)phoneNum password:(NSString *)password code:(NSString *)code complete:(Complete)complete failed:(Failed)failed {
    _complete = complete;
    _failed = failed;
    NSString *uri = [NSString stringWithFormat:@"/User/CheckCode"];
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    dic[@"phone"] = phoneNum;
    dic[@"password"] = password;
    dic[@"code"] = code;
    dic[@"sign"] = [[NSString stringWithFormat:@"%@%@%@%@", phoneNum, password, code, DTKEY] MD5Digest];
    [self startPost:uri params:dic tag:&doregister];
}

-(void)getFinished:(NSDictionary *)msg tag:(int *)tag {
    
}

/**
 请求失败时-调用
 */
-(void)getError:(NSDictionary *)msg tag:(int *)tag {
    
}

@end
