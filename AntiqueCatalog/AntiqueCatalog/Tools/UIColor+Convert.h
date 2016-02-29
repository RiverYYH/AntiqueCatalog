//
//  UIColor+Convert.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/1.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Convert)

+ (UIColor *)colorWithConvertString:(NSString *)color;
//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithConvertString:(NSString *)color alpha:(CGFloat)alpha;

@end
