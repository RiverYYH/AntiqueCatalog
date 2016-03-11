//
//  UserModel.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/5.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
/**
 *    存储用户uid,oauthToken,oauthTokenSecret,信息,并将uname单独存储为上次成功登录用户
 *
 */

+ (void)saveUserPassportWithdic:(NSDictionary *)dic;

/**
 *    存储用户个人信息
 *
 */

+ (void)saveUserInformationWithdic:(NSDictionary *)dic;

/**
 *    读取用户uid,oauthToken,oauthTokenSecret,avatar信息
 *
 */

+ (NSDictionary *)userPassport;

/**
 *    读取用户个人信息
 *
 */

/**
 *  获取用户登录方式
 *
 *  @return 返回NSString类型的登录方式
 */
+ (NSString *)userLoginType;

//读取用户uname
+ (NSString *)userUname;

+ (NSDictionary *)userUserInfor;

//清除用户uid,oauthToken,oauthTokenSecret信息
+ (void)deleteUserPassport;

/**
 *    判断是否登录状态
 *
 */

+ (BOOL)checkLogin;

//时间戳转化为字符串
+ (NSString *)formateTime:(NSString *)time andishour:(BOOL)ishour;
//时间字符串转成时间戳
+ (NSString *)toformateTime:(NSString *)time;

+ (NSDictionary *)userLocation;
+ (NSString *)formateTime:(NSString *)time;
+ (void)saveUserLoginType:(NSString *)type;
+ (void)saveUserPassportWithUname:(NSString *)uname andUid:(NSString *)uid andToken:(NSString *)token andTokenSecret:(NSString *)tokenSecret andAvatar:(NSString *)avatar;

@end
