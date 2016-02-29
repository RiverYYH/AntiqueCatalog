//
//  Followeringdata.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Followeringdata : NSObject

/**
 *    用户id
 */
@property (nonatomic,copy)NSString *uid;
/**
 *    用户头像
 */
@property (nonatomic,copy)NSString *avatar;
/**
 *    用户名称
 */
@property (nonatomic,copy)NSString *uname;
/**
 *    用户简介
 */
@property (nonatomic,copy)NSString *intro;

-(Followeringdata *)initWithFolloweringdataDic:(NSDictionary *)dic;

+(Followeringdata *)WithFolloweringdataDic:(NSDictionary *)dic;

@end
