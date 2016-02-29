//
//  commentData.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/11.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "commentData.h"

@implementation commentData


-(commentData *)initWithcommentDataDic:(NSDictionary *)dic
{
    self = [super init];
    if (self) {
        _ID = dic[@"id"];
        self.userInfo_uid = dic[@"userInfo"][@"uid"];
        self.userInfo_avatar_middle = dic[@"userInfo"][@"avatar"][@"avatar_middle"];
        self.userInfo_uname = dic[@"userInfo"][@"uname"];
        self.ctime = [UserModel formateTime:dic[@"ctime"] andishour:YES];
        self.comment_count = dic[@"comment_count"];
        self.digg_count = dic[@"digg_count"];
        self.content = dic[@"content"];
        self.is_digg = [dic[@"is_digg"] boolValue];
    }
    return self;
}

+(commentData *)WithcommentDataDic:(NSDictionary *)dic
{
    commentData *commentdata = [[commentData alloc]initWithcommentDataDic:dic];
    return commentdata;
}

@end
