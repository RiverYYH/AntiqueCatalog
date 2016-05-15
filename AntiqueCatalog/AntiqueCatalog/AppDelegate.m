//
//  AppDelegate.m
//  AntiqueCatalog
//
//  Created by Cangmin on 15/12/31.
//  Copyright © 2015年 Cangmin. All rights reserved.
//

#import "AppDelegate.h"
#import "AntiqueCatalogViewController.h"
#import "FirstPageViewController.h"
#import "APService.h"

#import <ShareSDK/ShareSDK.h>
#import "RegistrationPageViewController.h"

#import <TencentOpenAPI/QQApiInterface.h> //QQ应用
#import <TencentOpenAPI/TencentOAuth.h> //QQ应用

#import "WXApi.h" //微信+朋友圈

#import "WeiboSDK.h" //新浪微博


#import "APService.h" //极光推送JPush

#import <Bugly/CrashReporter.h>//腾讯Bugly
#import <SMS_SDK/SMS_SDK.h>//shareSDK短信验证注册
#import "Api.h"
#import "FMDB.h"
#import "MF_Base64Additions.h"
#import "AFHTTPRequestOperation.h"
#import "DownFileMannger.h"

@interface AppDelegate ()<UIAlertViewDelegate>{
    FMDatabase *db;
    NSOperationQueue *operationQueue;
    NSMutableDictionary *dicOperation;
    NSMutableArray * notDownArray;

}

@end

@implementation AppDelegate

-(void)downloadFileImage{
    for (NSDictionary * dict in notDownArray) {
        NSString * fileName = dict[@"fileName"];
        NSString * fileId = dict[@"fileId"];
        
        NSString *pathOne = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@/Image",fileName] ];
        NSString * tempPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/temp/%@/Image",fileName] ];

        NSString * tableImageName = [NSString stringWithFormat:@"%@_%@",DOWNFILEIMAGE_NAME,fileId];
//        DownFileMannger * downFileManger = [[DownFileMannger alloc] init];
//        downFileManger.fileId = fileId;
//        downFileManger.fileName = fileName;
//        [downFileManger createQuue];
//        [downFileManger.netWorkQueue go];
//        [db open];
        FMResultSet * resTwo = [Api queryTableIALLDatabase:db AndTableName:tableImageName];
        while([resTwo next]){
            NSString* imageState =[resTwo objectForColumnName:DOWNFILEIMAGE_STATE];
            int tag = 0;
            if ([imageState isEqualToString:@"NO"]) {
                NSString * imageUrl = [resTwo objectForColumnName:DOWNFILEIMAGE_URL];
                NSString * imageId = [resTwo objectForColumnName:DOWNFILEIMAGE_ID];
                
                NSArray * array = [imageUrl componentsSeparatedByString:@"/"];
                NSString * tempstr = @"";
                for (int i =3; i < array.count; i ++) {
                    if (i < (array.count-1)) {
                        tempstr = [tempstr stringByAppendingString:[NSString stringWithFormat:@"%@/",array[i]]];
                        
                    }else{
                        
                    }
                }
                NSString * saveImagePath = [pathOne stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempstr]];
                
                NSString * tempsaveImagePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempstr]];

                NSFileManager *fileManagerOne = [NSFileManager defaultManager];
                //判断temp文件夹是否存在
                BOOL fileExistsOne = [fileManagerOne fileExistsAtPath:saveImagePath];
                //                NSLog(@"ddddddddddd:%@")
                if (!fileExistsOne) {//如果不存在说创建,因为下载时,不会自动创建文件夹
                    [fileManagerOne createDirectoryAtPath:saveImagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
                }
                
                BOOL fileExistsTwo = [fileManagerOne fileExistsAtPath:tempsaveImagePath];
                
                if (!fileExistsTwo) {//如果不存在说创建,因为下载时,不会自动创建文件夹
                    [fileManagerOne createDirectoryAtPath:tempsaveImagePath
                              withIntermediateDirectories:YES
                                               attributes:nil
                                                    error:nil];
                }
                
                NSString *videoName = [array objectAtIndex:array.count-1];
                NSString *downloadPath = [saveImagePath stringByAppendingPathComponent:videoName];
                NSString * mtempPathOne = [tempsaveImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",videoName]];
//                NSArray *tempRequestList=[downFileManger.netWorkQueue operations];
//                for (ASIHTTPRequest *request in tempRequestList) {
//                    //取消请求
//                    [request clearDelegatesAndCancel];
//                }
//
   
//                [downFileManger dowImageUrl:imageUrl withSavePath:downloadPath withTempPath:mtempPathOne withTag:tag withImageId:imageId withFileId:fileId withFileName:fileName];
                
                [self dowImageUrl:imageUrl withSavePath:downloadPath  withImageId:imageId withFiledId:fileId withTag:tag];
                
                
                
            }
            tag ++;
        }
//        [db close];
    }
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:{
            [self downloadFileImage];

        }
            break;
        default:
            break;
    }
}
- (void)checkNetwork{
//    Reachability *r = [Reachability reachabilityWithHostName:@"www.apple.com"];
    
    AFNetworkReachabilityManager *manger = [AFNetworkReachabilityManager sharedManager];
    [manger setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status) {
            case AFNetworkReachabilityStatusUnknown:
                NSLog(@"未知");
                break;
            case AFNetworkReachabilityStatusNotReachable:
                NSLog(@"没有网络");
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:{
                UIAlertView * altView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您不在wifi环境，是否继续下载没有完成的图录?" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
                [altView show];
                
            }
                NSLog(@"3G|4G");
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:{

                [self downloadImage];
                
            }
                NSLog(@"WiFi");
                break;
            default:
                break;
        }
    }];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //3D Touch 分为重压和轻压手势, 分别称作POP(第一段重压)和PEEK(第二段重压), 外面的图标只需要POP即可.
    //POP手势图标初始化
    //使用系统自带图标
//    UIApplicationShortcutIcon *icon1 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeAdd];
//    UIApplicationShortcutIcon *icon2 = [UIApplicationShortcutIcon iconWithType:UIApplicationShortcutIconTypeCompose];
    //使用自己的图片
//    UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"自己的图片"];
//    UIApplicationShortcutItem *item1 = [[UIApplicationShortcutItem alloc]initWithType:@"item1" localizedTitle:@"最近阅读" localizedSubtitle:nil icon:icon1 userInfo:nil];
//    UIApplicationShortcutItem *item2 = [[UIApplicationShortcutItem alloc]initWithType:@"item2" localizedTitle:@"书架" localizedSubtitle:nil icon:icon2 userInfo:nil];
//    NSArray *array = @[item1,item2];
//    [UIApplication sharedApplication].shortcutItems = array;

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [[UIApplication sharedApplication]setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    db = [Api initTheFMDatabase];
    
    operationQueue = [[NSOperationQueue alloc] init];
    dicOperation = [[NSMutableDictionary alloc]init];
    
    [operationQueue setMaxConcurrentOperationCount:10];
//    [self checkNetwork];
    notDownArray = [NSMutableArray array];
    [self downloadImage];
    [SMS_SDK registerApp:@"6da3218d1256" withSecret:@"7df7df0fe654538df37273c7ba048d3e"];


//    AntiqueCatalogViewController *antiqueVC = [[AntiqueCatalogViewController alloc]init];
//    FirstPageViewController *firstVC = [[FirstPageViewController alloc]init];
//    [antiqueVC addChildViewController:firstVC];
//    self.window.rootViewController = antiqueVC;
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        //暂时性跳过引导页
        //        self.window.rootViewController = [[GuideViewController alloc] init];
        [self check];

        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstLaunch"];

        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstLogin"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstLike"];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"firstTen"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"provinceSeleted"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"citySeleted"];
        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"areaSeleted"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [UserModel saveUserLoginType:@"phone"];
        //首次登陆初始化各项设置
        [self initializeSettingWithFirstLaunch];
    }
    else
    {
        [self check];
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLoginSuccessful) name:@"LOGINSUCCESSFULL" object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogoutSuccessful) name:@"LOGOUTSUCCESSFULL" object:nil];

    [self initializePlat];

    
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
    {
        //可以添加自定义categories
        [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                       UIUserNotificationTypeSound |
                                                       UIUserNotificationTypeAlert)
                                           categories:nil];
    }
    else
    {
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
    }
#else
    //categories 必须为nil
    [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                   UIRemoteNotificationTypeSound |
                                                   UIRemoteNotificationTypeAlert)
                                       categories:nil];
#endif
    
    // Required
    [APService setupWithOption:launchOptions];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

-(void)downloadImage{
    [db open];
    FMResultSet * resOne = [Api  queryTableIALLDatabase:db AndTableName:DOWNTABLE_NAME];
//    NSString * queryStr = [NSString stringWithFormat:@"SELECT * FROM %@",DOWNTABLE_NAME];
//    FMResultSet * resOne = [db executeQuery:queryStr];

    while([resOne next]){
        NSString* fileId =[resOne objectForColumnName:DOWNFILEID];
        NSString * fileName= [resOne objectForColumnName:DOWNFILE_NAME];
        NSString * progress = [resOne objectForColumnName:DOWNFILE_Progress];
        if (STRING_NOT_EMPTY(progress)) {
            if ([progress isEqualToString:@"100.00%"]) {
                
            }else{
                NSMutableDictionary * dict = [NSMutableDictionary dictionary];
                dict[@"fileId"] = [NSString stringWithFormat:@"%@",fileId];
                dict[@"fileName"] = [NSString stringWithFormat:@"%@",fileName];
                dict[@"progress"] = [NSString stringWithFormat:@"%@",progress];
                [notDownArray addObject:dict];
                
            }
 
        }else{
            NSMutableDictionary * dict = [NSMutableDictionary dictionary];
            dict[@"fileId"] = [NSString stringWithFormat:@"%@",fileId];
            dict[@"fileName"] = [NSString stringWithFormat:@"%@",fileName];
            dict[@"progress"] = [NSString stringWithFormat:@"%@",progress];
            [notDownArray addObject:dict];
        }
        NSLog(@"lllllllllllllllll:%@",progress);
        

    }
//    [db close];
    
    if(notDownArray.count > 0){
//        NSDictionary * userDict = [[NSDictionary alloc] initWithObjectsAndKeys:notDownArray,@"NOTDOWNFILE", nil];
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"HAVE_NOT_DOWNFILE" object:self userInfo:userDict];
        
        NSString * mesg = [NSString stringWithFormat:@"您有%lu没有下载完是否继续？",(unsigned long)notDownArray.count];
        UIAlertView * altView = [[UIAlertView alloc] initWithTitle:@"提示" message:mesg delegate:self cancelButtonTitle:@"否" otherButtonTitles:@"是", nil];
        altView.tag = 1000;
        [altView show];
        
    }

}


//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//    
//}

-(void)dowImageUrl:(NSString*)imageUrl withSavePath:(NSString*)downloadPath withImageId:(NSString*)imageId withFiledId:(NSString*)filedId withTag:(int)tag{
    
    NSString * tableImageName = [NSString stringWithFormat:@"%@_%@",DOWNFILEIMAGE_NAME,filedId];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:imageUrl]];
    unsigned long long downloadedBytes = 0;
    if ([[NSFileManager defaultManager] fileExistsAtPath:downloadPath]) {
        //获取已下载的文件长度
        downloadedBytes = [self fileSizeForPath:downloadPath];
        if (downloadedBytes > 0) {
            NSMutableURLRequest *mutableURLRequest = [request mutableCopy];
            NSString *requestRange = [NSString stringWithFormat:@"bytes=%llu-", downloadedBytes];
            [mutableURLRequest setValue:requestRange forHTTPHeaderField:@"Range"];
            request = mutableURLRequest;
        }
    }
    //不使用缓存，避免断点续传出现问题
    [[NSURLCache sharedURLCache] removeCachedResponseForRequest:request];
    AFHTTPRequestOperation *operation  = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    //下载路径
    operation.outputStream = [NSOutputStream outputStreamToFileAtPath:downloadPath append:YES];
    [dicOperation setObject:operation forKey:@(tag)];
    operation.userInfo = @{@"keyOp":@(tag),@"ImageId":imageId};
    tag ++;
    __weak AFHTTPRequestOperation *myOp = operation;
    
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        //下载进度
        float progress = ((float)totalBytesRead + downloadedBytes) / (totalBytesExpectedToRead + downloadedBytes);
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[myOp.userInfo objectForKey:@"keyOp"] intValue] inSection:0];
        NSString *str = [NSString stringWithFormat:@"下载%.4f",progress];
        dispatch_async(dispatch_get_main_queue(), ^{
        });
    }];
    //成功和失败回调
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[myOp.userInfo objectForKey:@"keyOp"] intValue] inSection:0];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString * tableImageName = [NSString stringWithFormat:@"%@_%@",DOWNFILEIMAGE_NAME,filedId];
            
            FMResultSet * tempRs = [Api queryResultSetWithWithDatabase:db AndTable:tableImageName AndWhereName:DOWNFILEIMAGE_ID AndValue:imageId];
            
            if([tempRs next]){
                //找到这条记录的话 把下载状态从NO 改为YES
                NSString *updateSql = [NSString stringWithFormat:
                                       @"UPDATE %@ SET  %@ = '%@' WHERE %@ = %@",
                                       tableImageName,DOWNFILEIMAGE_STATE,@"YES",DOWNFILEIMAGE_ID,imageId];
                BOOL res = [db executeUpdate:updateSql];
                if (!res) {
                    NSLog(@"error when update TABLE_ACCOUNTINFOS");
                } else {
                    
                }
                
            }else{
                //找不到的话 直接插入数据
                NSString *insertSql= [NSString stringWithFormat:
                                      @"INSERT INTO '%@' ('%@', '%@','%@','%@') VALUES ('%@', '%@','%@','%@' )",
                                      tableImageName,DOWNFILEID,DOWNFILEIMAGE_ID,DOWNFILEIMAGE_STATE,DOWNFILEIMAGE_URL,filedId,imageId,@"YES",imageUrl];
                NSLog(@"-------------------------------%@",insertSql);
                BOOL res = [db executeUpdate:insertSql];
                if (!res) {
                    NSLog(@"error when TABLE_ACCOUNTINFOS");
                } else {
                    
                }
                
            }
//            [db close];
            
//            [db open];
            FMResultSet * resTwo = [Api queryTableIALLDatabase:db AndTableName:tableImageName];
            NSString* countStr = [NSString stringWithFormat:@"select count(*) from %@",tableImageName];
            NSUInteger count = [db intForQuery:countStr];
            //            NSLog(@"数据库总数目:%d",count);
            
            BOOL isFinish = YES;
            int isHaveDown = 0;
            while([resTwo next]){
                NSString* imageState =[resTwo objectForColumnName:DOWNFILEIMAGE_STATE];
                if ([imageState isEqualToString:@"NO"]) {
                    isFinish = NO;
                }else{
                    isHaveDown ++;
                }
            }
            
            
            if (isFinish) {
                NSLog(@"isHaveDown == %d",isHaveDown);
//                [db open];
                FMResultSet * tempRsOne = [Api queryResultSetWithWithDatabase:db AndTable:DOWNTABLE_NAME AndWhereName:DOWNFILEID AndValue:filedId];
                
                if([tempRsOne next]){
                    NSString *updateSql = [NSString stringWithFormat:
                                           @"UPDATE %@ SET  %@ = '%@' WHERE %@ = %@",
                                           DOWNTABLE_NAME,DOWNFILE_TYPE,@"1",DOWNFILEID,filedId];
                    BOOL res = [db executeUpdate:updateSql];
                    if (!res) {
                        NSLog(@"error when update TABLE_ACCOUNTINFOS");
                    } else {
                        //                        NSLog(@"success to update TABLE_ACCOUNTINFOS");
                    }
                    NSString * prectstrOne = [NSString stringWithFormat:@"%0.2f%%",((float)isHaveDown/count) * 100];
                    
                    
                    NSString *updateSqlM = [NSString stringWithFormat:
                                            @"UPDATE %@ SET  %@ = '%@',%@ = '%@' WHERE %@ = %@",
                                            DOWNTABLE_NAME,DOWNFILE_TYPE,@"1",DOWNFILE_Progress,prectstrOne,DOWNFILEID,filedId];
                    BOOL resM = [db executeUpdate:updateSqlM];
                    if (!resM) {
                        NSLog(@"error when update TABLE_ACCOUNTINFOS");
                    } else {
                        
                        
                    }
                    
                    
                }
                
                
                
                
            }else{
                NSString * prectstrOne = [NSString stringWithFormat:@"%0.2f%%",((float)isHaveDown/count) * 100];
                
                FMResultSet * tempRsOne = [Api queryResultSetWithWithDatabase:db AndTable:DOWNTABLE_NAME AndWhereName:DOWNFILEID AndValue:filedId];
                
                if([tempRsOne next]){
                    
                    NSString *updateSql = [NSString stringWithFormat:
                                           @"UPDATE %@ SET %@ = '%@', %@ = '%@' WHERE %@ = %@",
                                           DOWNTABLE_NAME,DOWNFILE_TYPE,@"3",DOWNFILE_Progress,prectstrOne,DOWNFILEID,filedId];
                    BOOL res = [db executeUpdate:updateSql];
                    if (!res) {
                        NSLog(@"error when update TABLE_ACCOUNTINFOS");
                    } else {
                        //                        NSLog(@"success to update TABLE_ACCOUNTINFOS");
                    }
                    
                    
                }
//                [db close];
                
                
                
            }

            
            NSMutableDictionary * usDict = [NSMutableDictionary dictionary];
            if (count > 30 ) {
                if ( isHaveDown % 10 == 0) {
                    usDict[@"ProgreValue"] = [NSString stringWithFormat:@"%0.2f",(float)isHaveDown/count];
                    usDict[@"FiledId"] = [NSString stringWithFormat:@"%@",filedId];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDownList" object:nil userInfo:usDict];
                    
                }
            }else{
                //                    if ( isHaveDown % 5 == 0) {
                usDict[@"ProgreValue"] = [NSString stringWithFormat:@"%0.2f",(float)isHaveDown/count];
                usDict[@"FiledId"] = [NSString stringWithFormat:@"%@",filedId];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDownList" object:nil userInfo:usDict];
                
            }
            
                    NSLog(@"===========: %d %d",count, isHaveDown);
            
            if (isHaveDown == count) {
                usDict[@"ProgreValue"] = [NSString stringWithFormat:@"%0.2f",(float)isHaveDown/count];
                usDict[@"FiledId"] = [NSString stringWithFormat:@"%@",filedId];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDownList" object:nil userInfo:usDict];
                
                
            }

            
        });
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSString * tableImageName = [NSString stringWithFormat:@"%@_%@",DOWNFILEIMAGE_NAME,filedId];
        FMResultSet * tempRs = [Api queryResultSetWithWithDatabase:db AndTable:tableImageName AndWhereName:DOWNFILEIMAGE_ID AndValue:imageId];
        if([tempRs next]){
            
            NSString *updateSql = [NSString stringWithFormat:
                                   @"UPDATE %@ SET  %@ = '%@' WHERE %@ = %@",
                                   tableImageName,DOWNFILEIMAGE_STATE,@"NO",DOWNFILEIMAGE_ID,imageId];
            BOOL res = [db executeUpdate:updateSql];
            if (!res) {
                NSLog(@"App启动=========error when update TABLE_ACCOUNTINFOS");
            } else {
                NSLog(@"App启动=========success to update TABLE_ACCOUNTINFOS");
            }
            
        }else{
            NSString *insertSql= [NSString stringWithFormat:
                                  @"INSERT INTO '%@' ('%@', '%@','%@','%@') VALUES ('%@', '%@','%@','%@' )",
                                  tableImageName,DOWNFILEID,DOWNFILEIMAGE_ID,DOWNFILEIMAGE_STATE,DOWNFILEIMAGE_URL,filedId,imageId,@"NO",imageUrl];
            
            BOOL res = [db executeUpdate:insertSql];
            if (!res) {
                NSLog(@"App启动=========error when TABLE_ACCOUNTINFOS");
            } else {
                NSLog(@"App启动=========success INSERT TABLE_ACCOUNTINFOS");
            }
            
        }
        
        
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        BOOL bRet = [fileMgr fileExistsAtPath:downloadPath];
        
        if (bRet) {
            //
            NSError *err;
            [fileMgr removeItemAtPath:downloadPath error:&err];
        }
    }];
    [operation start];
    
    
}

- (unsigned long long)fileSizeForPath:(NSString *)path {
    signed long long fileSize = 0;
    NSFileManager *fileManager = [NSFileManager new]; // default is not thread safe
    if ([fileManager fileExistsAtPath:path]) {
        NSError *error = nil;
        NSDictionary *fileDict = [fileManager attributesOfItemAtPath:path error:&error];
        if (!error && fileDict) {
            fileSize = [fileDict fileSize];
        }
    }
    return fileSize;
}


- (void)initializePlat
{
    //ShareSDK的AppKey
    [ShareSDK registerApp:ShareSDKKEY];
    
    //添加QQ应用  注册网址  http://open.qq.com/
    [ShareSDK connectQQWithQZoneAppKey:QQAPPID qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //添加微信+朋友圈应用 注册网址  http://open.weixin.qq.com
    [ShareSDK connectWeChatWithAppId:WeiXinAPPID appSecret:WeiXinAPPSecret wechatCls:[WXApi class]];
    
    //添加新浪微博应用  注册网址  http://open.weibo.com
    [ShareSDK connectSinaWeiboWithAppKey:SinaAppKey appSecret:SinaAppSecret redirectUri:SinaAppURL weiboSDKCls:[WeiboSDK class]];
    
    //添加QQ空间应用  注册网址  http://connect.qq.com/intro/login/
    [ShareSDK connectQZoneWithAppKey:QQAPPID appSecret:QQSecret qqApiInterfaceCls:[QQApiInterface class] tencentOAuthCls:[TencentOAuth class]];
    
    //初始化腾讯微博，请在腾讯微博开放平台申请
    //    [ShareSDK connectTencentWeiboWithAppKey:@"801307650"
    //                                  appSecret:@"ae36f4ee3946e1cbb98d6965b0b2ff5c"
    //                                redirectUri:@"http://www.sharesdk.cn"
    //                                   wbApiCls:[WeiboApi class]];
    //    [ShareSDK connectTencentWeiboWithAppKey:@"" appSecret:@"" redirectUri:@"" wbApiCls:[WeiboApi class]];
    
}



- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    
    
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    return [ShareSDK handleOpenURL:url wxDelegate:self];
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    return [ShareSDK handleOpenURL:url sourceApplication:sourceApplication annotation:annotation wxDelegate:self];
}

- (void)didLogoutSuccessful
{
    //取消第三方授权
    [ShareSDK cancelAuthWithType:ShareTypeQQSpace];
    [ShareSDK cancelAuthWithType:ShareTypeWeixiSession];
    [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo];
//    [CustomTabBarViewController deleteInstance];

    [self check];

}

- (void)initializeSettingWithFirstLaunch
{
    //是否接收新消息提醒,默认是不接收
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ReceiveNewMessageAlert"];
}

#pragma mark - 通知方法
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGINSUCCESSFULL" object:nil];

    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGOUTSUCCESSFULL" object:nil];
}


- (void)didLoginSuccessful
{
    [self check];
}


- (void)check
{
    
    if ([UserModel checkLogin] ||[[NSUserDefaults standardUserDefaults] boolForKey:@"firstLaunch"])
    {
        
        NSString *userUidString = [[UserModel userPassport] objectForKey:@"uid"];
        //环信判断是否自动登录，如果没有再登录

    
        self.window.rootViewController = nil;
        //        self.window.rootViewController = [CustomTabBarViewController sharedInstance];
        AntiqueCatalogViewController *antiqueVC = [[AntiqueCatalogViewController alloc]init];
        FirstPageViewController *firstVC = [[FirstPageViewController alloc]init];
//        firstVC.notDowArray = notDownArray;
        [antiqueVC addChildViewController:firstVC];
        self.window.rootViewController = antiqueVC;
  
//        [self.window.rootViewController ]
        NSString *uid =  [[[NSUserDefaults standardUserDefaults] objectForKey:@"UserModelPassport"] objectForKey:@"uid"];
        NSLog(@"uid = %@",uid);

        self.window.backgroundColor = [UIColor whiteColor];

        [APService setAlias:uid callbackSelector:nil object:self];
        [self.window makeKeyAndVisible];

    }
    else
    {
        
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"BaoBeiHide"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        //        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        
        self.window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[[RegistrationPageViewController alloc] init]];
        
    }
}



@end
