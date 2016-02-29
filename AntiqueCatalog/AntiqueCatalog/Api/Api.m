//
//  Api.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "Api.h"

@implementation Api

+ (void)requestWithbool:(BOOL)isuser
             withMethod:(NSString*)method
               withPath:(NSString*)path
             withParams:(NSDictionary*)params
            withSuccess:(void (^)(id responseObject))success
              withError:(void (^)(NSError* error))failed
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:params];
    [mutableDic setValue:Oauth_token forKey:@"oauth_token"];
    [mutableDic setValue:Oauth_token_secret forKey:@"oauth_token_secret"];
    
    if ([[method lowercaseString] isEqualToString:@"get"]){
        
        [[NetWorkClient sharedClient]GET:path parameters:isuser?mutableDic:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });

            
        }];
        
    }
    else if ([[method lowercaseString] isEqualToString:@"post"]){
        
        [[NetWorkClient sharedClient]POST:path parameters:isuser?mutableDic:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
            
        }];
        
    }

    
    
}

@end
