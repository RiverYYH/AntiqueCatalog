//
//  TQRichTextBaseRun.h
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreText/CoreText.h>

typedef enum LPRichTextRunType
{
    //-- URL文本单元类型
    LPRichTextURLRunType,
    LPRichTextATRunType,
    LPRichTextTopicRunType,
    //-- 表情文本单元类型
    LPRichTextEmojiRunType
}LPRichTextRunType;

@interface LPRichTextBaseRun : NSObject

//-- 文本单元类型
@property (nonatomic) LPRichTextRunType type;

//-- 原始文本
@property (nonatomic,copy) NSString *originalText;
// addBy iOS_TS 如果是网址链接
@property (nonatomic,copy) NSString *linkText;

//-- 原始字体
@property (nonatomic,strong) UIFont *originalFont;

//-- 文本所在位置
@property (nonatomic) NSRange range;

//-- 是否响应触摸
@property (nonatomic) BOOL isResponseTouch;

//-- 替换基本文本样式
- (void)replaceTextWithAttributedString:(NSMutableAttributedString*) attributedString;

//-- 绘制内容 (YES 表示这个函数自己绘制，NO表示CoreText绘制)
- (BOOL)drawRunWithRect:(CGRect)rect;


@end
