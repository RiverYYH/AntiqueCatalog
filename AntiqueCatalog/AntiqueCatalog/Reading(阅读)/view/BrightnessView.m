//
//  BrightnessView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/2/24.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "BrightnessView.h"

@interface BrightnessView ()
@property (nonatomic,strong)UILabel *Brightness;
@property (nonatomic,strong)UISlider *slider;
@property (nonatomic,strong)UIButton *NightMode;

@end

@implementation BrightnessView

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
    _Brightness = [Allview Withstring:@"亮度" Withcolor:White_Color Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _Brightness.frame = CGRectMake(0, 16, 80, 30);
    [self addSubview:_Brightness];
    
    _slider = [[UISlider alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_Brightness.frame), 16, 184, 32)];
    _slider.minimumValue = 0.0;
    _slider.maximumValue = 1.0;
    float screenfloat = [UIScreen mainScreen].brightness;
    _slider.value = screenfloat;
    [_slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:_slider];
    
    _NightMode = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"夜间模式" Withcolor:White_Color WithSelectcolor:White_Color Withfont:Catalog_Cell_Name_Font WithBgcolor:Clear_Color WithcornerRadius:16 Withbold:YES];
    _NightMode.layer.borderColor = White_Color.CGColor;
    _NightMode.layer.borderWidth = 1.0;
    _NightMode.frame = CGRectMake(CGRectGetMaxX(_slider.frame) + 10, 17, UI_SCREEN_WIDTH - 80-184-16, 30);
    _NightMode.tag = 10;
    [_NightMode addTarget:self action:@selector(nightbtn:) forControlEvents:UIControlEventTouchUpInside];
    _NightMode.selected = NO;
    [self addSubview:_NightMode];
    
    
}

- (void)sliderValueChanged:(UISlider *)slider{
    
    if (_delegate && [_delegate respondsToSelector:@selector(BrightnessViewhan:)]) {
        [_delegate BrightnessViewhan:slider.value];
    }
    
}

- (void)nightbtn:(UIButton *)btn{
    
    if (btn.selected == NO) {
        btn.selected = YES;
        _NightMode.layer.borderColor = Blue_color.CGColor;
    }else{
        btn.selected = NO;
        _NightMode.layer.borderColor = White_Color.CGColor;
    }
    if (_delegate && [_delegate respondsToSelector:@selector(NightMode:)]) {
        [_delegate NightMode:btn.selected];
    }
    
}


@end
