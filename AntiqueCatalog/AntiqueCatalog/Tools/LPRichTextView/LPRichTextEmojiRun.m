//
//  TQRichTextEmojiRun.m
//  TQRichTextViewDemo
//
//  Created by fuqiang on 13-9-21.
//  Copyright (c) 2013年 fuqiang. All rights reserved.
//

#import "LPRichTextEmojiRun.h"

@implementation LPRichTextEmojiRun

- (id)init
{
    self = [super init];
    if (self) {
        self.type = LPRichTextEmojiRunType;
        self.isResponseTouch = NO;
    }
    return self;
}

- (BOOL)drawRunWithRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    NSString *emojiString = [NSString stringWithFormat:@"%@.png",self.originalText];
    
    UIImage *image = [UIImage imageNamed:[[emojiString componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"[]"]] componentsJoinedByString:@""]];
    if (image)
    {
        CGContextDrawImage(context, rect, image.CGImage);
    }
    return YES;
}

+ (NSArray *) emojiStringArray
{
    return [NSArray arrayWithObjects:@"[微笑]",@"[撇嘴]",@"[色]",@"[发呆]",@"[得意]",@"[流泪]",@"[害羞]",@"[闭嘴]",@"[睡]",@"[大哭]",@"[尴尬]",@"[发怒]",@"[调皮]",@"[呲牙]",@"[惊讶]",@"[难过]",@"[酷]",@"[冷汗]",@"[抓狂]",@"[吐]",@"[偷笑]",@"[愉快]",@"[白眼]",@"[傲慢]",@"[饥饿]",@"[困]",@"[惊恐]",@"[流汗]",@"[憨笑]",@"[悠闲]",@"[奋斗]",@"[咒骂]",@"[疑问]",@"[嘘]",@"[晕]",@"[疯了]",@"[衰]",@"[骷髅]",@"[敲打]",@"[再见]",@"[擦汗]",@"[抠鼻]",@"[鼓掌]",@"[糗大了]",@"[坏笑]",@"[左哼哼]",@"[右哼哼]",@"[哈欠]",@"[鄙视]",@"[委屈]",@"[快哭了]",@"[阴险]",@"[亲亲]",@"[吓]",@"[可怜]",@"[菜刀]",@"[西瓜]",@"[啤酒]",@"[篮球]",@"[乒乓]",@"[咖啡]",@"[饭]",@"[猪头]",@"[玫瑰]",@"[凋谢]",@"[嘴唇]",@"[爱心]",@"[心碎]",@"[蛋糕]",@"[闪电]",@"[炸弹]",@"[刀]",@"[足球]",@"[瓢虫]",@"[便便]",@"[月亮]",@"[太阳]",@"[礼物]",@"[拥抱]",@"[强]",@"[弱]",@"[握手]",@"[胜利]",@"[抱拳]",@"[勾引]",@"[拳头]",@"[差劲]",@"[爱你]",@"[no]",@"[ok]",@"[爱情]",@"[飞吻]",@"[跳跳]",@"[发抖]",@"[怄火]",@"[转圈]",@"[磕头]",@"[回头]",@"[跳绳]",@"[投降]",@"[激动]",@"[街舞]",@"[献吻]",@"[左太极]",@"[右太极]",@"[weixiao]",@"[pizui]",@"[se]",@"[fadai]", @"[deyi]",@"[liulei]",@"[haixiu]",@"[bizui]",@"[shuijiao]",@"[daku]",@"[gangga]",@"[danu]",@"[tiaopi]",@"[ciya]",@"[jingya]",@"[nanguo]",@"[ku]",@"[lenghan]",@"[zhemo]",@"[tu]",@"[touxiao]",@"[keai]",@"[baiyan]",@"[aoman]",@"[e]",@"[kun]",@"[jingkong]",@"[liuhan]",@"[haha]",@"[dabing]",@"[fendou]",@"[ma]",@"[wen]",@"[xu]",@"[yun]",@"[zhuakuang]",@"[shuai]",@"[kulou]",@"[da]",@"[zaijian]",@"[cahan]",@"[wabi]",@"[guzhang]",@"[qioudale]",@"[huaixiao]",@"[zuohengheng]",@"[youhengheng]",@"[haqian]",@"[bishi]",@"[weiqu]",@"[kuaikule]",@"[yinxian]",@"[qinqin]",@"[xia]",@"[kelian]",@"[caidao]",@"[xigua]",@"[pijiu]",@"[lanqiu]",@"[pingpang]",@"[kafei]",@"[fan]",@"[zhutou]",@"[hua]",@"[diaoxie]",@"[kiss]",@"[love]",@"[xinsui]",@"[dangao]",@"[shandian]",@"[zhadan]",@"[dao]",@"[qiu]",@"[chong]",@"[dabian]",@"[yueliang]",@"[taiyang]",@"[liwu]",@"[yongbao]",@"[qiang]",@"[ruo]",@"[woshou]",@"[shengli]",@"[peifu]",@"[gouyin]",@"[quantou]",@"[chajin]",@"[aini]",@"[aiqing]",@"[feiwen]",@"[tiao]",@"[fadou]",@"[dajiao]",@"[zhuanquan]",@"[ketou]",@"[huitou]",@"[tiaosheng]",@"[huishou]",@"[jidong]",@"[tiaowu]",@"[xianwen]",@"[zuotaiji]",@"[youtaiji]",nil];
}


+ (NSString *)analyzeText:(NSString *)string  runsArray:(NSMutableArray **)runArray
{
    NSString *markL = @"[";
    NSString *markR = @"]";
    NSMutableArray *stack = [[NSMutableArray alloc] init];
    NSMutableString *newString = [[NSMutableString alloc] initWithCapacity:string.length];
    
    //偏移索引 由于会把长度大于1的字符串替换成一个空白字符。这里要记录每次的偏移了索引。以便简历下一次替换的正确索引
    int offsetIndex = 0;
    
    for (int i = 0; i < string.length; i++)
    {
        NSString *s = [string substringWithRange:NSMakeRange(i, 1)];
        
        if (([s isEqualToString:markL]) || ((stack.count > 0) && [stack[0] isEqualToString:markL]))
        {
            if (([s isEqualToString:markL]) && ((stack.count > 0) && [stack[0] isEqualToString:markL]))
            {
                for (NSString *c in stack)
                {
                    [newString appendString:c];
                }
                [stack removeAllObjects];
            }
            
            [stack addObject:s];
            
            if ([s isEqualToString:markR] || (i == string.length - 1))
            {
                NSMutableString *emojiStr = [[NSMutableString alloc] init];
                for (NSString *c in stack)
                {
                    [emojiStr appendString:c];
                }
                if ([[LPRichTextEmojiRun emojiStringArray] containsObject:emojiStr])
                {
                    if (*runArray)
                    {
                        LPRichTextEmojiRun *emoji = [[LPRichTextEmojiRun alloc] init];
                        emoji.range = NSMakeRange(i + 1 - emojiStr.length - offsetIndex, 1);
                        emoji.originalText = emojiStr;
                        emoji.isResponseTouch = NO;
                        [*runArray addObject:emoji];
                    }
                    [newString appendString:@"藏"];
                    
                    offsetIndex += emojiStr.length - 1;
                }
                else
                {
                    [newString appendString:emojiStr];
                }
                
                [stack removeAllObjects];
            }
        }
        else
        {
            [newString appendString:s];
        }
    }
    
    return newString;
}

@end
