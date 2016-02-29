//
//  Allview.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/2.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Allview : NSObject

/**
 *  获取一个button
 *  lineBreak标题行数
 *  contentVertical是否居中
 *  string标题
 *  color标题颜色
 *  font字号
 *  bgcolor背景色
 *  cornerRadius角度
 */
+(UIButton *)WithlineBreak:(NSInteger)lineBreak WithcontentVerticalAlignment:(UIControlContentVerticalAlignment *)contentVertical WithString:(NSString *)string Withcolor:(UIColor *)color WithSelectcolor:(UIColor *)Selectcolor Withfont:(CGFloat)font WithBgcolor:(UIColor *)Bgcolor WithcornerRadius:(CGFloat)cornerRadius Withbold:(BOOL)bold;

/**
 *  获取一个imageview
 *  imagename图片名
 *  cornerRadius角度
 *  Bgcolor背景颜色
 *  @author huihao, 15-10-08 17:10:21
 */
+(UIImageView *)Withimagename:(NSString *)imagename WithcornerRadius:(CGFloat)cornerRadius WithBgcolor:(UIColor *)Bgcolor;

/**
 *  获取一个label
 *  string标题
 *  textAlignment是否居中
 *  color标题颜色
 *  font字号
 *  bgcolor背景色
 */
+(UILabel *)Withstring:(NSString *)string Withcolor:(UIColor *)color Withbgcolor:(UIColor *)bgcolor Withfont:(CGFloat)font WithLineBreakMode:(NSInteger)lineBreakMode WithTextAlignment:(NSTextAlignment)textAlignment;

/**
 *  获取Lable的Size
 *  @param string_传字符串
 *  @param font_传字号
 *  @param Width_传宽度
 *  @param view_传控件
 *  @param integer_传行数
 */

+(CGSize)String:(NSString *)string Withfont:(CGFloat)font WithCGSize:(CGFloat)Width Withview:(UILabel *)view Withinteger:(NSInteger)integer;

/**
 *  获取button的Size
 *  @param string_传字符串
 *  @param font_传字号
 *  @param Width_传宽度
 *  @param view_传控件
 *  @param integer_传行数
 */

+(CGSize)string:(NSString *)string Withfont:(CGFloat)font WithCGSize:(CGFloat)Width Withview:(UIButton *)button Withinteger:(NSInteger)integer;


@end
