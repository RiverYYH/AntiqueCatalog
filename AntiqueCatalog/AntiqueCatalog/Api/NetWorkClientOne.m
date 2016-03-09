//
//  NetWorkClientOne.m
//  AntiqueCatalog
//
//  Created by cssweb on 16/3/9.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "NetWorkClientOne.h"

@implementation NetWorkClientOne
+ (instancetype)sharedClient {
    static NetWorkClientOne *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[NetWorkClientOne alloc] initWithBaseURL:[NSURL URLWithString:HEADURL]];
        _sharedClient.securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    });
    
    return _sharedClient;
}
@end
