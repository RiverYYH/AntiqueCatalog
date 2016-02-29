//
//  AntiqueCatalogData.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "AntiqueCatalogData.h"

@implementation AntiqueCatalogData

-(AntiqueCatalogData*)initWithTypeListDataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.ID = dic[@"id"];
        self.cover = dic[@"cover"];
        self.name = dic[@"name"];
        self.v_stime = [UserModel formateTime:dic[@"v_stime"] andishour:NO];
        self.v_ntime = [UserModel formateTime:dic[@"v_ntime"] andishour:NO];
        self.v_address = dic[@"v_address"];
        self.info = dic[@"info"];
        self.uname = dic[@"uname"];
        self.type = dic[@"type"];
        
    }
    return self;
}

+(AntiqueCatalogData *)WithTypeListDataDic:(NSDictionary *)dic
{
    AntiqueCatalogData *antiquecatalogData = [[AntiqueCatalogData alloc]initWithTypeListDataDic:dic];
    return antiquecatalogData;
}

@end
