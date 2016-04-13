//
//  AddFolloweringdata.h
//  AntiqueCatalog
//
//  Created by CssWeb on 16/4/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AddFolloweringdata : NSObject
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
/**
 *    是否已关注
 */
@property (nonatomic) BOOL follow;

-(AddFolloweringdata *)initWithFolloweringdataDic:(NSDictionary *)dic;

+(AddFolloweringdata *)WithFolloweringdataDic:(NSDictionary *)dic;

@end
