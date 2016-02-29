//
//  CatalogCategorydata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "CatalogCategorydata.h"

@implementation CatalogCategorydata

-(CatalogCategorydata *)initWithCatalogCategoryDataDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        self.ID = dic[@"id"];
        self.title = dic[@"title"];
    }
    return self;
    
}

+(CatalogCategorydata *)WithCatalogCategoryDataDic:(NSDictionary *)dic{
    
    CatalogCategorydata *catalogcategory = [[CatalogCategorydata alloc]initWithCatalogCategoryDataDic:dic];
    return catalogcategory;
}

@end
