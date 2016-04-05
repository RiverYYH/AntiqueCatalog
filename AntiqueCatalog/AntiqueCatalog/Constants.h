//
//  Constants.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/1.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PureLayout.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

#import "Api.h"
#import "UserModel.h"

#import "UIColor+Convert.h"
#import "Allview.h"

#define iOS7 ([[UIDevice currentDevice].systemVersion doubleValue] >= 7.0)
#define UI_NAVIGATION_BAR_HEIGHT        ((iOS7)?64:44) //navigationBar的高度
#define UI_TAB_BAR_HEIGHT               49 //tabBar的高度

#define UI_CELL_BG_WIDTH                10//cell灰色背景宽度


#define UI_SCREEN_WIDTH                 ([[UIScreen mainScreen] bounds].size.width) //整个屏幕的宽度
#define UI_SCREEN_HEIGHT                ([[UIScreen mainScreen] bounds].size.height) //整个屏幕的高度

#define UI_SCREEN_FRAME CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)
#define UI_MAIN_SCREEN_FRAME CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)
#define UI_NO_TAB_FRAME CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-UI_TAB_BAR_HEIGHT)


#define iPhone4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IS_IPHONE_5 ( fabs( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

#define IOS7 [[[UIDevice currentDevice] systemVersion] floatValue] >= 7.f //判断是否是ios7系统


#define UI_SCREEN_SHOW                   UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT

#define TEXT_WIDTH                      UI_SCREEN_WIDTH - 50

#define iOSVersion [[[UIDevice currentDevice] systemVersion] floatValue]

//字符串不为空
#define STRING_NOT_EMPTY(string) (string != nil && [string isKindOfClass:[NSString class]] && ![[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] isEqualToString:@""])
//数组不为空
#define ARRAY_NOT_EMPTY(array) (array && [array isKindOfClass:[NSArray class]] && [array count])
//字典不为空
#define DIC_NOT_EMPTY(dictionary) (dictionary && [dictionary isKindOfClass:[NSDictionary class]] && [dictionary count])

//通过RGB设置颜色
#define RGBA(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
//全局背景色
#define  Global_Background RGBA(224,224,224)
//title颜色
#define TITLE_COLOR RGBA(43,43,43)
//content颜色+placeholder颜色+微博time
#define CONTENT_COLOR RGBA(153,153,153)

//选中状态下的红色
#define SELECT_COLOR RGBA(190,71,49)
//
#define BLUE_COLOR RGBA(33,132,233);

//title颜色
#define TITLE_COLOR RGBA(43,43,43)
//微博title颜色
#define WEIBO_TITLE_COLOR RGBA(43,43,43)

//待修改
#define BLUECOLOR RGBA(0, 150, 230)
//白色
#define White_Color  RGBA(255,255,255)
//黑色
#define Black_Color  RGBA(0,0,0)
//无色
#define Clear_Color  [UIColor clearColor]
//主色
#define Essential_Colour RGBA(51,51,51)
//副色
#define Deputy_Colour RGBA(153,153,153)
#define TempColore RGBA(118,72,48)

//背景色
#define Background_Color [NSString stringWithFormat:@"#f2f2f2"]
//#23ade5_蓝色
#define Blue_color [UIColor colorWithConvertString:@"#23ade5"]
//#7dc163_绿色
#define Green_color [UIColor colorWithConvertString:@"#7dc163"]
//Reading_color
#define Reading_color [UIColor colorWithConvertString:@"#fff2e2"]

//线条颜色
#define LINE_COLOR RGBA(223,219,210)
#define ICON_COLOR RGBA(172, 51, 39)//主色调

//header颜色
#define HEADER_COLOR RGBA(230, 225, 213)

#define ICON_COLOR RGBA(172, 51, 39)//主色调
#define LABEL_BACK_COLOR RGBA (246,245,243)

#define BG_COLOR RGBA(213,213,213)//cell背景颜色
#define BAR_COLOR RGBA(238,238,238)//发现bar背景颜色

#define Reading_color1 @"#fff2e2"
#define Reading_color2 @"#faf9de"
#define Reading_color3 @"#e3edcd"
#define Reading_color4 @"#dce2f1"
#define Reading_color5 @"#ffffff"

#define lineSpacingValue  8
#define lineSpacingValueOne  5

//Nav_title_font
/**
 *    15
 */
#define Nav_title_font 15
/**
 *    16
 */
#define Catalog_Cell_Name_Font 16
#define Catalog_Cell_Name_FontOne 14

/**
 *    13
 */
#define Catalog_Cell_info_Font 13
#define Catalog_Cell_info_FontOne 11

/**
 *    12
 */
#define Catalog_Cell_uname_Font 12
/**
 *    24
 */
#define ChapterFont 24
/**
 *    18
 */
#define Catalog_Cell_Name_Font_big 14

//百度视图拼接地址 %3A==:   %2F==/  %3F==?  %26==&  %3D== =   %21==!
#define baiDuShiTuUrl @"http://stu.baidu.com/n/search?queryImageUrl=%@"


//第三方相关
#define ShareSDKKEY @"10432de313f5c"

#define QQAPPID @"1103852506"
#define QQSecret @"31nSWUdy0VYZS9lg"

#define WeiXinAPPID @"wx8552ced954754b01"
#define WeiXinAPPSecret @"e675bb98a1262ae5adec6386949cdd55"

#define SinaAppKey @"3270491259"
#define SinaAppSecret @"76db59521aec24909ac80e557b9aeb62"
#define SinaAppURL @"http://sns.cangm.com"

#define GaoDeAppKey @"9e3c23f428e58448220847728f4ad0ca"
#define GaoDeRestKey @"6146bec53d1f46b5080ab040ccccc0cb"



//不知道干什么用
#define BASE_NAVIGATION_BACKGROUNDCOLOR [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1]
#define BASE_VIEW_BACKGROUNDCOLOR [UIColor colorWithRed:246/255.0 green:245/255.0 blue:243/255.0 alpha:1]
#define BASE_NAVIGATION_TITLECOLOR [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1]
#define BASE_NAVIGATION_TITLEFONT [UIFont systemFontOfSize:20.0]
#define BASE_NAVIGATION_BUTTONCOLOR [UIColor colorWithRed:190/255.0 green:71/255.0 blue:49/255.0 alpha:1]
#define BASE_NAVIGATION_BUTTONFONT [UIFont systemFontOfSize:16.0]
