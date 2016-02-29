//
//  CatalogGetList.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/22.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "CatalogGetList.h"

@implementation CatalogGetList

-(CatalogGetList *)initWithCatalogGetListDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        
        self.type = [[dic objectForKey:@"type"] integerValue];
        
        self.list = dic[@"list"];
    }
    return self;
}

+(CatalogGetList *)WithCatalogGetListDic:(NSDictionary *)dic{
    
    CatalogGetList *cataloggetlist = [[CatalogGetList alloc]initWithCatalogGetListDic:dic];
    return cataloggetlist;
    
}

@end
