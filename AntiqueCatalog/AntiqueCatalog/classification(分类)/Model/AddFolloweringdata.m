//
//  AddFolloweringdata.m
//  AntiqueCatalog
//
//  Created by CssWeb on 16/4/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "AddFolloweringdata.h"

@implementation AddFolloweringdata

-(AddFolloweringdata *)initWithFolloweringdataDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        if(![dic[@"uid"] isKindOfClass:[NSNull class]]){
            self.uid = dic[@"uid"];
        }
        if(![dic[@"intro"] isKindOfClass:[NSNull class]]){
            self.intro = dic[@"intro"];
        }
        if(![dic[@"uname"] isKindOfClass:[NSNull class]]){
            self.uname = dic[@"uname"];
        }
        if(![dic[@"avatar"] isKindOfClass:[NSNull class]]){
            self.avatar = dic[@"avatar"];
        }
        NSDictionary * secondDic = dic[@"follow_status"];
        if(secondDic && ![secondDic[@"following"] isKindOfClass:[NSNull class]]){
            self.follow = [secondDic[@"following"] boolValue];
        }else{
            self.follow = YES;
        }
    }
    return self;
    
}

+(AddFolloweringdata *)WithFolloweringdataDic:(NSDictionary *)dic{
    if(dic[@"userInfo"]){
        AddFolloweringdata *catalogcategory = [[AddFolloweringdata alloc]initWithFolloweringdataDic:dic[@"userInfo"]];
        return catalogcategory;
    }else{
        AddFolloweringdata *catalogcategory = [[AddFolloweringdata alloc]initWithFolloweringdataDic:dic];
        return catalogcategory;
    }
}

@end
