//
//  otherregisactionView.m
//  到处是宝
//
//  Created by Cangmin on 15/10/9.
//  Copyright © 2015年 huihao. All rights reserved.
//

#import "otherregisactionView.h"
#import <TencentOpenAPI/QQApi.h>
#define buttonheight 50

@interface otherregisactionView()

@property (nonatomic,strong)otherregisactionViewblack  myBlock;
@property (nonatomic,strong)UIView *bgView;

@end

@implementation otherregisactionView

- (id)init
{
    self = [super init];
    if(self){
        [self CreatUI];
    }
    return self;
}

-(void)CreatUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSArray *arrayname;
    NSArray *arrayimage;
    if ([QQApi isQQInstalled]) {
        arrayname = @[@"手机注册",@"Q Q注册",@"微博注册"];
        arrayimage = @[@"regisactionPhon",@"regisactionqq",@"regisactionweibo"];

    }else{
        arrayname = @[@"手机注册",@"微博注册"];
        arrayimage = @[@"regisactionPhon",@"regisactionweibo"];
    }
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, UI_SCREEN_WIDTH - 20, buttonheight*arrayname.count + 0.5*(arrayname.count-1))];
    _bgView.backgroundColor = White_Color;
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 3;
    [self addSubview:_bgView];
    
    
    for (NSInteger i = 0; i < arrayname.count; i++) {
        
        UIButton *button = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:[arrayname objectAtIndex:i] Withcolor:Black_Color Withfont:16 WithBgcolor:White_Color WithcornerRadius:0];
//        UIButton *button = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCente WithString:[arrayname objectAtIndex:i] Withcolor:Black_Color WithSelectcolor:16 Withfont:White_Color WithBgcolor:nil WithcornerRadius:0 Withbold:YES];
        
        button.frame = CGRectMake(0, 0 +(0.5 + buttonheight) * i, UI_SCREEN_WIDTH - 20, buttonheight);
        [button setImage:[UIImage imageNamed:[arrayimage objectAtIndex:i]] forState:UIControlStateNormal];
        button.adjustsImageWhenHighlighted = NO;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        [_bgView addSubview:button];
        
        if (i != (arrayname.count - 1)) {
            UIImageView *imageview = [[UIImageView alloc]init];
            imageview.backgroundColor = Black_Color;
            imageview.frame = CGRectMake(10, CGRectGetMaxY(button.frame), UI_SCREEN_WIDTH - 40, 0.5);
            [_bgView addSubview:imageview];
        }

    }
    
    UIButton *cancelbutton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"取消" Withcolor:Black_Color Withfont:16 WithBgcolor:White_Color WithcornerRadius:3];
    cancelbutton.frame = CGRectMake(10, CGRectGetMaxY(_bgView.frame) + 9, UI_SCREEN_WIDTH - 20, buttonheight);
    cancelbutton.adjustsImageWhenHighlighted = NO;
    if ([QQApi isQQInstalled]) {
        cancelbutton.tag = arrayname.count;
    }else{
        cancelbutton.tag = arrayname.count + 1;
    }
    
    [cancelbutton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:cancelbutton];
    
}

-(void)block:(otherregisactionViewblack)block
{
    _myBlock = block;
}

-(void)buttonClick:(UIButton *)button
{
    if (_myBlock != NULL) {
        _myBlock(button.tag);
    }
}

@end
