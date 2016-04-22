//
//  TabbarScrollView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "TabbarScrollView.h"
#import "CatalogCategorydata.h"

#define showcount 4

@interface TabbarScrollView ()

@property (nonatomic,strong)UIButton *button;
@property (nonatomic,strong)UIButton *selectbut;
@property (nonatomic,strong)NSMutableArray *btnarray;

@end

@implementation TabbarScrollView

- (instancetype)initWithheight:(CGFloat)height andWitharray:(NSArray *)array{
    self = [super init];
    if (self) {
        
        _Height = height;
        _array = array;
        [self CreatUI];
        
    }
    return self;
}

- (void)CreatUI{
    
    _btnarray = [[NSMutableArray alloc]init];
    
    self.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, _Height);
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.backgroundColor = [UIColor colorWithConvertString:@"#f5f5f5"];
    
    [_array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        CatalogCategorydata *catalogcategory = [_array objectAtIndex:idx];
        _button = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:catalogcategory.title Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Catalog_Cell_info_Font WithBgcolor:[UIColor colorWithConvertString:@"#f5f5f5"] WithcornerRadius:0 Withbold:NO];
        
        _button.frame = CGRectMake(idx*UI_SCREEN_WIDTH/showcount, 0, UI_SCREEN_WIDTH/showcount, _Height);
        _button.tag = idx;
        if (idx == 0) {
            _button.selected = YES;
            _selectbut = _button;
        }
        [_button addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnarray addObject:_button];
        [self addSubview:_button];
    }];
    
    if (_array.count > 6) {
        self.contentSize = CGSizeMake(UI_SCREEN_WIDTH/showcount*_array.count, 0);
    }
    
}
//按钮点击事件
- (void)btnClicked:(UIButton *)sender
{
    if (sender != _selectbut) {
        _selectbut.selected = NO;
        _selectbut = sender;
        _selectbut.selected = YES;
        
        
        [UIView animateWithDuration:0.3 animations:^{
            CGPoint changePoint;
            if(sender.frame.origin.x >= UI_SCREEN_WIDTH/2 && sender.frame.origin.x < self.contentSize.width-UI_SCREEN_WIDTH/2 && self.contentSize.width > self.frame.size.width) {
                changePoint = CGPointMake(sender.frame.origin.x-self.frame.size.width/2 + UI_SCREEN_WIDTH/showcount, 0);
            } else if (sender.frame.origin.x >= self.contentSize.width-UI_SCREEN_WIDTH/2 && self.contentSize.width > self.frame.size.width) {
                changePoint = CGPointMake(self.contentSize.width-self.frame.size.width, 0);
            } else {
                changePoint = CGPointMake(0, 0);
            }
            self.contentOffset = changePoint;
        }];
        
        if (_Tabbardelegate &&[_Tabbardelegate respondsToSelector:@selector(hanTabbarIndexPath:)]) {
            
            [_Tabbardelegate hanTabbarIndexPath:_selectbut.tag];
        }
        
    }
    
}

- (void)btnClickByScrollWithIndex:(NSInteger)index
{
    UIButton *btn = (UIButton *)[_btnarray objectAtIndex:index];
    [self btnClicked:btn];
}

@end
