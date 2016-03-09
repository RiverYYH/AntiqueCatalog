//
//  TQRichTextImageRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "LPRichTextImageRun.h"
#import <CoreText/CoreText.h>

static const float kZoom = 1.1f;

@implementation LPRichTextImageRun

- (void)replaceTextWithAttributedString:(NSMutableAttributedString*) attString
{
    //删除替换的占位字符
    [attString deleteCharactersInRange:self.range];
    
    CTRunDelegateCallbacks emojiCallbacks;
    emojiCallbacks.version      = kCTRunDelegateVersion1;
    emojiCallbacks.dealloc      = LPRichTextRunEmojiDelegateDeallocCallback;
    emojiCallbacks.getAscent    = LPRichTextRunEmojiDelegateGetAscentCallback;
    emojiCallbacks.getDescent   = LPRichTextRunEmojiDelegateGetDescentCallback;
    emojiCallbacks.getWidth     = LPRichTextRunEmojiDelegateGetWidthCallback;

    unichar chars = 0xFFFC;
    NSMutableAttributedString *imageAttributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithCharacters:&chars length:1]];
    //
    CTRunDelegateRef runDelegate = CTRunDelegateCreate(&emojiCallbacks, (__bridge void*)self);
    [imageAttributedString addAttribute:(NSString *)kCTRunDelegateAttributeName value:(__bridge id)runDelegate range:NSMakeRange(0, 1)];
    CFRelease(runDelegate);
    
    [attString insertAttributedString:imageAttributedString atIndex:self.range.location];
    
    [super replaceTextWithAttributedString:attString];
}

#pragma mark - RunDelegateCallback

void LPRichTextRunEmojiDelegateDeallocCallback(void *refCon)
{

}

//--上行高度
CGFloat LPRichTextRunEmojiDelegateGetAscentCallback(void *refCon)
{
    LPRichTextImageRun *run =(__bridge LPRichTextImageRun *) refCon;
    return run.originalFont.ascender * kZoom;
}

//--下行高度
CGFloat LPRichTextRunEmojiDelegateGetDescentCallback(void *refCon)
{
    LPRichTextImageRun *run =(__bridge LPRichTextImageRun *) refCon;
    return run.originalFont.descender * kZoom;
}

//-- 宽
CGFloat LPRichTextRunEmojiDelegateGetWidthCallback(void *refCon)
{
    LPRichTextImageRun *run =(__bridge LPRichTextImageRun *) refCon;
    return (run.originalFont.ascender - run.originalFont.descender) * kZoom;
}

@end
