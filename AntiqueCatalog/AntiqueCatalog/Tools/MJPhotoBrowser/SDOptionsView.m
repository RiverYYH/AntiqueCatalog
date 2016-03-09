//
//  SDOptionsView.m
//  SDPhotoBrowser
//
//  Created by Cangmin on 15/10/20.
//  Copyright © 2015年 Cangmin. All rights reserved.
//

#import "SDOptionsView.h"

@interface SDOptionsView()

@property (nonatomic,strong)SDOptionsViewblack  myBlock;
@property (nonatomic,strong)UIView *bgView;

@end

@implementation SDOptionsView

- (id)init
{
    self = [super init];
    if(self){
        [self CreatUI];
    }
    return self;
}

- (void)CreatUI
{
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0];
    NSArray *arrayname = @[@"识图",@"保存到手机",@"取消"];
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(30, 230, 260, 40.5*(arrayname.count) + 30)];
    _bgView.backgroundColor = [UIColor whiteColor];
    _bgView.layer.masksToBounds = YES;
    _bgView.layer.cornerRadius = 3;
    [self addSubview:_bgView];
    
    UILabel *titlabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 260, 30)];
    titlabel.text = @"选择";
    titlabel.textColor = [UIColor blackColor];
    titlabel.font = [UIFont systemFontOfSize:13];
    [_bgView addSubview:titlabel];
    
    UIImageView *titlabelimageview = [[UIImageView alloc]init];
    titlabelimageview.backgroundColor = [UIColor blackColor];
    titlabelimageview.frame = CGRectMake(10, CGRectGetMaxY(titlabel.frame), 240, 0.5);
    [_bgView addSubview:titlabelimageview];
    
    
    for (NSInteger i = 0; i < arrayname.count; i++) {
        
        UIButton *button = [self WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:[arrayname objectAtIndex:i] Withcolor:[UIColor blueColor] Withfont:16 WithBgcolor:[UIColor whiteColor] WithcornerRadius:0];
        button.frame = CGRectMake(0, 30.5 +(0.5 + 40) * i, 260, 40);
        button.adjustsImageWhenHighlighted = NO;
        button.tag = i;
        [button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
        if (button.tag == (arrayname.count-1)) {
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        }
        [_bgView addSubview:button];
        
        UIImageView *imageview = [[UIImageView alloc]init];
        imageview.backgroundColor = [UIColor blackColor];
        imageview.frame = CGRectMake(10, CGRectGetMaxY(button.frame), 240, 0.5);
        [_bgView addSubview:imageview];
        
    }
}

-(void)block:(SDOptionsViewblack)block
{
    _myBlock = block;
}

-(void)buttonClick:(UIButton *)button
{
    if (_myBlock != NULL) {
        _myBlock(button.tag);
    }
}



-(UIButton *)WithlineBreak:(NSInteger)lineBreak WithcontentVerticalAlignment:(UIControlContentVerticalAlignment *)contentVertical WithString:(NSString *)string Withcolor:(UIColor *)color Withfont:(CGFloat)font WithBgcolor:(UIColor *)Bgcolor WithcornerRadius:(CGFloat)cornerRadius
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.titleLabel.lineBreakMode = lineBreak;
    
    btn.layer.masksToBounds = YES;
    btn.layer.cornerRadius = cornerRadius;
    
    btn.contentVerticalAlignment = UIControlContentHorizontalAlignmentCenter;
    btn.titleLabel.font = [UIFont systemFontOfSize:font];
    [btn setTitle:string  forState:UIControlStateNormal];
    
    [btn setTitleColor:color forState:UIControlStateNormal];
    [btn setTitleColor:color forState:UIControlStateSelected];
    [btn setBackgroundColor:Bgcolor];
    
    
    return btn;
}

@end
