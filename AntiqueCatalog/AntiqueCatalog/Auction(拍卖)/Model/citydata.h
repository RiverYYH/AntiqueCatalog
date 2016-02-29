//
//  citydata.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/15.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface citydata : NSObject

/**
 *    城市id
 */
@property (nonatomic,copy)NSString *area_id;

/**
 *    城市名称
 */
@property (nonatomic,copy)NSString *title;

-(citydata *)initWithcitydataDic:(NSDictionary *)dic;

+(citydata *)WithcitydataDic:(NSDictionary *)dic;


@end
