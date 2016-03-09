//
//  TQRichTextURLRun.h
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-23.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "LPRichTextBaseRun.h"

@interface LPRichTextURLRun : LPRichTextBaseRun

+ (NSString *)analyzeText:(NSString *)string runsArray:(NSMutableArray **)array;
+ (NSString *)analyzeAtText:(NSString *)string runsArray:(NSMutableArray **)runArray;
+ (NSString *)analyzeTopicText:(NSString *)string runsArray:(NSMutableArray **)runArray;
@end
