//
//  Authordata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/15.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "Authordata.h"

@implementation Authordata

-(Authordata *)initWithAuthordataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.uid = dic[@"uid"];
        self.uname = dic[@"uname"];
        
    }
    return self;
    
}

+(Authordata *)WithAuthordataDic:(NSDictionary *)dic{
    
    Authordata *authordata = [[Authordata alloc]initWithAuthordataDic:dic];
    return authordata;
    
}
@end
