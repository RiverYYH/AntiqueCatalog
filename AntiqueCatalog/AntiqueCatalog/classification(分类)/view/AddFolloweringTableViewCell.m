//
//  AddFolloweringTableViewCell.m
//  AntiqueCatalog
//
//  Created by CssWeb on 16/4/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "AddFolloweringTableViewCell.h"

@interface AddFolloweringTableViewCell ()

@property (nonatomic,strong)UIView      *bgView;
@property (nonatomic,strong)UIImageView *avatar;//用户头像
@property (nonatomic,strong)UILabel     *uname;//图录名称
@property (nonatomic,strong)UILabel     *intro;//图录简介
@property (nonatomic,strong) UIButton * followButton;//关注按钮
@property (nonatomic,strong) NSString * uid;
@end

@implementation AddFolloweringTableViewCell

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
    _intro.frame = CGRectMake(CGRectGetMaxX(_avatar.frame)+16, CGRectGetMaxY(_uname.frame)+5, UI_SCREEN_WIDTH-CGRectGetMaxX(_avatar.frame)-75,15);
    
    _followButton = [UIButton buttonWithType:UIButtonTypeSystem];
    _followButton.layer.cornerRadius = 6;
    _followButton.layer.masksToBounds = YES;
    _followButton.layer.borderWidth = 1;
    _followButton.layer.borderColor = [Blue_color CGColor];
    [_followButton setTitle:@"关注" forState:UIControlStateNormal];
    [_followButton setTitleColor:Blue_color forState:UIControlStateNormal];
    [_followButton setFrame:CGRectMake(CGRectGetMaxX(_intro.frame)+10, 16, 40, 40)];
    [_followButton addTarget:self action:@selector(followButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bgView addSubview:_followButton];
    
    [_bgView addSubview:_avatar];
    [_bgView addSubview:_uname];
    [_bgView addSubview:_intro];
    [self.contentView addSubview:_bgView];
    
}

- (void)setFolloweringdata:(AddFolloweringdata *)followeringdata
{
    [_avatar sd_setImageWithURL:[NSURL URLWithString:followeringdata.avatar]];
    _uname.text = followeringdata.uname;
    _intro.text = followeringdata.intro;
    if(followeringdata.follow){
        [_followButton setHidden:YES];
    }else{
        [_followButton setHidden:NO];
    }
    if(followeringdata.uid){
        self.uid = followeringdata.uid;
    }
}

-(void) followButtonClick:(UIButton*)sender{
    NSLog(@"this item uid = %@",self.uid);
    [self.delegate didClickFollowButtonWithData:self.uid];
}

@end
