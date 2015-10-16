//
//  SSBaseRequest.m
//  ShiShangLife
//
//  Created by VickyCao on 9/30/15.
//  Copyright © 2015 VickyCao. All rights reserved.
//

#import "SSBaseRequest.h"
#import "AFNetworking.h"
#import "DTInit.h"

Class object_getClass(id object);

@interface SSBaseRequest() {
    Class afOrinClass;
}

@property(nonatomic,strong)AFHTTPRequestOperationManager *manager; //AF请求对象
@property(nonatomic,weak)id<InitDataDelegate> delegate;

@end

@implementation SSBaseRequest

- (id)initWithDelegate:(id)delegate
{
    if ((self = [super init])) {
        afOrinClass = object_getClass(delegate);
        [self setDelegate:delegate];
        [self setDefault];
    }
    
    return self;
}

/**
 * 初始化设置
 */
- (void)setDefault
{
    self.baseUrl = @"http://122.13.81.103:2560";

    /*
    //载入系统配置
    NSDictionary *cfgDic = [NSDictionary dictionaryWithContentsOfFile:@"Config.plist"];
    //API地址
    [self setBaseUrl:[cfgDic objectForKey:@"apiUrl"]];
    
    //代理HOST
    if (![[cfgDic objectForKey:@"apiHost"] isEqualToString:@""]) {
        
        [self setHost:[cfgDic objectForKey:@"apiHost"]];
        
        //重置API地址(测试用)
        [self setBaseUrl:[NSString stringWithFormat:@"http://%@", self.host]];
    }else{
        [self setHost:nil];
    }
    
    //代理port
    [self setPort:[[cfgDic objectForKey:@"apiPort"] intValue]];
     */
}


- (void)httpInit {
    //应用配置文件
    self.manager = [AFHTTPRequestOperationManager manager];
    //申明返回的结果是JSON类型
    self.manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //如果报接受类型不一致请替换一致text/html
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    //清求时间设置
    self.manager.requestSerializer.timeoutInterval = 30;
}


/**
 * 添加header头信息
 */
- (void)addRequestHeader
{
    //当前应用版块号
    [self.manager.requestSerializer setValue:[NSString stringWithFormat:@"%d", CLIENT_VERSION] forHTTPHeaderField:@"KY-VERSION"];
}

/**
 * 发送get请求
 */
- (void)startGet:(NSString*)uri tag:(int *)tag
{
    [self httpInit];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",self.baseUrl,uri]);
    [self.manager GET:[NSString stringWithFormat:@"%@%@",self.baseUrl,[self getUriWithTime:uri]] parameters:nil success:^(AFHTTPRequestOperation *operation,id responseObject) {
//        [self requestFinished:responseObject tag:tag];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self requestFailed:tag];
    }];
}

- (AFHTTPRequestOperation *)cacheOperationWithRequest:(NSURLRequest *)urlRequest
                                           requestKey:(NSURLRequest *)aRequestKey
                                                  tag:(int *)tag
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
{
    AFHTTPRequestOperation *afOperation = [self.manager HTTPRequestOperationWithRequest:urlRequest success:^(AFHTTPRequestOperation *operation, id responseObject){
        
        NSCachedURLResponse *cachedURLResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:aRequestKey];
        cachedURLResponse = [[NSCachedURLResponse alloc] initWithResponse:operation.response data:operation.responseData userInfo:nil storagePolicy:NSURLCacheStorageAllowed];
        
        [[NSURLCache sharedURLCache] storeCachedResponse:cachedURLResponse forRequest:aRequestKey];
        success(operation,responseObject);
    }failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if (error.code == kCFURLErrorNotConnectedToInternet) {
            NSCachedURLResponse *cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:aRequestKey];
            if (cachedResponse != nil && [[cachedResponse data] length] > 0) {
                NSDictionary *cachedDic = [NSJSONSerialization JSONObjectWithData:[cachedResponse data] options:NSJSONReadingMutableContainers error:nil];
                success(operation, cachedDic);
            } else {
                failure(operation, error);
            }
        } else {
            failure(operation, error);
        }
    }];
    
    return afOperation;
}

/**
 * GET请求添加时间戳添加
 */
- (NSString *)getUriWithTime:(NSString *)aUriString
{
    UInt64 recordTime = [[NSDate date] timeIntervalSince1970]*1000;
    
    //改变Uri并添加时间戳
    if([aUriString rangeOfString:@"?"].location !=NSNotFound){
        return [aUriString stringByAppendingString:[NSString stringWithFormat:@"&_t=%llu", recordTime]];
    }else{
        return [aUriString stringByAppendingString:[NSString stringWithFormat:@"?_t=%llu", recordTime]];
    }
}

/**
 * 获取UserAgent信息(放在afnetworking框架执行
 */
- (NSString *)getUserAgent
{
    NSString *appVer     = [[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"];
    NSString *iosVer     = [UIDevice currentDevice].systemVersion ;
    NSString *deviceName = [[UIDevice currentDevice] model];
    
    return [NSString stringWithFormat:@"KaoYanBang AipBot/1.0 (KaoYanClub-IOS/%@;ios/%@;%@)", appVer, iosVer, deviceName];
}

/**
 * 发送getCache请求
 */
- (void)startCache:(NSString *)aCacheName cacheTime:(NSInteger)aTime uri:(NSString *)uri tag:(int *)tag
{
    [self httpInit];
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:[NSString stringWithFormat:@"%@%@",self.baseUrl,[self getUriWithTime:uri]] parameters:nil error:nil];
    
    [request setTimeoutInterval:30];
    [request setCachePolicy:NSURLRequestUseProtocolCachePolicy];
    
    //当前应用版块号
    [request setValue:[NSString stringWithFormat:@"%d", CLIENT_VERSION] forHTTPHeaderField:@"KY-VERSION"];
    
    //设置UserAgent
    [request setValue:[self getUserAgent] forHTTPHeaderField:@"USER-AGENT"];
    
    //当前应用
//    [request setValue:[NSString stringWithFormat:@"%@", [UserDataRequest singleton].token] forHTTPHeaderField:@"KY-TOKEN"];
    
    //请求成功Block块
    void (^requestSuccessBlock)(AFHTTPRequestOperation *operation, id responseObject) = ^(AFHTTPRequestOperation *operation, id responseObject) {
        
//        [self requestFinished:responseObject tag:tag];
    };
    
    //请求失败Block块
    void (^requestFailureBlock)(AFHTTPRequestOperation *operation, NSError *error) = ^(AFHTTPRequestOperation *operation, NSError *error){
        
//        [self requestFailed:tag];
    };
    
    //根据url生成cache数据
    NSURLRequest *aRequestKey = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",self.baseUrl,uri]]];
    
    //请求数据
    AFHTTPRequestOperation *operation = [self cacheOperationWithRequest:request requestKey:aRequestKey tag:tag success:requestSuccessBlock failure:requestFailureBlock];
    [self.manager.operationQueue addOperation:operation];
}

/**
 * 获取缓存数据
 */
- (id)cachedResponseObject:(AFHTTPRequestOperation *)operation{
    
    NSCachedURLResponse* cachedResponse = [[NSURLCache sharedURLCache] cachedResponseForRequest:operation.request];
    AFHTTPResponseSerializer* serializer = [AFJSONResponseSerializer serializer];
    id responseObject = [serializer responseObjectForResponse:cachedResponse.response data:cachedResponse.data error:nil];
    return responseObject;
}

/**
 * 发送post请求
 */
- (void)startPost:(NSString*)uri params:(NSDictionary*)params tag:(int *)tag
{
    [self httpInit];
    NSLog(@"%@",[NSString stringWithFormat:@"%@%@",self.baseUrl,uri]);
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    [self.manager POST:[NSString stringWithFormat:@"%@%@",self.baseUrl,uri] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.delegate getFinished:responseObject tag:tag];
//        [self requestFinished:responseObject tag:tag];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self requestFailed:tag];
        [self.delegate getError:@{@"error":@"aaa"} tag:tag];
    }];
}


@end
