//
//  Api.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "Api.h"
#import "JWLoadView.h"
#import "NetWorkClient.h"
#import "UserModel.h"
#import "NetWorkClientOne.h"
#import "SGInfoAlert.h"

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
    NSString * oauthToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"oauth_token"];
    NSString * oauthTokenSecret = [[NSUserDefaults standardUserDefaults] stringForKey:@"oauth_token_secret"];
    if (oauthToken.length == 0 || oauthTokenSecret == 0) {
        [mutableDic setValue:Oauth_token forKey:@"oauth_token"];
        [mutableDic setValue:Oauth_token_secret forKey:@"oauth_token_secret"];

    }else{
        [mutableDic setValue:oauthToken forKey:@"oauth_token"];
        [mutableDic setValue:oauthTokenSecret forKey:@"oauth_token_secret"];
    }

    
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

+ (void)requestWithMethod:(NSString*)method
                 withPath:(NSString*)path
               withParams:(NSDictionary*)params
              withSuccess:(void (^)(id responseObject))success
                withError:(void (^)(NSError* error))failed
{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDictionary *passport = [UserModel userPassport];
    [mutableDic setValue:[passport objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [mutableDic setValue:[passport objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    if ([[method lowercaseString] isEqualToString:@"get"])
    {
        [[NetWorkClientOne sharedClient] GET:path parameters:mutableDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
        }];
    }
    else if ([[method lowercaseString] isEqualToString:@"post"])
    {
        [[NetWorkClientOne sharedClient] POST:path parameters:mutableDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
        }];
    }
}

+ (void)showLoadMessage:(NSString *)message{
    
    [[JWLoadView sharedJWLoadView] showMessage:message];
    
}

+ (void)hideLoadHUD{
    
    [UIView animateWithDuration:0.2 animations:^{
        [[JWLoadView sharedJWLoadView] dismiss];
    }];
}

+ (void)endClient
{
    [[NetWorkClient sharedClient].operationQueue cancelAllOperations];
}
+(void)alert4:(NSString *)message inView:(UIView *)view offsetY:(CGFloat)yOffset{
    [[SGInfoAlert alert] showInfo:message
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:view
                          offsetY:yOffset
                         showTime:2.0f
                         fontSize:16.0f];
}

@end
