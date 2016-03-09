//
//  TQRichTextView.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-12.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "LPRichTextView.h"
#import <CoreText/CoreText.h>
#import "LPRichTextEmojiRun.h"
#import "LPRichTextURLRun.h"
@implementation LPRichTextView

@synthesize range,range1;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _text = @"";
//		_range = 
//		_attString = [[NSMutableAttributedString alloc]initWithString:@""];
        _font = [UIFont systemFontOfSize:12.0];
        _lineSpacing = 1.5;
        _characterSpacing = 0.5;
        _richTextRunsArray = [[NSMutableArray alloc] init];
        _richTextRunRectDic = [[NSMutableDictionary alloc] init];
    }
    return self;
}

#pragma mark - Draw Rect
- (void)drawRect:(CGRect)rect
{
    [self.richTextRunsArray removeAllObjects];
    [self.richTextRunRectDic removeAllObjects];
    //解析文本
    _textAnalyzed = [LPRichTextView analyzeText:_text textRunsArray:self.richTextRunsArray font:self.font andIsChat:_isChat];
    //要绘制的文本
    _attString = [[NSMutableAttributedString alloc] initWithString:self.textAnalyzed];
    //设置字体
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)self.font.fontName, self.font.pointSize, NULL);
    [self.attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:NSMakeRange(0,self.attString.length)];
    CFRelease(aFont);
    
    [self.attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:(id)self.textColor .CGColor range:NSMakeRange(0,self.attString.length)];
	
	[self.attString addAttribute:(NSString *)kCTForegroundColorAttributeName value:RGBA(0, 150, 230) range:range];
	
	[self.attString addAttribute:(NSString *)kCTForegroundColorAttributeName value: [UIColor colorWithRed:57/255.0 green:59/255.0 blue:61/255.0 alpha:1.0] range:range1];


    //设置字间距
    long number = _characterSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [self.attString addAttribute:(NSString*)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[self.attString length])];
    CFRelease(num);
    
    CTParagraphStyleSetting lineBreakMode;
    CTLineBreakMode lineBreak = kCTLineBreakByCharWrapping;//换行模式
    lineBreakMode.spec = kCTParagraphStyleSpecifierLineBreakMode;
    lineBreakMode.value = &lineBreak;
    lineBreakMode.valueSize = sizeof(CTLineBreakMode);
    //组合设置
    CTParagraphStyleSetting settings[] = {
        lineBreakMode,
    };
    //通过设置项产生段落样式对象
    CTParagraphStyleRef style = CTParagraphStyleCreate(settings, 1);
    // build attributes
    NSMutableDictionary *attributes = [NSMutableDictionary dictionaryWithObject:(__bridge id)style forKey:(id)kCTParagraphStyleAttributeName ];
    [self.attString addAttributes:attributes range:NSMakeRange(0, self.attString.length)];
    CFRelease(style);

    //文本处理
    for (LPRichTextBaseRun *textRun in self.richTextRunsArray)
    {
        [textRun replaceTextWithAttributedString:self.attString];
    }
    //绘图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    //修正坐标系
    CGAffineTransform textTran = CGAffineTransformIdentity;
    textTran = CGAffineTransformMakeTranslation(0.0, self.bounds.size.height);
    textTran = CGAffineTransformScale(textTran, 1.0, -1.0);
    CGContextConcatCTM(context, textTran);
    //绘制
    _lineCount = 0;
    CFRange lineRange = CFRangeMake(0,0);
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)self.attString);
    float drawLineX = 0;
    float drawLineY = self.bounds.origin.y + self.bounds.size.height - self.font.ascender;
    BOOL drawFlag = YES;
    [self.richTextRunRectDic removeAllObjects];
    
    while(drawFlag)
    {
        CFIndex testLineLength = CTTypesetterSuggestLineBreak(typeSetter,lineRange.location,self.bounds.size.width);
check:
        lineRange = CFRangeMake(lineRange.location,testLineLength);
        CTLineRef line = CTTypesetterCreateLine(typeSetter,lineRange);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        //边界检查
        CTRunRef lastRun = CFArrayGetValueAtIndex(runs, CFArrayGetCount(runs) - 1);
        CGFloat lastRunAscent;
        CGFloat laseRunDescent;
        CGFloat lastRunWidth  = CTRunGetTypographicBounds(lastRun, CFRangeMake(0,0), &lastRunAscent, &laseRunDescent, NULL);
        CGFloat lastRunPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lastRun).location, NULL);
        
        if ((lastRunWidth + lastRunPointX) > self.bounds.size.width)
        {
            testLineLength--;
            if (testLineLength < 0) {
                break;
            }
            CFRelease(line);
goto check;
        }
        
        //绘制普通行元素
        drawLineX = CTLineGetPenOffsetForFlush(line,0,self.bounds.size.width);
        CGContextSetTextPosition(context,drawLineX,drawLineY);
        CTLineDraw(line,context);
        
        //绘制替换过的特殊文本单元

        for (int i = 0; i < CFArrayGetCount(runs); i++)
        {
            CTRunRef run = CFArrayGetValueAtIndex(runs, i);
            NSDictionary* attributes = (__bridge NSDictionary*)CTRunGetAttributes(run);
            LPRichTextBaseRun *textRun = [attributes objectForKey:@"TQRichTextAttribute"];
            if (textRun)
            {
                CGFloat runAscent,runDescent;
                CGFloat runWidth  = CTRunGetTypographicBounds(run, CFRangeMake(0,0), &runAscent, &runDescent, NULL);
                CGFloat runHeight = runAscent + (-runDescent);
                CGFloat runPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(run).location, NULL);
                CGFloat runPointY = drawLineY - (-runDescent);

                CGRect runRect = CGRectMake(runPointX, runPointY, runWidth, runHeight);
                BOOL isDraw = [textRun drawRunWithRect:runRect];
                if (textRun.isResponseTouch)
                {
                    if (isDraw)
                    {
                        [self.richTextRunRectDic setObject:textRun forKey:[NSValue valueWithCGRect:runRect]];
                    }
                    else
                    {
                        runRect = CTRunGetImageBounds(run, context, CFRangeMake(0, 0));
                        runRect.origin.x = runPointX;
                        [self.richTextRunRectDic setObject:textRun forKey:[NSValue valueWithCGRect:runRect]];
                    }
                }
            }
        }
        CFRelease(line);
        if(lineRange.location + lineRange.length >= self.attString.length)
        {
            drawFlag = NO;
        }
        _lineCount++;
        drawLineY -= self.font.ascender + (- self.font.descender) + self.lineSpacing;
        lineRange.location += lineRange.length;
    }
    CFRelease(typeSetter);
}
#pragma mark - Analyze Text
+ (NSString *)analyzeText:(NSString *)string textRunsArray:(NSMutableArray *)runArray font:(UIFont *)font andIsChat:(BOOL)isChat
{
    NSString *result = @"";

    result = [LPRichTextEmojiRun analyzeText:string runsArray:&runArray];
    result = [LPRichTextURLRun analyzeText:result runsArray:&runArray];

    // add by iOS_TS
    if(!isChat) {
        result = [LPRichTextURLRun analyzeAtText:result runsArray:&runArray];
        result = [LPRichTextURLRun analyzeTopicText:result runsArray:&runArray];
    }
    [runArray makeObjectsPerformSelector:@selector(setOriginalFont:) withObject:font];
//    if (result.length > 140 )
//    {
//        result = [result substringToIndex:140];
//        result = [NSString stringWithFormat:@"%@...",result];
//    }
    return result;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    if (self.delegage && [self.delegage respondsToSelector:@selector(richTextView: touchBeginRun:)])
    {
        __block BOOL flag = NO;
        __weak LPRichTextView *weakSelf = self;
        [self.richTextRunRectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
             CGRect rect = [((NSValue *)key) CGRectValue];
             LPRichTextBaseRun *run = obj;
             if(CGRectContainsPoint(rect, runLocation))
             {
                 flag = YES;
                 [weakSelf.delegage richTextView:weakSelf touchBeginRun:run];
             }
         }];
        if (!flag && [self.delegage respondsToSelector:@selector(richTextView: touchEndRun:)])
        {
//            NSLog(@"5555555");
        }
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    CGPoint location = [(UITouch *)[touches anyObject] locationInView:self];
    [self touchesWithPoint:location];
}
- (void)touchesWithPoint:(CGPoint)location
{
    CGPoint runLocation = CGPointMake(location.x, self.frame.size.height - location.y);
    if (self.delegage && [self.delegage respondsToSelector:@selector(richTextView: touchEndRun:)])
    {
        __block BOOL flag = NO;
        [self.richTextRunRectDic enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop)
         {
             __weak LPRichTextView *weakSelf = self;
             CGRect rect = [((NSValue *)key) CGRectValue];
             LPRichTextBaseRun *run = obj;
             if(CGRectContainsPoint(rect, runLocation))
             {
                 flag = YES;
                 [weakSelf.delegage richTextView:weakSelf touchEndRun:run];
             }
         }];
        if (!flag && [self.delegage respondsToSelector:@selector(touchClick:)])
        {
            //            NSLog(@"5555555");
            [self.delegage touchClick:self];
        }
    }
}

#pragma mark - Set
- (void)setText:(NSString *)text
{
    [self setNeedsDisplay];
    _text = text;
}

- (void)setFont:(UIFont *)font
{
    [self setNeedsDisplay];
    _font = font;
}

- (void)setTextColor:(UIColor *)textColor
{
    [self setNeedsDisplay];
    _textColor = textColor;
}

- (void)setLineSpacing:(float)lineSpacing
{
    [self setNeedsDisplay];
    _lineSpacing = lineSpacing;
}
- (void)setCharacterSpacing:(float)characterSpacing
{
    [self setNeedsDisplay];
    _characterSpacing = characterSpacing;
}
#pragma mark -
+ (CGFloat)getRechTextViewHeightWithText:(NSString *)text
                               viewWidth:(CGFloat)width
                                    font:(UIFont *)font
                             lineSpacing:(CGFloat)lineSpacing;
{
    NSString *analyzeText = [LPRichTextView analyzeText:text textRunsArray:nil font:font andIsChat:NO];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:analyzeText];
    
    //设置字体
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:NSMakeRange(0,attString.length)];
    CFRelease(aFont);
    
    int lineCount = 0;
    CFRange lineRange = CFRangeMake(0,0);
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    float drawLineX = 0;
    float drawLineY = 0;
    BOOL drawFlag = YES;
    
    while(drawFlag)
    {
        CFIndex testLineLength = CTTypesetterSuggestLineBreak(typeSetter,lineRange.location,width);
    check:  lineRange = CFRangeMake(lineRange.location,testLineLength);
        CTLineRef line = CTTypesetterCreateLine(typeSetter,lineRange);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        
        //边界检查
        CTRunRef lastRun = CFArrayGetValueAtIndex(runs, CFArrayGetCount(runs) - 1);
        CGFloat lastRunAscent;
        CGFloat laseRunDescent;
        CGFloat lastRunWidth  = CTRunGetTypographicBounds(lastRun, CFRangeMake(0,0), &lastRunAscent, &laseRunDescent, NULL);
        CGFloat lastRunPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lastRun).location, NULL);
        
        if ((lastRunWidth + lastRunPointX) > width)
        {
            testLineLength--;
            CFRelease(line);
            goto check;
        }
        
        CFRelease(line);
        
        if(lineRange.location + lineRange.length >= attString.length)
        {
            drawFlag = NO;
        }
        
        lineCount++;
        drawLineY += font.ascender + (- font.descender) + lineSpacing;
        lineRange.location += lineRange.length;
    }
    CFRelease(typeSetter);
    return drawLineY;
}
- (CGFloat)getRechTextViewChatHeightWithText:(NSString *)text viewWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSMutableArray *richTextRunsArray = [[NSMutableArray alloc] init];
    NSString *analyzeText = [LPRichTextView analyzeText:text textRunsArray:richTextRunsArray font:font andIsChat:_isChat];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:analyzeText];
    
    //设置字体
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:NSMakeRange(0,attString.length)];
    CFRelease(aFont);
    
    long number = _characterSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attString addAttribute:(NSString*)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attString length])];
    CFRelease(num);

    //文本处理
    for (LPRichTextBaseRun *textRun in richTextRunsArray)
    {
        [textRun replaceTextWithAttributedString:attString];
    }
    
    int lineCount = 0;
    CFRange lineRange = CFRangeMake(0,0);
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    float drawLineX = 0;
    float drawLineY = 0;
    BOOL drawFlag = YES;
    
    while(drawFlag)
    {
        CFIndex testLineLength = CTTypesetterSuggestLineBreak(typeSetter,lineRange.location,width);
    check:  lineRange = CFRangeMake(lineRange.location,testLineLength);
        CTLineRef line = CTTypesetterCreateLine(typeSetter,lineRange);
        CFArrayRef runs = CTLineGetGlyphRuns(line);

        //边界检查
        CTRunRef lastRun = CFArrayGetValueAtIndex(runs, CFArrayGetCount(runs) - 1);
        CGFloat lastRunAscent;
        CGFloat laseRunDescent;
        CGFloat lastRunWidth  = CTRunGetTypographicBounds(lastRun, CFRangeMake(0,0), &lastRunAscent, &laseRunDescent, NULL);
        CGFloat lastRunPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lastRun).location, NULL);
        
        if ((lastRunWidth + lastRunPointX) > width)
        {
            testLineLength--;
            CFRelease(line);
            goto check;
        }
        
        CFRelease(line);
        
        if(lineRange.location + lineRange.length >= attString.length)
        {
            drawFlag = NO;
        }
        
        lineCount++;
        drawLineY += font.ascender + (- font.descender) + lineSpacing;
        lineRange.location += lineRange.length;
    }
    CFRelease(typeSetter);
    return drawLineY;
}

- (CGFloat)getRechTextViewWithWithText:(NSString *)text viewWidth:(CGFloat)width font:(UIFont *)font lineSpacing:(CGFloat)lineSpacing
{
    NSMutableArray *richTextRunsArray = [[NSMutableArray alloc] init];
    NSString *analyzeText = [LPRichTextView analyzeText:text textRunsArray:richTextRunsArray font:font andIsChat:_isChat];
    NSMutableAttributedString *attString = [[NSMutableAttributedString alloc] initWithString:analyzeText];
    
    //设置字体
    CTFontRef aFont = CTFontCreateWithName((__bridge CFStringRef)font.fontName, font.pointSize, NULL);
    [attString addAttribute:(NSString*)kCTFontAttributeName value:(__bridge id)aFont range:NSMakeRange(0,attString.length)];
    CFRelease(aFont);
    
    long number = _characterSpacing;
    CFNumberRef num = CFNumberCreate(kCFAllocatorDefault,kCFNumberSInt8Type,&number);
    [attString addAttribute:(NSString*)kCTKernAttributeName value:(__bridge id)num range:NSMakeRange(0,[attString length])];
    CFRelease(num);
    
    //文本处理
    for (LPRichTextBaseRun *textRun in richTextRunsArray)
    {
        [textRun replaceTextWithAttributedString:attString];
    }
    
    CFRange lineRange = CFRangeMake(0,0);
    CTTypesetterRef typeSetter = CTTypesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attString);
    float drawLineX = 0;
    CFIndex testLineLength = CTTypesetterSuggestLineBreak(typeSetter,lineRange.location,width);
    lineRange = CFRangeMake(lineRange.location,testLineLength);
    CTLineRef line = CTTypesetterCreateLine(typeSetter,lineRange);
    CFArrayRef runs = CTLineGetGlyphRuns(line);
    
    //边界检查
    CTRunRef lastRun = CFArrayGetValueAtIndex(runs, CFArrayGetCount(runs) - 1);
    CGFloat lastRunAscent;
    CGFloat laseRunDescent;
    CGFloat lastRunWidth  = CTRunGetTypographicBounds(lastRun, CFRangeMake(0,0), &lastRunAscent, &laseRunDescent, NULL);
    CGFloat lastRunPointX = drawLineX + CTLineGetOffsetForStringIndex(line, CTRunGetStringRange(lastRun).location, NULL);
    
    if ((lastRunWidth + lastRunPointX) > width)
    {
        drawLineX = width;
    } else {
        drawLineX = lastRunWidth + lastRunPointX;
    }
    
    CFRelease(line);
    CFRelease(typeSetter);
    
    return drawLineX;

}
@end
