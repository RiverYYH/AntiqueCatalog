//
//  UserSpaceTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/14.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "UserSpaceTableViewCell.h"

@interface UserSpaceTableViewCell ()

@property (nonatomic,strong)UIImageView *avatar;
@property (nonatomic,strong)UILabel     *uname;
@property (nonatomic,strong)UILabel     *intro;
@property (nonatomic,strong)UIButton    *following;
@property (nonatomic,strong)UIButton    *up_down;
@property (nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation UserSpaceTableViewCell

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
    _avatar = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-36, 24, 72, 72)];
    _avatar.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _avatar.layer.masksToBounds = YES;
    _avatar.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
    _avatar.layer.borderWidth = 1.0;
    
    _uname = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _uname.frame = CGRectMake(16, CGRectGetMaxY(_avatar.frame) + 16, UI_SCREEN_WIDTH-32,15);
    
    _following = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"" Withcolor:White_Color WithSelectcolor:White_Color Withfont:Catalog_Cell_Name_Font WithBgcolor:Blue_color WithcornerRadius:0 Withbold:NO];
    _following.frame = CGRectMake(UI_SCREEN_WIDTH/2-60, CGRectGetMaxY(_uname.frame) + 12, 120,40);
    [_following addTarget:self action:@selector(followingClick:) forControlEvents:UIControlEventTouchUpInside];
    
    _intro = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];

    _up_down = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"" Withcolor:White_Color WithSelectcolor:White_Color Withfont:1 WithBgcolor:Clear_Color WithcornerRadius:1 Withbold:NO];
    [_up_down addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:_avatar];
    [self.contentView addSubview:_uname];
    [self.contentView addSubview:_following];
    [self.contentView addSubview:_intro];
    [self.contentView addSubview:_up_down];
    
}

- (void)updateCellWithData:(UserSpacedata *)userspacedata andmore:(BOOL)more andIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    [_avatar sd_setImageWithURL:[NSURL URLWithString:userspacedata.avatar]];
    _uname.text = userspacedata.uname;
    _intro.text = userspacedata.intro;
    self.userspacedata = userspacedata;
    CGSize infosize;
    if (STRING_NOT_EMPTY(_intro.text)) {
        infosize = [Allview String:_intro.text Withfont:Catalog_Cell_info_Font WithCGSize:UI_SCREEN_WIDTH - 64 Withview:_intro Withinteger:0];
    }else{
        infosize = CGSizeMake(0.f, 0.f);
    }
    if (userspacedata.follow_status_following) {
        [_following setTitle:@"已关注" forState:UIControlStateNormal];
        _following.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    }else{
        [_following setTitle:@"关注" forState:UIControlStateNormal];
        _following.backgroundColor = Blue_color;
    }
    
    if (infosize.height < 35.f) {
        
        _intro.frame = CGRectMake(16, CGRectGetMaxY(_following.frame)+12, UI_SCREEN_WIDTH - 16 - 16 , infosize.height);
        _up_down.hidden = YES;
        
    }else{
        _up_down.hidden = NO;
        if (more) {
            _intro.frame = CGRectMake(16, CGRectGetMaxY(_following.frame)+12, UI_SCREEN_WIDTH - 16 - 16 , infosize.height);
            [_up_down setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:UIControlStateNormal];
            _up_down.frame = CGRectMake(0, CGRectGetMaxY(_intro.frame), UI_SCREEN_WIDTH, 30);
        }else{
            _intro.frame = CGRectMake(16, CGRectGetMaxY(_following.frame)+12, UI_SCREEN_WIDTH - 16 - 16 , 35);
            [_up_down setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
            _up_down.frame = CGRectMake(0, CGRectGetMaxY(_intro.frame), UI_SCREEN_WIDTH, 30);
        }
    }
}

- (void)clickbutton:(UIButton *)button{
    
    if (_delegate && [self.delegate respondsToSelector:@selector(addfollower:andIndexPath:)]) {
        
        [self.delegate addfollower:NO andIndexPath:_indexPath];
    }
    
}
-(void)followingClick:(UIButton*)button{
    [self.delegate addOrUnaddFollowerWithUserSpacedata:self.userspacedata AndButton:button AndIndexPath:_indexPath];
}
@end
