//
//  ShopNameView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/2/23.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ShopNameView.h"

@interface ShopNameView ()

@property (nonatomic,strong)UILabel *fontlabel;
@property (nonatomic,strong)UIButton *minfont;
@property (nonatomic,strong)UIButton *maxfont;

@property (nonatomic,strong)UILabel *bgcolor;
@property (nonatomic,strong)UIButton *selectcolor;


@end

@implementation ShopNameView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self CreatUI];
    }
    return self;
}

- (void)CreatUI
{
   self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
    
    _fontlabel = [Allview Withstring:@"字号" Withcolor:White_Color Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _fontlabel.frame = CGRectMake(0, 16, 80, 30);
    
    [self addSubview:_fontlabel];
    
    _minfont = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"小" Withcolor:White_Color WithSelectcolor:White_Color Withfont:Catalog_Cell_Name_Font WithBgcolor:Clear_Color WithcornerRadius:16 Withbold:NO];
    _minfont.layer.borderColor = White_Color.CGColor;
    _minfont.layer.borderWidth = 2.0;
    _minfont.frame = CGRectMake(CGRectGetMaxX(_fontlabel.frame), 16, (UI_SCREEN_WIDTH-80-60)/2, 30);
    _minfont.tag = 10;
    [_minfont addTarget:self action:@selector(fontbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_minfont];
    
    _maxfont = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"大" Withcolor:White_Color WithSelectcolor:White_Color Withfont:Catalog_Cell_Name_Font WithBgcolor:Clear_Color WithcornerRadius:16 Withbold:NO];
    _maxfont.layer.borderColor = White_Color.CGColor;
    _maxfont.layer.borderWidth = 2.0;
    _maxfont.frame = CGRectMake(CGRectGetMaxX(_minfont.frame)+30, 16, (UI_SCREEN_WIDTH-80-60)/2, 30);
    _maxfont.tag = 11;
    [_maxfont addTarget:self action:@selector(fontbtn:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_maxfont];
    
    _bgcolor = [Allview Withstring:@"背景" Withcolor:White_Color Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _bgcolor.frame = CGRectMake(0, 62+16, 80, 30);
    
    [self addSubview:_bgcolor];
    
    for (NSInteger i = 0; i < 5; i++) {
        UIButton *colorbtn = [[UIButton alloc]initWithFrame:CGRectMake(80+(UI_SCREEN_WIDTH-80-32-30*5)/4*i+30*i, 62+16, 30, 30)];
        colorbtn.tag = i;
        colorbtn.layer.masksToBounds = YES;
        colorbtn.layer.cornerRadius = 15;
        switch (i) {
            case 0:
            {
                colorbtn.backgroundColor = [UIColor colorWithConvertString:Reading_color1];
                colorbtn.selected = YES;
                _selectcolor = colorbtn;
                colorbtn.layer.borderColor = Blue_color.CGColor;
                colorbtn.layer.borderWidth = 2.0;
            }
                break;
            case 1:
            {
                colorbtn.backgroundColor = [UIColor colorWithConvertString:Reading_color2];
                colorbtn.selected = NO;
            }
                break;
            case 2:
            {
                colorbtn.backgroundColor = [UIColor colorWithConvertString:Reading_color3];
                colorbtn.selected = NO;
            }
                break;
            case 3:
            {
                colorbtn.backgroundColor = [UIColor colorWithConvertString:Reading_color4];
                colorbtn.selected = NO;
            }
                break;
            case 4:
            {
                colorbtn.backgroundColor = [UIColor colorWithConvertString:Reading_color5];
                colorbtn.selected = NO;
            }
                break;
                
            default:
                break;
        }
        
        [self addSubview:colorbtn];
        [colorbtn addTarget:self action:@selector(selecthan:) forControlEvents:UIControlEventTouchUpInside];
        
    }

}

- (void)fontbtn:(UIButton *)btn{
    if (_delegate && [_delegate respondsToSelector:@selector(shopnamehan:)]) {
        [_delegate shopnamehan:btn.tag];
    }
}

- (void)selecthan:(UIButton *)btn
{
    if (btn.selected == NO) {
        _selectcolor.selected = NO;
        _selectcolor.layer.borderWidth = 0.0;
        
        btn.selected = YES;
        btn.layer.borderColor = Blue_color.CGColor;
        btn.layer.borderWidth = 2.0;
        _selectcolor = btn;
        if (_delegate && [_delegate respondsToSelector:@selector(shopnamehan:)]) {
            [_delegate shopnamehan:btn.tag];
        }
    }
}

@end
