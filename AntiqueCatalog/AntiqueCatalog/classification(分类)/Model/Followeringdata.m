//
//  Followeringdata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "Followeringdata.h"

@implementation Followeringdata
-(Followeringdata *)initWithFolloweringdataDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        self.uid = dic[@"uid"];
        self.avatar = dic[@"avatar"];
        self.uname = dic[@"uname"];
        self.intro = dic[@"intro"];
    }
    return self;
    
}

+(Followeringdata *)WithFolloweringdataDic:(NSDictionary *)dic{
    
    Followeringdata *catalogcategory = [[Followeringdata alloc]initWithFolloweringdataDic:dic];
    return catalogcategory;
}
@end
