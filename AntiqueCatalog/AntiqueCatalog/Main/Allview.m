//
//  Allview.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/2.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "Allview.h"

@implementation Allview

+(UIButton *)WithlineBreak:(NSInteger)lineBreak WithcontentVerticalAlignment:(UIControlContentVerticalAlignment *)contentVertical WithString:(NSString *)string Withcolor:(UIColor *)color WithSelectcolor:(UIColor *)Selectcolor Withfont:(CGFloat)font WithBgcolor:(UIColor *)Bgcolor WithcornerRadius:(CGFloat)cornerRadius Withbold:(BOOL)bold
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.lineBreakMode = lineBreak;
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = cornerRadius;
    
    btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    if (bold) {
        btn.titleLabel.font = [UIFont boldSystemFontOfSize:font];
    }else{
        btn.titleLabel.font = [UIFont systemFontOfSize:font];
    }
    
    [btn setTitle:string  forState:UIControlStateNormal];
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:Selectcolor forState:UIControlStateSelected];
    [btn setBackgroundColor:Bgcolor];    
    
    
    return btn;
}

+(UIImageView *)Withimagename:(NSString *)imagename WithcornerRadius:(CGFloat)cornerRadius WithBgcolor:(UIColor *)colors
{
    UIImageView *imageview = [[UIImageView alloc]init];
    imageview.image = [UIImage imageNamed:imagename];
    imageview.layer.masksToBounds = YES;
    imageview.layer.cornerRadius = cornerRadius;
    imageview.backgroundColor = colors;
    return imageview;
}

+(UILabel *)Withstring:(NSString *)string Withcolor:(UIColor *)color Withbgcolor:(UIColor *)bgcolor Withfont:(CGFloat)font WithLineBreakMode:(NSInteger)lineBreakMode WithTextAlignment:(NSTextAlignment)textAlignment
{
    UILabel *lab = [[UILabel alloc]init];
    
//    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:5];
//    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [string length])];
//    lab.attributedText = attributedString;
    
    lab.text = string;
    lab.textColor = color;
    lab.backgroundColor = bgcolor;
    lab.font = [UIFont systemFontOfSize:font];
    lab.numberOfLines = lineBreakMode;
    lab.textAlignment = textAlignment;
    
    
    
    return lab;
}


+(CGSize)String:(NSString *)string Withfont:(CGFloat)font WithCGSize:(CGFloat)Width Withview:(UILabel *)view Withinteger:(NSInteger)integer
{
    view.numberOfLines = integer;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font],NSFontAttributeName,nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(Width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}

+(CGSize)string:(NSString *)string Withfont:(CGFloat)font WithCGSize:(CGFloat)Width Withview:(UIButton *)button Withinteger:(NSInteger)integer
{
    button.titleLabel.lineBreakMode = integer;
    NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont boldSystemFontOfSize:font],NSFontAttributeName,nil];
    CGSize size = [string boundingRectWithSize:CGSizeMake(Width, CGFLOAT_MAX) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    return size;
}


@end
