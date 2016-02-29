//
//  catalogdetailsCollectiondata.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface catalogdetailsCollectiondata : NSObject

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

/**
 *    图录类型
 */
@property (nonatomic,copy)NSString *type;

-(catalogdetailsCollectiondata *)initWithbookCatalogDataDic:(NSDictionary *)dic;

+(catalogdetailsCollectiondata *)WithbookCatalogDataDic:(NSDictionary *)dic;

@end
