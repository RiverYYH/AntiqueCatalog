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
    
    [self.window makeKeyAndVisible];
    
    
    return YES;
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

@end
