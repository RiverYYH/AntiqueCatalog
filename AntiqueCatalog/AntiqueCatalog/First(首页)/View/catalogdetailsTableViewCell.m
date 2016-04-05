//
//  catalogdetailsTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/9.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "catalogdetailsTableViewCell.h"

@interface catalogdetailsTableViewCell ()

@property (nonatomic,strong)UIImageView *cover;
@property (nonatomic,strong)UILabel     *name;
@property (nonatomic,strong)UILabel     *view_count;
@property (nonatomic,strong)UILabel     *author;
@property (nonatomic,strong)UIButton    *reading;
@property (nonatomic,strong)UIButton    *cataloglist;
@property (nonatomic,strong)UIImageView *typeimage;

@end

@implementation catalogdetailsTableViewCell

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
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = White_Color;
    
    _cover = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 88, 116)];
    _cover.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _typeimage = [[UIImageView alloc]initWithFrame:CGRectMake(88-36, 0, 36, 36)];
    _typeimage.backgroundColor = Clear_Color;
    _typeimage.image = [UIImage imageNamed:@"icon_paimai"];
    _typeimage.hidden = YES;
    [_cover addSubview:_typeimage];
    
    _name = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:2 WithTextAlignment:NSTextAlignmentLeft];
    _name.frame = CGRectMake(CGRectGetMaxX(_cover.frame)+16, CGRectGetMinY(_cover.frame), UI_SCREEN_WIDTH - (CGRectGetMaxX(_cover.frame)+16+40), 40);
    
    
    
    _view_count = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _view_count.frame = CGRectMake(CGRectGetMaxX(_cover.frame)+16, CGRectGetMaxY(_name.frame)+20, UI_SCREEN_WIDTH - (CGRectGetMaxX(_cover.frame)+16+40), 10);
    
    _author = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _author.frame = CGRectMake(CGRectGetMaxX(_cover.frame)+16, CGRectGetMaxY(_view_count.frame)+30, UI_SCREEN_WIDTH - (CGRectGetMaxX(_cover.frame)+16+40), 10);
    
    if (!self.isPingLun) {
        _reading = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"阅读" Withcolor:White_Color WithSelectcolor:White_Color Withfont:Catalog_Cell_Name_Font WithBgcolor:Blue_color WithcornerRadius:4 Withbold:YES];
        _reading.frame = CGRectMake(16, CGRectGetMaxY(_cover.frame)+40, (UI_SCREEN_WIDTH-16-8-16)/2, 40);
        [_reading addTarget:self action:@selector(readingclick) forControlEvents:UIControlEventTouchUpInside];
        
        _cataloglist = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"查看目录" Withcolor:Deputy_Colour WithSelectcolor:Deputy_Colour Withfont:Catalog_Cell_Name_Font WithBgcolor:White_Color WithcornerRadius:4 Withbold:YES];
        _cataloglist.frame = CGRectMake(CGRectGetMaxX(_reading.frame)+8, CGRectGetMaxY(_cover.frame)+40, (UI_SCREEN_WIDTH-16-8-16)/2, 40);
        [_cataloglist addTarget:self action:@selector(cataloglistclick) forControlEvents:UIControlEventTouchUpInside];
        [_cataloglist.layer setBorderWidth:1];
        [_cataloglist.layer setBorderColor:RGBA(153,153,153).CGColor];
    }
   
    
    [view addSubview:_cover];
    [view addSubview:_name];
    [view addSubview:_view_count];
    [view addSubview:_author];
    
    if (!self.isPingLun) {
        [view addSubview:_reading];
        [view addSubview:_cataloglist];
        view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 40+116+40+40+16);

    }else{
        view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 40+116);

    }

    
    self.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    [self.contentView addSubview:view];
   
}

-(void)setCatalogdetailsData:(catalogdetailsdata *)catalogdetailsData{
    if (self.isPingLun) {
        for (UIView * view in self.contentView.subviews) {
            [view removeFromSuperview];
        }
        [self initSubView];
    }
    [_cover sd_setImageWithURL:[NSURL URLWithString:catalogdetailsData.cover]];
    _name.text = catalogdetailsData.name;
    
//    NSLog(@"llllll: %@  %d",catalogdetailsData, catalogdetailsData.view_count);
    if ([catalogdetailsData isEqual:[NSNull null]] || catalogdetailsData == NULL) {
        _view_count.text = @"";
    }else{
        _view_count.text = [NSString stringWithFormat:@"%@个阅读",catalogdetailsData.view_count];

    }
    _author.text = catalogdetailsData.author;
//    NSLog(@"ddddddddddd:%@ %@",_author.text,);
    
    if ([catalogdetailsData.type isEqualToString:@"0"]) {
        _typeimage.hidden = NO;
    }else{
        _typeimage.hidden = YES;
    }
}

- (void)readingclick{
    
    if (_delegate &&[_delegate respondsToSelector:@selector(hanreadingclick)]) {
        [_delegate hanreadingclick];
    }
    
}
- (void)cataloglistclick{
    if (_delegate &&[_delegate respondsToSelector:@selector(hancataloglistclick)]) {
        [_delegate hancataloglistclick];
    }
}
@end
