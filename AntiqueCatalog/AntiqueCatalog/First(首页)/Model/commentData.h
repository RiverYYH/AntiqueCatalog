//
//  commentData.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/11.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface commentData : NSObject

/**
 *    评论id
 */
@property (nonatomic,copy)NSString *ID;

/**
 *    评论人id
 */
@property (nonatomic,copy)NSString *userInfo_uid;

/**
 *    评论人名字
 */
@property (nonatomic,copy)NSString *userInfo_uname;

/**
 *    评论人头像
 */
@property (nonatomic,copy)NSString *userInfo_avatar_middle;

/**
 *    评论ctime（时间）
 */
@property (nonatomic,copy)NSString *ctime;

/**
 *    评论个数
 */
@property (nonatomic,copy)NSString *comment_count;

/**
 *    评论赞的个数
 */
@property (nonatomic,copy)NSString *digg_count;

/**
 *    评论内容
 */
@property (nonatomic,copy)NSString *content;

/**
 *    是否赞过
 */
@property (nonatomic,assign)BOOL is_digg;


-(commentData *)initWithcommentDataDic:(NSDictionary *)dic;

+(commentData *)WithcommentDataDic:(NSDictionary *)dic;


@end
