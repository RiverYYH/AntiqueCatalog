//
//  CatalogCategorydata.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CatalogCategorydata : NSObject

/**
 *    分类id
 */
@property (nonatomic,copy)NSString *ID;
/**
 *    分类名称
 */
@property (nonatomic,copy)NSString *title;

-(CatalogCategorydata *)initWithCatalogCategoryDataDic:(NSDictionary *)dic;

+(CatalogCategorydata *)WithCatalogCategoryDataDic:(NSDictionary *)dic;

@end
