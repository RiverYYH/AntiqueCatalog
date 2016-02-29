//
//  FootCatalogdata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/26.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "FootCatalogdata.h"

@implementation FootCatalogdata
-(FootCatalogdata*)initWithTypeListDataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        
        self.ID = dic[@"info"][@"id"];
        self.cover = dic[@"info"][@"cover"];
        self.name = dic[@"info"][@"name"];
        self.v_stime = [UserModel formateTime:dic[@"info"][@"v_stime"] andishour:NO];
        self.v_ntime = [UserModel formateTime:dic[@"info"][@"v_ntime"] andishour:NO];
        self.v_address = dic[@"info"][@"v_address"];
        self.info = dic[@"info"][@"info"];
        self.uname = dic[@"info"][@"uname"];
        self.type = dic[@"info"][@"type"];
        self.readtime = [UserModel formateTime:dic[@"ctime"] andishour:YES];
        
    }
    return self;
}

+(FootCatalogdata *)WithTypeListDataDic:(NSDictionary *)dic
{
    FootCatalogdata *antiquecatalogData = [[FootCatalogdata alloc]initWithTypeListDataDic:dic];
    return antiquecatalogData;
}
@end
