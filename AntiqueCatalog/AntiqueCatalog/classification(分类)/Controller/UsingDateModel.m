//
//  UsingDateModel.m
//  AntiqueCatalog
//
//  Created by CssWeb on 16/4/19.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "UsingDateModel.h"

@implementation UsingDateModel

+(NSString*)countNSString_time1970WithTime:(NSString*)time_string{
    NSDateFormatter * formatter = [[NSDateFormatter alloc ] init];
    [formatter setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
    NSDate * date = [formatter dateFromString:time_string];
    NSTimeInterval time_1970=[date timeIntervalSince1970];
    double sysx = time_1970;
    NSNumber * numStage =  [NSNumber numberWithDouble:sysx];
    NSString * numStr = [NSString stringWithFormat:@"%0.0lf",[numStage doubleValue]];
    return numStr;
}



@end
