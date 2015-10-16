//
//  SSBaseRequest.h
//  ShiShangLife
//
//  Created by VickyCao on 9/30/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSString+MD5.h"

/**
 请求完成处理
 */
typedef void (^Complete)();

/**
 请求失败处理
 */
typedef void (^Failed)(NSString *state,NSString *errmsg);

#define DTKEY @"09e09b3b4c037edca36b1075dcbc24f5"

@interface SSBaseRequest : NSObject {
    Complete _complete; //请求完成
    Failed   _failed;   //请求失败
}

//HTTP参数设置
@property(nonatomic,strong)NSString         *baseUrl;       //API基础地址
@property(nonatomic,strong)NSString         *host;          //代理主机IP地址
@property(nonatomic,assign)NSInteger        port;           //代理主机端口

@property(nonatomic,strong)NSString         *errCode;       //错误代码
@property(nonatomic,strong)NSString         *errMsg;        //错误描述
@property(nonatomic,strong)NSString         *version;       //协议版本(客户端兼容最小版本)

- (id)initWithDelegate:(id)delegate;
/**
 * 发送get请求
 */
- (void)startGet:(NSString*)url tag:(int *)tag;

/**
 * 发送getCache请求
 */
- (void)startCache:(NSString *)aCacheName cacheTime:(NSInteger)aTime uri:(NSString *)uri tag:(int *)tag;

/**
 * 发送post请求
 */
- (void)startPost:(NSString*)url params:(NSDictionary*)params tag:(int *)tag;

@end

#pragma mark delegate
@protocol InitDataDelegate <NSObject>
@optional
/**
 请求完成时-调用
 */
-(void)getFinished:(NSDictionary *)msg tag:(int *)tag;

/**
 请求失败时-调用
 */
-(void)getError:(NSDictionary *)msg tag:(int *)tag;

@end