//
//  headerViewbutton.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "headerViewbutton.h"

@implementation headerViewbutton

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.backgroundColor = White_Color;
        // 图标居中
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;
        // 文字居中
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
        self.titleLabel.font = [UIFont systemFontOfSize:Catalog_Cell_info_Font];
        [self setTitleColor:Deputy_Colour forState:UIControlStateNormal];
        
    }
    return self;
}
- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(self.frame.size.width/2-12, 10, 24,24);//图片的位置大小
}
- (CGRect)titleRectForContentRect:(CGRect)contentRect
{
    return CGRectMake(0, CGRectGetMaxY(self.imageView.frame) + 5, self.frame.size.width, 10);//文本的位置大小
}



/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
