//
//  Api.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "Api.h"
#import "JWLoadView.h"
#import "NetWorkClient.h"
#import "UserModel.h"
#import "NetWorkClientOne.h"
#import "SGInfoAlert.h"
#import "FMDB.h"

@implementation Api

+ (void)requestWithbool:(BOOL)isuser
             withMethod:(NSString*)method
               withPath:(NSString*)path
             withParams:(NSDictionary*)params
            withSuccess:(void (^)(id responseObject))success
              withError:(void (^)(NSError* error))failed
{
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString * oauthToken = [[NSUserDefaults standardUserDefaults] stringForKey:@"oauth_token"];
    NSString * oauthTokenSecret = [[NSUserDefaults standardUserDefaults] stringForKey:@"oauth_token_secret"];
    if (oauthToken.length == 0 || oauthTokenSecret == 0) {
        [mutableDic setValue:Oauth_token forKey:@"oauth_token"];
        [mutableDic setValue:Oauth_token_secret forKey:@"oauth_token_secret"];

    }else{
        [mutableDic setValue:oauthToken forKey:@"oauth_token"];
        [mutableDic setValue:oauthTokenSecret forKey:@"oauth_token_secret"];
    }

    
    if ([[method lowercaseString] isEqualToString:@"get"]){
        
        [[NetWorkClient sharedClient]GET:path parameters:isuser?mutableDic:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });

            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });

            
        }];
        
    }
    else if ([[method lowercaseString] isEqualToString:@"post"]){
        
        [[NetWorkClient sharedClient]POST:path parameters:isuser?mutableDic:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
            
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
            
        }];
        
    }

    
    
}

+ (void)requestWithMethod:(NSString*)method
                 withPath:(NSString*)path
               withParams:(NSDictionary*)params
              withSuccess:(void (^)(id responseObject))success
                withError:(void (^)(NSError* error))failed
{
    NSMutableDictionary *mutableDic = [NSMutableDictionary dictionaryWithDictionary:params];
    NSDictionary *passport = [UserModel userPassport];
    [mutableDic setValue:[passport objectForKey:@"oauthToken"] forKey:@"oauth_token"];
    [mutableDic setValue:[passport objectForKey:@"oauthTokenSecret"] forKey:@"oauth_token_secret"];
    
    if ([[method lowercaseString] isEqualToString:@"get"])
    {
        [[NetWorkClientOne sharedClient] GET:path parameters:mutableDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
        }];
    }
    else if ([[method lowercaseString] isEqualToString:@"post"])
    {
        [[NetWorkClientOne sharedClient] POST:path parameters:mutableDic success:^(AFHTTPRequestOperation *operation, id responseObject) {
            dispatch_async(dispatch_get_main_queue(), ^{
                success(responseObject);
            });
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                failed(error);
            });
        }];
    }
}

+ (void)showLoadMessage:(NSString *)message{
    
    [[JWLoadView sharedJWLoadView] showMessage:message];
    
}

+ (void)hideLoadHUD{
    
    [UIView animateWithDuration:0.2 animations:^{
        [[JWLoadView sharedJWLoadView] dismiss];
    }];
}

+ (void)endClient
{
    [[NetWorkClient sharedClient].operationQueue cancelAllOperations];
}
+(void)alert4:(NSString *)message inView:(UIView *)view offsetY:(CGFloat)yOffset{
    [[SGInfoAlert alert] showInfo:message
                          bgColor:[[UIColor blackColor] CGColor]
                           inView:view
                          offsetY:yOffset
                         showTime:2.0f
                         fontSize:16.0f];
    
}


+(FMDatabaseQueue *)getSharedDatabaseQueue
{
    static FMDatabaseQueue *my_FMDatabaseQueue=nil;
    
    if (!my_FMDatabaseQueue) {
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString * documents = [paths objectAtIndex:0];
        NSString * database_path = [documents stringByAppendingPathComponent:DB_NAME];
        my_FMDatabaseQueue = [FMDatabaseQueue databaseQueueWithPath:database_path];
    }
    return my_FMDatabaseQueue;
    
}

+(FMDatabase *)initTheFMDatabase{
    FMDatabase * db;
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString * documents = [paths objectAtIndex:0];
    NSString * database_path = [documents stringByAppendingPathComponent:DB_NAME];
    NSLog(@"sqlite path: %@",database_path);
    db = [FMDatabase databaseWithPath:database_path];
    return db;
}

+(FMResultSet*)queryTableIsOrNotInTheDatebaseWithDatabase:(FMDatabase*)db AndTableName:(NSString*)tableName{
    NSString * queryStr = [NSString stringWithFormat:@"SELECT * FROM sqlite_master WHERE name='%@'",tableName];
    FMResultSet * rs = [db executeQuery:queryStr];
    return rs;
}

+(FMResultSet*)queryTableIsOrNotInTheDatebaseWithDatabase:(FMDatabase*)db AndTableName:(NSString*)tableName withColumn:(NSString*)column{
    NSString * queryStr = [NSString stringWithFormat:@"SELECT '%@' FROM %@",column,tableName];
    FMResultSet * rs = [db executeQuery:queryStr];
    return rs;
}

+(FMResultSet*)queryTableIALLDatabase:(FMDatabase*)db AndTableName:(NSString*)tableName {
    NSString * queryStr = [NSString stringWithFormat:@"SELECT * FROM %@",tableName];
    FMResultSet * rs = [db executeQuery:queryStr];
    return rs;
}

+(NSString *)creatTable_TeacherAccountSq{
    NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT , '%@' TEXT )",TABLE_ACCOUNTINFOS,KEYID,DATAID,IMAGEDATA];
    return sqlCreateTable;
}

+(NSString*)creatTable_DownAccountSq{
    NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT,'%@' TEXT,'%@' TEXT)",DOWNTABLE_NAME,KEYID,DOWNFILEID,DOWNFILE_NAME,DOWNFILE_TYPE,DOWNFILE_Progress];
    return sqlCreateTable;
}

+(NSString*)creatTable_DownImageSQl:(NSString*)tableName{
    NSString *sqlCreateTable =  [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS '%@' ('%@' INTEGER PRIMARY KEY AUTOINCREMENT, '%@' TEXT,'%@' TEXT ,'%@' TEXT ,'%@' TEXT,'%@' TEXT)",tableName,KEYID,DOWNFILEID,DOWNFILEIMAGE_ID,DOWNFILEIMAGE_STATE,DOWNFILEIMAGE_URL,DOWNIMAGEFailed_COUNT];
    return sqlCreateTable;
}


+(FMResultSet*)queryResultSetWithWithDatabase:(FMDatabase*)db AndTable:(NSString *)tableName AndWhereName:(NSString *)keyName AndValue:(NSString *)value{
    NSString * queryStr = [NSString stringWithFormat:
                           @"SELECT * FROM %@ WHERE %@ = %@",tableName,keyName,value];
    FMResultSet * rs = [db executeQuery:queryStr];
    return rs;
}

+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}

+ (NSMutableArray *)ArrayWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSMutableArray *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
    if(err) {
        return nil;
    }
    return dic;
}


@end
