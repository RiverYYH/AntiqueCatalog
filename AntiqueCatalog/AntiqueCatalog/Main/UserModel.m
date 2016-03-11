//
//  UserModel.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/5.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

/**
 *    存储用户uid,oauthToken,oauthTokenSecret,avatar信息,并将uname单独存储为上次成功登录用户
 *
 */

+ (void)saveUserPassportWithdic:(NSDictionary *)dic{
    
    NSDictionary *passport = [NSDictionary dictionaryWithObjectsAndKeys:
                              [dic objectForKey:@"uid"], @"uid",
                              [dic objectForKey:@"oauth_token"], @"oauthToken",
                              [dic objectForKey:@"oauth_token_secret"], @"oauthTokenSecret",
                             nil];
    [[NSUserDefaults standardUserDefaults] setObject:passport forKey:@"UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}


+ (void)saveUserInformationWithdic:(NSDictionary *)dic{
    
    
    
    NSDictionary *passport = [NSDictionary dictionaryWithObjectsAndKeys:
                              [dic objectForKey:@"uname"], @"uname",
                              [dic objectForKey:@"avatar"], @"avatar",
                              [dic objectForKey:@"intro"], @"intro",
                              nil];
    [[NSUserDefaults standardUserDefaults] setObject:passport forKey:@"UserModelInformation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

/**
 *    读取用户uid,oauthToken,oauthTokenSecret信息
 *
 */

+ (NSDictionary *)userPassport{
    
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserModelPassport"];
    
}

+ (NSString *)userUname
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUserModelPassport"];
}

+ (NSDictionary *)userUserInfor{
    return [[NSUserDefaults standardUserDefaults] dictionaryForKey:@"UserModelInformation"];
}

//清除用户uid,oauthToken,oauthTokenSecret信息,以及个人信息
+ (void)deleteUserPassport{
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"UserModelInformation"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

//判断是否登录状态
+ (BOOL)checkLogin{
    
    NSDictionary *passport = [self userPassport];
    NSString *string = [NSString stringWithFormat:@"%@",[passport objectForKey:@"uid"]];
    if ([passport isKindOfClass:[NSDictionary class]] && STRING_NOT_EMPTY(string))
    {
        if ([[passport objectForKey:@"uid"] longLongValue]>0)
        {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    else
    {
        return NO;
    }
    
    
}

+ (NSString *)formateTime:(NSString *)time andishour:(BOOL)ishour{
    
    NSTimeInterval tempTime = [time intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatter setDateFormat:@"yy-MM-dd HH:mm"];
    NSDate *startDate = confromTimesp;
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
    NSInteger y_startDate = [startDateComponents year];
    NSInteger m_startDate = [startDateComponents month];
    NSInteger d_startDate = [startDateComponents day];
    NSInteger h_startDate = [startDateComponents hour];
    NSInteger M_startDate = [startDateComponents minute];
    
    if (ishour) {
        return [NSString stringWithFormat:@"%ld.%ld.%ld %ld:%ld",(long)y_startDate,(long)m_startDate,(long)d_startDate,(long)h_startDate,(long)M_startDate];
    }else{
        return [NSString stringWithFormat:@"%ld.%ld.%ld",(long)y_startDate,(long)m_startDate,(long)d_startDate];
    }
    
    
}

+ (NSString *)toformateTime:(NSString *)time{
    
    NSString* timeStr = time;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init] ;
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"]; // ----------设置你想要的格式,hh与HH的区别:分别表示12小时制,24小时制
    
    //设置时区,这个对于时间的处理有时很重要
    NSTimeZone* timeZone = [NSTimeZone timeZoneWithName:@"Asia/Shanghai"];
    [formatter setTimeZone:timeZone];
    NSDate* date = [formatter dateFromString:timeStr]; //------------将字符串按formatter转成nsdate
    //时间转时间戳的方法:
    NSString *timeSp = [NSString stringWithFormat:@"%ld", (long)[date timeIntervalSince1970]];
    NSLog(@"timeSp:%@",timeSp); //时间戳的值
    return timeSp;
}

+ (NSString *)userLoginType
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"loginType"];
}

+ (NSDictionary *)userLocation
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"userLocation"];
}

+ (NSString *)formateTime:(NSString *)time
{
    NSTimeInterval tempTime = [time intValue];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    NSDateFormatter *formatterT = [[NSDateFormatter alloc] init];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatter setDateFormat:@"yy-MM-dd HH:mm"];
    NSDate *confromTimespT = [NSDate dateWithTimeIntervalSince1970:tempTime];
    [formatterT setDateFormat:@"HH:mm"];
    NSDate *startDate = confromTimesp;
    NSDate *endDate = [NSDate date];
    NSCalendar *cal = [NSCalendar currentCalendar];
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit |NSSecondCalendarUnit;
    NSDateComponents *endDateComponents = [cal components:unitFlags fromDate:endDate];
    NSDateComponents *startDateComponents = [cal components:unitFlags fromDate:startDate];
    
    NSInteger y_endDate = [endDateComponents year];
    int64_t y_startDate = [startDateComponents year];
    
    NSInteger m_endDate = [endDateComponents month];
    int64_t m_startDate = [startDateComponents month];
    
    NSInteger d_endDate = [endDateComponents day];
    int64_t d_startDate = [startDateComponents day];
    
    NSString *confromTimespStr =nil;
    if (d_endDate - d_startDate == 0 && y_endDate - y_startDate == 0 && m_endDate - m_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"今天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else if (d_endDate - d_startDate == 1 && y_endDate - y_startDate == 0 && m_endDate - m_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"昨天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else if (d_endDate - d_startDate == 2 && y_endDate - y_startDate == 0 && m_endDate - m_startDate == 0)
        confromTimespStr =[NSString stringWithFormat:@"前天 %@",[formatterT stringFromDate:confromTimespT]] ;
    else
        confromTimespStr = [formatter stringFromDate:confromTimesp];
    return confromTimespStr;
}


+ (void)saveUserLoginType:(NSString *)type
{
    [[NSUserDefaults standardUserDefaults] setObject:type forKey:@"loginType"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveUserPassportWithUname:(NSString *)uname andUid:(NSString *)uid andToken:(NSString *)token andTokenSecret:(NSString *)tokenSecret andAvatar:(NSString *)avatar
{
    NSDictionary *passport = [NSDictionary dictionaryWithObjectsAndKeys:
                              uid, @"uid",
                              token, @"oauthToken",
                              tokenSecret, @"oauthTokenSecret",
                              avatar, @"avatar",
                              nil];
    [[NSUserDefaults standardUserDefaults] setObject:passport forKey:@"UserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [[NSUserDefaults standardUserDefaults] setObject:uname forKey:@"LastUserModelPassport"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}


@end
