//
//  CatalogGetList.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/22.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogGetList : NSObject

/**
 *    判断图录类型，0是拍卖图录，1是艺术图录
 */
@property (nonatomic,assign)NSInteger type;

/**
 *    标题
 */
@property (nonatomic,copy)NSString *title;

/**
 *    简介
 */
@property (nonatomic,copy)NSString *info;

/**
 *    list
 */
@property (nonatomic,strong)NSArray *list;


-(CatalogGetList *)initWithCatalogGetListDic:(NSDictionary *)dic;

+(CatalogGetList *)WithCatalogGetListDic:(NSDictionary *)dic;
@end
