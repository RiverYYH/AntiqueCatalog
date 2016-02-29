//
//  AntiqueCatalogData.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AntiqueCatalogData : NSObject

@property (nonatomic,copy)NSString *ID;//图录id
@property (nonatomic,copy)NSString *cover;//图录的缩略图
@property (nonatomic,copy)NSString *name;//图录名称
@property (nonatomic,copy)NSString *v_stime;//拍卖图录预展开始时间
@property (nonatomic,copy)NSString *v_ntime;//拍卖图录预展结束时间
@property (nonatomic,copy)NSString *v_address;//预展地址
@property (nonatomic,copy)NSString *info;//图录简介
@property (nonatomic,copy)NSString *uname;//出版机构名称
@property (nonatomic,copy)NSString *type;//类型，0为拍卖，1为艺术

-(AntiqueCatalogData *)initWithTypeListDataDic:(NSDictionary *)dic;

+(AntiqueCatalogData *)WithTypeListDataDic:(NSDictionary *)dic;

@end
