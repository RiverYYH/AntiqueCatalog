//
//  catalogdetailsCollectiondata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "catalogdetailsCollectiondata.h"

@implementation catalogdetailsCollectiondata

-(catalogdetailsCollectiondata *)initWithbookCatalogDataDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        
        self.ID = dic[@"id"];
        self.cover = dic[@"cover"];
        self.name = dic[@"name"];
        self.type = dic[@"type"];
        
        
    }
    return self;
    
}

+(catalogdetailsCollectiondata *)WithbookCatalogDataDic:(NSDictionary *)dic{
    
    catalogdetailsCollectiondata *bookCatalogData = [[catalogdetailsCollectiondata alloc]initWithbookCatalogDataDic:dic];
    return bookCatalogData;
    
}
@end
