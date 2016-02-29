//
//  leftTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/26.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "leftTableViewCell.h"

@interface leftTableViewCell ()

@property (nonatomic,strong)UIView  *bgView;
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UIImageView *image;

@end

@implementation leftTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView
{
    self.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 50, 40)];
    _bgView.backgroundColor = White_Color;
    
    _label = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _label.frame = CGRectMake(20, 0, UI_SCREEN_WIDTH - 110, 40);
    
    
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 90, 0, 40, 40)];
    _image.image = [UIImage imageNamed:@"icon_back"];
    [_bgView addSubview:_label];
//    [_bgView addSubview:_image];
    [self.contentView addSubview:_bgView];
}

- (void)reloadstring:(NSString *)string{
    
    _label.text = string;
    
}

@end
