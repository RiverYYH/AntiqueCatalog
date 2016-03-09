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
//全局背景色
#define  Global_Background RGBA(224,224,224)
//title颜色
#define TITLE_COLOR RGBA(43,43,43)
//content颜色+placeholder颜色+微博time
#define CONTENT_COLOR RGBA(153,153,153)

//通过RGB设置颜色
#define RGBA(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
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
/**
 *    13
 */
#define Catalog_Cell_info_Font 13
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
#define Catalog_Cell_Name_Font_big 16



//第三方相关
#define APPICON [[NSBundle mainBundle] pathForResource:@"Icon@2x" ofType:@"png"]
#define DEFAULTCONTENT @"来自到处是宝的邀请" //默认分享内容


