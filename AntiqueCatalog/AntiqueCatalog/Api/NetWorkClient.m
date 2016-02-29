//
//  NetWorkClient.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "NetWorkClient.h"

@implementation NetWorkClient

+ (instancetype)sharedClient {
    static NetWorkClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        _sharedClient = [[NetWorkClient alloc] initWithBaseURL:[NSURL URLWithString:HEADURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
//        _sharedClient.requestSerializer = [AFHTTPRequestSerializer serializer];
//        _sharedClient.responseSerializer = [AFHTTPResponseSerializer serializer];// 响应
    });
    
    return _sharedClient;
}

@end
