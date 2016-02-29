//
//  catalogdetailsdata.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/9.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "catalogdetailsdata.h"

@implementation catalogdetailsdata
-(catalogdetailsdata *)initWithcatalogdetailsdataDataDic:(NSDictionary *)dic{
    
    self = [super init];
    if (self) {
        
        self.ID = dic[@"id"];
        self.type = dic[@"type"];
        self.cover = dic[@"cover"];
        self.name = dic[@"name"];
        self.view_count = dic[@"view_count"];
        self.author = dic[@"author"];
        
        if ([self.type isEqualToString:@"0"]) {

            self.v_stime = [UserModel formateTime:dic[@"v_stime"] andishour:YES];
            self.v_ntime = [UserModel formateTime:dic[@"v_ntime"] andishour:YES];
            self.v_address = dic[@"v_address"];
            self.stime = [UserModel formateTime:dic[@"stime"] andishour:YES];
            self.address = dic[@"address"];
            
        }
        self.info = dic[@"info"];
        
        self.tag = dic[@"tag"];
        
        self.userInfo_uid = dic[@"userInfo"][@"uid"];
        self.userInfo_avatar_middle = dic[@"userInfo"][@"avatar"][@"avatar_middle"];
        self.userInfo_uname = dic[@"userInfo"][@"uname"];
        NSDictionary *dic1 = [dic objectForKey:@"follow_status"];
        int followingint = [[dic1 objectForKey:@"following"] intValue];
        if (followingint == 0) {
            self.userInfo_following = NO;
        }else{
            self.userInfo_following = YES;
        }
        
        
        self.comment = dic[@"comment"];
        
        self.userInfo_moreCatalog = dic[@"userInfo"][@"moreCatalog"];
        self.moreCatalog = dic[@"moreCatalog"];
        
    }
    return self;
    
}

+(catalogdetailsdata *)WithcatalogdetailsdataDataDic:(NSDictionary *)dic{
    
    catalogdetailsdata *catalogdetailsData = [[catalogdetailsdata alloc]initWithcatalogdetailsdataDataDic:dic];
    return catalogdetailsData;
    
}
@end
