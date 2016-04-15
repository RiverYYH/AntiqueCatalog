//
//  MybookCatalogdata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/8.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "MybookCatalogdata.h"

@implementation MybookCatalogdata

-(MybookCatalogdata *)initWithMybookCatalogDataDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        
        self.ID = dic[@"info"][@"id"];
        self.cover = dic[@"info"][@"cover"];
        self.name = dic[@"info"][@"name"];
        self.type = dic[@"info"][@"type"];

        
    }
    return self;
    
}

+(MybookCatalogdata *)WithMybookCatalogDataDic:(NSDictionary *)dic{
    
    MybookCatalogdata *mybookCatalogData = [[MybookCatalogdata alloc]initWithMybookCatalogDataDic:dic];
    return mybookCatalogData;
    
}

@end
