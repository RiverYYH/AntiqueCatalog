//
//  Authordata.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/15.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Authordata : NSObject
/**
 *    用户id
 */
@property (nonatomic,copy)NSString *uid;

/**
 *    用户名称
 */
@property (nonatomic,copy)NSString *uname;


-(Authordata *)initWithAuthordataDic:(NSDictionary *)dic;

+(Authordata *)WithAuthordataDic:(NSDictionary *)dic;
@end
