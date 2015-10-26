//
//  LoginRequest.h
//  ShiShangLife
//
//  Created by VickyCao on 10/9/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "SSBaseRequest.h"

@interface LoginRequest : SSBaseRequest

+ (instancetype)singleton;
- (void)doLogin:(NSDictionary *)loginDic complete:(Complete)complete failded:(Failed)failed;
- (void)sendVertifyCode:(NSString *)phoneNum complete:(Complete)complete failed:(Failed)failed;
- (void)checkVertifyCode:(NSString *)phoneNum code:(NSString *)code complete:(Complete)complete failed:(Failed)failed;
- (void)registerUser:(NSString *)phoneNum password:(NSString *)password code:(NSString *)code userName:(NSString *)username complete:(Complete)complete failed:(Failed)failed;

@end
