//
//  UserSpacedata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/14.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "UserSpacedata.h"

@implementation UserSpacedata
-(UserSpacedata *)initWithUserSpacedataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        self.uid = dic[@"uid"];
        self.uname = dic[@"uname"];
        self.avatar = dic[@"avatar"][@"avatar_middle"];
        if ([dic[@"intro"] isKindOfClass:[NSNull class]]) {
            self.intro = @"";
        }else{
            self.intro = dic[@"intro"];
        }
        
        self.follow_status_following = [dic[@"follow_status"][@"following"] boolValue];
    }
    return self;
}

+(UserSpacedata *)WithUserSpacedataDic:(NSDictionary *)dic{
    UserSpacedata *userdata = [[UserSpacedata alloc]initWithUserSpacedataDic:dic];
    return userdata;
}
@end
