//
//  TQRichTextURLRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-23.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "LPRichTextURLRun.h"

@implementation LPRichTextURLRun
{
    BOOL _isLink;
}
- (id)init
{
    self = [super init];
    if (self) {
        self.type = LPRichTextURLRunType;
        self.isResponseTouch = YES;
    }
    return self;
}

//-- 替换基础文本
- (void)replaceTextWithAttributedString:(NSMutableAttributedString*) attributedString
{
    if ([attributedString.string rangeOfString:@"[活动详情]"].location != NSNotFound)
    {
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RGBA(0, 150, 230).CGColor range:NSMakeRange(self.range.location, 6)];
        [attributedString addAttribute:@"TQRichTextAttribute" value:self range:NSMakeRange(self.range.location, 6)];
        return;
    }
	
	if ([attributedString.string rangeOfString:@"[网页链接]"].location != NSNotFound)
    {
        [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RGBA(0, 150, 230).CGColor range:NSMakeRange(self.range.location, 6)];
        [attributedString addAttribute:@"TQRichTextAttribute" value:self range:NSMakeRange(self.range.location, 6)];
        return;
    }
	
    [attributedString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)RGBA(0, 150, 230).CGColor range:self.range];
    [attributedString addAttribute:@"TQRichTextAttribute" value:self range:self.range];
}

//-- 绘制内容
- (BOOL)drawRunWithRect:(CGRect)rect
{
    return NO;
}

//-- 解析文本内容 --HTML
+ (NSString *)analyzeText:(NSString *)string runsArray:(NSMutableArray **)runArray
{
    NSError *error;
    NSString *regulaStr = @"\\bhttps?://[a-zA-Z0-9\\-.]+(?::(\\d+))?(?:(?:/[a-zA-Z0-9\\-._?,'+\\&%$=~*!():@\\\\]*)+)?";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        
        NSString* substringForMatch = [string substringWithRange:match.range];

        LPRichTextURLRun *urlRun = [[LPRichTextURLRun alloc] init];
        urlRun.range = match.range;
        urlRun.type = LPRichTextURLRunType;
        urlRun.originalText = substringForMatch;
        [*runArray addObject:urlRun];
        if ([substringForMatch rangeOfString:@"index.php?app=event"].location != NSNotFound)
        {
           string = [string stringByReplacingOccurrencesOfString:substringForMatch withString:@"[活动详情]"];
        }else if ([substringForMatch rangeOfString:@"index.php?app=public"].location != NSNotFound||[substringForMatch rangeOfString:@"http://www.gymboclub.com"].location != NSNotFound)
        {
			string = [string stringByReplacingOccurrencesOfString:substringForMatch withString:@"[网页链接]"];
        }
		
    }
    return [string copy];
}
// ADD BY iOS_TS
//-- 解析at文本内容 --AT
+ (NSString *)analyzeAtText:(NSString *)string runsArray:(NSMutableArray **)runArray
{
    NSError *error;
    NSString *regulaStr =@"(@\\b(\\w+)\\b)";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        LPRichTextURLRun *urlRun = [[LPRichTextURLRun alloc] init];
        urlRun.range = match.range;
        urlRun.type = LPRichTextATRunType;
        urlRun.originalText = substringForMatch;
        [*runArray addObject:urlRun];
    }
    return [string copy];
}

// ADD BY iOS_TS
//-- 解析Topic文本内容 -- 专辑
+ (NSString *)analyzeTopicText:(NSString *)string runsArray:(NSMutableArray **)runArray
{
    NSError *error;
	//(#\\b(\\w+)#)
    NSString *regulaStr = @"#([^\\#|.]+)#";
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:regulaStr
                                                                           options:NSRegularExpressionCaseInsensitive
                                                                             error:&error];
    NSArray *arrayOfAllMatches = [regex matchesInString:string options:0 range:NSMakeRange(0, [string length])];
    for (NSTextCheckingResult *match in arrayOfAllMatches)
    {
        NSString* substringForMatch = [string substringWithRange:match.range];
        LPRichTextURLRun *urlRun = [[LPRichTextURLRun alloc] init];
        urlRun.range = match.range;
        urlRun.type = LPRichTextTopicRunType;
        urlRun.originalText = substringForMatch;
        [*runArray addObject:urlRun];
    }
    return [string copy];
}


@end
