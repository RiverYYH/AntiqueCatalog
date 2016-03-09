//
//  ExpressionView.m
//  Class_iPhone
//
//  Created by JingXiaoLiang on 13-3-7.
//
//

#import "ExpressionView.h"

@implementation ExpressionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        
    }
    return self;
}

-(void)loadFacialView:(int)page size:(CGSize)size
{
	//row number
	for (int i=0; i<4; i++) {
		//column numer
		for (int y=0; y<7; y++) {
			UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
			NSArray *imageAry = [NSArray arrayWithObjects:@"微笑",@"撇嘴",@"色",@"发呆",@"得意",@"流泪",@"害羞",@"闭嘴",@"睡",@"大哭",@"尴尬",@"发怒",@"调皮",@"呲牙",@"惊讶",@"难过",@"酷",@"冷汗",@"抓狂",@"吐",@"偷笑",@"愉快",@"白眼",@"傲慢",@"饥饿",@"困",@"惊恐",@"流汗",@"憨笑",@"悠闲",@"奋斗",@"咒骂",@"疑问",@"嘘",@"晕",@"疯了",@"衰",@"骷髅",@"敲打",@"再见",@"擦汗",@"抠鼻",@"鼓掌",@"糗大了",@"坏笑",@"左哼哼",@"右哼哼",@"哈欠",@"鄙视",@"委屈",@"快哭了",@"阴险",@"亲亲",@"吓",@"可怜",@"菜刀",@"西瓜",@"啤酒",@"篮球",@"乒乓",@"咖啡",@"饭",@"猪头",@"玫瑰",@"凋谢",@"嘴唇",@"爱心",@"心碎",@"蛋糕",@"闪电",@"炸弹",@"刀",@"足球",@"瓢虫",@"便便",@"月亮",@"太阳",@"礼物",@"拥抱",@"强",@"弱",@"握手",@"胜利",@"抱拳",@"勾引",@"拳头",@"差劲",@"爱你",@"no",@"ok",@"爱情",@"飞吻",@"跳跳",@"发抖",@"怄火",@"转圈",@"磕头",@"回头",@"跳绳",@"投降",@"激动",@"街舞",@"献吻",@"左太极",@"右太极",nil];
            if (i*7+y+(page*28) <imageAry.count)
            {
                NSString *imageName=[imageAry objectAtIndex:i*7+y+(page*28)];
                [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                [button setFrame:CGRectMake(0+y*size.width, 0+i*size.height, size.width, size.height)];
                button.titleLabel.text = imageName;
                button.adjustsImageWhenHighlighted = NO;
                [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];

                [self addSubview:button];
            }
		}
	}
}


- (void)buttonClicked:(UIButton*)button
{
	NSString *str=[NSString stringWithFormat:@"%@",button.titleLabel.text];
	if (_delegate && [_delegate respondsToSelector:@selector(selectedFacialView:)])
    {
        [_delegate selectedFacialView:str];
    }
}


@end
