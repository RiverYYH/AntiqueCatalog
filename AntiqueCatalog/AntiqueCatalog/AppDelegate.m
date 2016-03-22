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

#import <TencentOpenAPI/QQApiInterface.h> //QQ应用
#import <TencentOpenAPI/TencentOAuth.h> //QQ应用

#import "WXApi.h" //微信+朋友圈

#import "WeiboSDK.h" //新浪微博


#import "APService.h" //极光推送JPush

#import <Bugly/CrashReporter.h>//腾讯Bugly
#import <SMS_SDK/SMS_SDK.h>//shareSDK短信验证注册

@interface AppDelegate ()

@end

@implementation AppDelegate


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
    AntiqueCatalogViewController *antiqueVC = [[AntiqueCatalogViewController alloc]init];
    self.window.rootViewController = antiqueVC;
    self.window.backgroundColor = [UIColor whiteColor];
    FirstPageViewController *firstVC = [[FirstPageViewController alloc]init];
    [antiqueVC addChildViewController:firstVC];
    [self initializePlat];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didLogoutSuccessful) name:@"LOGOUTSUCCESSFULL" object:nil];

    
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
   
}

#pragma mark - 通知方法
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LOGOUTSUCCESSFULL" object:nil];
}


@end
