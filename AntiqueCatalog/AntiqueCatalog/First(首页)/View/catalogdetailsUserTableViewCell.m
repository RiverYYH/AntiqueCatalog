//
//  catalogdetailsUserTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/11.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "catalogdetailsUserTableViewCell.h"

@interface catalogdetailsUserTableViewCell ()

@property (nonatomic,strong)UIImageView *avatar_middle;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UIButton *add;
@property (nonatomic,strong)NSIndexPath *indexPath;

@end

@implementation catalogdetailsUserTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 1, UI_SCREEN_WIDTH, 64)];
    view.backgroundColor = White_Color;
    self.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _avatar_middle = [[UIImageView alloc]initWithFrame:CGRectMake(16, 8, 48, 48)];
    _avatar_middle.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _avatar_middle.layer.masksToBounds = YES;
    _avatar_middle.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
    _avatar_middle.layer.borderWidth = 1.0;
    _avatar_middle.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapOne:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_avatar_middle addGestureRecognizer:tap];
    
    
    _name = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _name.frame = CGRectMake(CGRectGetMaxX(_avatar_middle.frame)+10, 8, UI_SCREEN_WIDTH - CGRectGetMaxX(_avatar_middle.frame)-10-70, 48);
    
    _add = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"+关注" Withcolor:Blue_color WithSelectcolor:Blue_color Withfont:Catalog_Cell_Name_Font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
    _add.frame = CGRectMake(CGRectGetMaxX(_name.frame), 8, 54, 48);
    [_add addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:_avatar_middle];
    [view addSubview:_name];
    [view addSubview:_add];
    [self.contentView addSubview:view];
    
}
- (void)loadCatalogdetailsData:(catalogdetailsdata *)catalogdetailsData andindexPath:(NSIndexPath *)indexPath{
    
    _catalogdetailsData = catalogdetailsData;
    _indexPath = indexPath;
    [_avatar_middle sd_setImageWithURL:[NSURL URLWithString:catalogdetailsData.userInfo_avatar_middle]];
    _name.text = catalogdetailsData.userInfo_uname;
    
    if (catalogdetailsData.userInfo_following) {
        [_add setTitle:@"已关注" forState:UIControlStateNormal];
        [_add setTitleColor:[UIColor colorWithConvertString:Background_Color] forState:UIControlStateNormal];
        
    }else{
        [_add setTitle:@"+关注" forState:UIControlStateNormal];
        [_add setTitleColor:Blue_color forState:UIControlStateNormal];
    }
    
}

- (void)clickbutton:(UIButton *)button{
    if (_delegate && [self.delegate respondsToSelector:@selector(follow:andIndexPath:)]) {
        
        [self.delegate follow:nil andIndexPath:_indexPath];
    }
}

- (void)handleTapOne:(UITapGestureRecognizer *)recognizer{

    if (_delegate && [self.delegate respondsToSelector:@selector(hanheadImage)]) {
        [self.delegate hanheadImage];
    }
    
}

@end
