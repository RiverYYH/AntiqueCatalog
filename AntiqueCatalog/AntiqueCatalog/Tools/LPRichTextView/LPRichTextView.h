//
//  TQRichTextView.h
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-12.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPRichTextBaseRun.h"

@class LPRichTextView;

@protocol LPRichTextViewDelegate<NSObject>

@optional
- (void)richTextView:(LPRichTextView *)view touchBeginRun:(LPRichTextBaseRun *)run;
- (void)richTextView:(LPRichTextView *)view touchEndRun:(LPRichTextBaseRun *)run;
- (void)touchClick:(LPRichTextView *)view;
@end

@interface LPRichTextView : UIView

@property(nonatomic,copy)   NSString           *text;            // default is @""
@property(nonatomic,strong) UIFont             *font;            // default is [UIFont systemFontOfSize:12.0]
@property(nonatomic,strong) UIColor            *textColor;       // default is [UIColor blackColor]
@property(nonatomic)        float               lineSpacing;     // default is 1.5 行间距
@property(nonatomic)        float               characterSpacing;//字间距

//-- 特殊的文本数组。在绘制的时候绘制
@property(nonatomic,readonly)       NSMutableArray *richTextRunsArray;
//-- 特熟文本的绘图边界字典。用来做点击处理定位
@property(nonatomic,readonly)       NSMutableDictionary *richTextRunRectDic;
//-- 原文本通过解析后的文本
@property(nonatomic,readonly,copy)  NSString        *textAnalyzed;
//-- 属性字符串
@property(nonatomic,copy)       NSMutableAttributedString *attString;

@property(nonatomic)       NSRange range;
@property(nonatomic)       NSRange range1;

@property(nonatomic,strong) UIColor            *rangeColor;

//-- 文本行数。
@property(nonatomic,readonly)       NSInteger  lineCount;
//-- delegage
@property(nonatomic,weak) id<LPRichTextViewDelegate> delegage;

@property (nonatomic) BOOL isChat;//判断需要识别@和专辑

//-- 通过字符串计算文本控件的高度
+ (CGFloat)getRechTextViewHeightWithText:(NSString *)text viewWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;
//-- 聊天界面通过设置字间距计算高度,为了保证其他界面正常显示
- (CGFloat)getRechTextViewChatHeightWithText:(NSString *)text viewWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;
//-- 通过字符串计算文本控件的宽度
- (CGFloat)getRechTextViewWithWithText:(NSString *)text viewWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing;
//-- 点击界面后。由于touch事件被截取，为了保证点击事件正常执行
- (void)touchesWithPoint:(CGPoint)location;
@end
