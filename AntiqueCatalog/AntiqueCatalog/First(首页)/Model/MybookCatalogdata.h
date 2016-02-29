//
//  MybookCatalogdata.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/8.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MybookCatalogdata : NSObject
/**
 *    图录id
 */
@property (nonatomic,copy)NSString *ID;

/**
 *    图录封面图
 */
@property (nonatomic,copy)NSString *cover;

/**
 *    图录名称
 */
@property (nonatomic,copy)NSString *name;

/**
 *    rtime,最后阅读时间
 */
@property (nonatomic,copy)NSString *rtime;

-(MybookCatalogdata *)initWithMybookCatalogDataDic:(NSDictionary *)dic;

+(MybookCatalogdata *)WithMybookCatalogDataDic:(NSDictionary *)dic;
@end
