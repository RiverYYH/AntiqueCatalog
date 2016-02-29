//
//  downView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/25.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "downView.h"

@implementation downView

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
    
    for (NSInteger i = 0; i < 4; i++) {
        
        UIButton *but = [[UIButton alloc]initWithFrame:CGRectMake(i*UI_SCREEN_WIDTH/4, 10, UI_SCREEN_WIDTH/4, 44)];
        but.tag = i;
        [self addSubview: but];
        
        [but addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
        
        switch (i) {
            case 0:
            {
                [but setImage:[UIImage imageNamed:@"menu"] forState:UIControlStateNormal];
            }
                break;
            case 1:
            {
                [but setImage:[UIImage imageNamed:@"brightness"] forState:UIControlStateNormal];
            }
                break;
            case 2:
            {
                [but setImage:[UIImage imageNamed:@"font"] forState:UIControlStateNormal];
            }
                break;
            case 3:
            {
                [but setImage:[UIImage imageNamed:@"pinglun"] forState:UIControlStateNormal];
            }
                break;
                
            default:
                break;
        }
 
    }
    
}

- (void)click:(UIButton *)button
{
    
    if (_delegate && [_delegate respondsToSelector:@selector(menuo:)]) {
        [_delegate menuo:button.tag];
    }
}


@end
