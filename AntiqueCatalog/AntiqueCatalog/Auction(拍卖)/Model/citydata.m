//
//  citydata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/15.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "citydata.h"

@implementation citydata

-(citydata *)initWithcitydataDic:(NSDictionary *)dic{
    self = [super init];
    if (self) {
        self.area_id = dic[@"area_id"];
        self.title = dic[@"title"];
    }
    return self;
}

+(citydata *)WithcitydataDic:(NSDictionary *)dic{
    citydata *cityData = [[citydata alloc]initWithcitydataDic:dic];
    return cityData;
}
@end
