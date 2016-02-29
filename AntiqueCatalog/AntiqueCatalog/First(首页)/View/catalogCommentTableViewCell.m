//
//  catalogCommentTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/11.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "catalogCommentTableViewCell.h"

@interface catalogCommentTableViewCell ()

@property (nonatomic,strong)UIView *view;
@property (nonatomic,strong)UIImageView *avatar_middle;
@property (nonatomic,strong)UILabel *uname;
@property (nonatomic,strong)UILabel *ctime;
@property (nonatomic,strong)UIButton *is_digg;
@property (nonatomic,strong)UILabel *content;

@property (nonatomic,strong)NSIndexPath *indexPath;


@end

@implementation catalogCommentTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    _view = [[UIView alloc]init];
    _view.backgroundColor = White_Color;
    self.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _avatar_middle = [[UIImageView alloc]initWithFrame:CGRectMake(16, 10, 40, 40)];
    _avatar_middle.layer.masksToBounds = YES;
    _avatar_middle.layer.cornerRadius = 20;
    _avatar_middle.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _uname = [Allview Withstring:@"" Withcolor:Green_color Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _uname.frame = CGRectMake(CGRectGetMaxX(_avatar_middle.frame) + 8, 10, UI_SCREEN_WIDTH - CGRectGetMaxX(_avatar_middle.frame) - 8 - 16, 40);
    
    _ctime = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_uname_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _ctime.frame = CGRectMake(CGRectGetMaxX(_avatar_middle.frame) + 8, CGRectGetMaxY(_uname.frame), UI_SCREEN_WIDTH - CGRectGetMaxX(_avatar_middle.frame) - 8 - 16 - 50, 12);
    
    _is_digg = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"" Withcolor:Blue_color WithSelectcolor:Blue_color Withfont:Catalog_Cell_uname_Font WithBgcolor:White_Color WithcornerRadius:0 Withbold:NO];
    [_is_digg setImage:[UIImage imageNamed:@"no_digg"] forState:UIControlStateNormal];
    _is_digg.frame = CGRectMake(CGRectGetMaxX(_ctime.frame), CGRectGetMaxY(_uname.frame) - 7, 50, 24);
    [_is_digg addTarget:self action:@selector(hanisdigg) forControlEvents:UIControlEventTouchUpInside];
    
    _content = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:0 WithTextAlignment:NSTextAlignmentLeft];
    
    [_view addSubview:_avatar_middle];
    [_view addSubview:_uname];
    [_view addSubview:_ctime];
    [_view addSubview:_is_digg];
    [_view addSubview:_content];
    [self.contentView addSubview:_view];
    
}

- (void)loadWithCommentArray:(commentData *)commentdata andWithIndexPath:(NSIndexPath *)indexPath{
    
    _indexPath = indexPath;
    
    [_avatar_middle sd_setImageWithURL:[NSURL URLWithString:commentdata.userInfo_avatar_middle]];
    _uname.text = commentdata.userInfo_uname;
    _ctime.text = [NSString stringWithFormat:@"%@ | %@回复",commentdata.ctime,commentdata.comment_count];
    
    if (commentdata.is_digg) {
        [_is_digg setImage:[UIImage imageNamed:@"is_digg"] forState:UIControlStateNormal];
    }else{
        [_is_digg setImage:[UIImage imageNamed:@"no_digg"] forState:UIControlStateNormal];
    }
    [_is_digg setTitle:commentdata.digg_count forState:UIControlStateNormal];
    
    _content.text = commentdata.content;
    [_content.text stringByReplacingOccurrencesOfString:@" " withString:@""];
    CGSize commentcontentsize = [Allview String:_content.text Withfont:Nav_title_font WithCGSize:UI_SCREEN_WIDTH - CGRectGetMaxX(_avatar_middle.frame) - 8 -16 Withview:_content Withinteger:0];
    
    _content.frame = CGRectMake(CGRectGetMaxX(_avatar_middle.frame) + 8, CGRectGetMaxY(_ctime.frame) + 10, commentcontentsize.width, commentcontentsize.height);
    _view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, CGRectGetMaxY(_content.frame) + 10);
    
    _height = CGRectGetMaxY(_content.frame) + 11;
}

- (void)hanisdigg{
    
    if (_delegate && [self.delegate respondsToSelector:@selector(hanisdigg:)]) {
        [self.delegate hanisdigg:_indexPath];
    }
    
}

@end
