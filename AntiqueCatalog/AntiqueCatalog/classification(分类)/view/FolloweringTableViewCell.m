//
//  FolloweringTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "FolloweringTableViewCell.h"

@interface FolloweringTableViewCell ()

@property (nonatomic,strong)UIView      *bgView;
@property (nonatomic,strong)UIImageView *avatar;//用户头像
@property (nonatomic,strong)UILabel     *uname;//图录名称
@property (nonatomic,strong)UILabel     *intro;//图录简介

@end

@implementation FolloweringTableViewCell

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
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 72)];
    _bgView.backgroundColor = White_Color;
    
    _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(16, 12, 48, 48)];
    _avatar.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
    _avatar.layer.borderWidth = 1.0;
    
    _uname = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _uname.frame = CGRectMake(CGRectGetMaxX(_avatar.frame)+16, 24, UI_SCREEN_WIDTH-CGRectGetMaxX(_avatar.frame)-30,15);
    
    _intro = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _intro.frame = CGRectMake(CGRectGetMaxX(_avatar.frame)+16, CGRectGetMaxY(_uname.frame)+5, UI_SCREEN_WIDTH-CGRectGetMaxX(_avatar.frame)-30,15);
    
    [_bgView addSubview:_avatar];
    [_bgView addSubview:_uname];
    [_bgView addSubview:_intro];
    [self.contentView addSubview:_bgView];
    
}

- (void)setFolloweringdata:(Followeringdata *)followeringdata
{
    [_avatar sd_setImageWithURL:[NSURL URLWithString:followeringdata.avatar]];
    _uname.text = followeringdata.uname;
    _intro.text = followeringdata.intro;
}


@end
