//
//  catalogdetailsdata.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/9.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface catalogdetailsdata : NSObject

/**
 *    图录id
 */
@property (nonatomic,copy)NSString *ID;

/**
 *    图录type
 */
@property (nonatomic,copy)NSString *type;

/**
 *    图录封面图
 */
@property (nonatomic,copy)NSString *cover;

/**
 *    图录名称
 */
@property (nonatomic,copy)NSString *name;

/**
 *    阅读量
 */
@property (nonatomic,copy)NSString *view_count;

/**
 *    作者
 */
@property (nonatomic,copy)NSString *author;

/**
 *    预展开始时间
 */
@property (nonatomic,copy)NSString *v_stime;

/**
 *    预展结束时间
 */
@property (nonatomic,copy)NSString *v_ntime;

/**
 *    预展地址
 */
@property (nonatomic,copy)NSString *v_address;

/**
 *    拍卖时间
 */
@property (nonatomic,copy)NSString *stime;

/**
 *    拍卖地址
 */
@property (nonatomic,copy)NSString *address;

/**
 *    简介
 */
@property (nonatomic,copy)NSString *info;

/**
 *    标签数组
 */
@property (nonatomic,strong)NSArray *tag;

/**
 *    机构id
 */
@property (nonatomic,copy)NSString *userInfo_uid;

/**
 *    机构头像
 */
@property (nonatomic,copy)NSString *userInfo_avatar_middle;

/**
 *    机构名称
 */
@property (nonatomic,copy)NSString *userInfo_uname;

/**
 *    是否关注机构
 *    0_未关注,1_关注
 */
@property (nonatomic,assign)BOOL userInfo_following;

/**
 *    评论数组
 */
@property (nonatomic,strong)NSArray *comment;

/**
 *    本机构更多图录
 */
@property (nonatomic,strong)NSArray *userInfo_moreCatalog;

/**
 *    其他更多图录
 */
@property (nonatomic,strong)NSArray *moreCatalog;


-(catalogdetailsdata *)initWithcatalogdetailsdataDataDic:(NSDictionary *)dic;

+(catalogdetailsdata *)WithcatalogdetailsdataDataDic:(NSDictionary *)dic;

@end
