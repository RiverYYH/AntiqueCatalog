//
//  UsingDateModel.h
//  AntiqueCatalog
//
//  Created by CssWeb on 16/4/19.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UsingDateModel : NSObject

//根据传入的NSString类型的 YYYY-MM-dd hh:mm:ss 的时间 转换成时间戳
+(NSString*)countNSString_time1970WithTime:(NSString*)time_string;

@end
