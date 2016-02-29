//
//  UpView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/25.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "UpView.h"

@interface UpView ()

@property (nonatomic,strong)UIButton *backbtn;
@property (nonatomic,strong)UIButton *share;

@end

@implementation UpView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self CreatUI];
    }
    return self;
}

- (void)CreatUI{
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.85];
    
    _backbtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 20, 44, 44)];
    _backbtn.backgroundColor  = Clear_Color;
    [_backbtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [_backbtn addTarget:self action:@selector(fanhui) forControlEvents:UIControlEventTouchUpInside];
    
    [self addSubview:_backbtn];
    
    _share = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 44, 20, 44, 44)];
    [_share setImage:[UIImage imageNamed:@"share"] forState:UIControlStateNormal];
    [_share addTarget:self action:@selector(sharebook) forControlEvents:UIControlEventTouchUpInside];
    _share.backgroundColor  = Clear_Color;
    [self addSubview:_share];
}

- (void)fanhui{
    
    if (_delegate && [_delegate respondsToSelector:@selector(backgo)]) {
        [_delegate backgo];
    }
    
}

- (void)sharebook{
    
    if (_delegate && [_delegate respondsToSelector:@selector(sharego)]) {
        [_delegate sharego];
    }
    
}

@end
