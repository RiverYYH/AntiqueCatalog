//
//  DownListViewCell.m
//  AntiqueCatalog
//
//  Created by cssweb on 16/4/19.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "DownListViewCell.h"
#define cellheight 160


@interface DownListViewCell()

@property (nonatomic,strong)UIView      *bgView;
@property (nonatomic,strong)UIImageView *coverimage;//图录的缩略图
@property (nonatomic,strong)UILabel     *namelabel;//图录名称
//@property (nonatomic,strong)UILabel     *v_stime_v_ntime_v_addresslabel;//拍卖图录预展开始时间
@property (nonatomic,strong)UILabel     *infolabel;//图录简介
@property (nonatomic,strong) UILabel * downStatelabel;
@property (nonatomic,strong) UILabel * downProsseLabel;
@property (nonatomic,strong) UIButton * downBtn;
@property (nonatomic,strong) UIButton * deletBtn;

//@property (nonatomic,strong)UIImageView *typeimage;

@end

@implementation DownListViewCell

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
    
    _bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 160)];
    _bgView.backgroundColor = White_Color;
    
    _coverimage = [[UIImageView alloc]initWithFrame:CGRectMake(16, 12, 88, 116)];
    _coverimage.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _coverimage.layer.masksToBounds = YES;
    _coverimage.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
    _coverimage.layer.borderWidth = 1.0;
    _coverimage.layer.shadowColor = [UIColor blackColor].CGColor;//阴影颜色
    _coverimage.layer.shadowOffset = CGSizeMake(0, 0);//偏移距离
    _coverimage.layer.shadowOpacity = 1;//不透明度
    _coverimage.layer.shadowRadius = 10.0;//半径
    
//    _typeimage = [[UIImageView alloc]initWithFrame:CGRectMake(88-36, 0, 36, 36)];
//    _typeimage.backgroundColor = Clear_Color;
//    _typeimage.image = [UIImage imageNamed:@"icon_paimai"];
//    _typeimage.hidden = YES;
//    [_coverimage addSubview:_typeimage];
    _namelabel = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_FontOne WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _namelabel.frame = CGRectMake(CGRectGetMaxX(_coverimage.frame)+16, 24, UI_SCREEN_WIDTH-CGRectGetMaxX(_coverimage.frame)-30,15);
//    _v_stime_v_ntime_v_addresslabel = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_FontOne WithLineBreakMode:2 WithTextAlignment:NSTextAlignmentLeft];
//    _v_stime_v_ntime_v_addresslabel.frame = CGRectMake(CGRectGetMaxX(_coverimage.frame)+16, CGRectGetMaxY(_namelabel.frame), UI_SCREEN_WIDTH-CGRectGetMaxX(_coverimage.frame)-30, 35);
    
    _infolabel = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_FontOne WithLineBreakMode:2 WithTextAlignment:NSTextAlignmentLeft];
    _infolabel.frame = CGRectMake(CGRectGetMaxX(_coverimage.frame)+16, CGRectGetMaxY(_namelabel.frame), UI_SCREEN_WIDTH-CGRectGetMaxX(_coverimage.frame)-30, 35);
    
    _downStatelabel = [Allview Withstring:@"正在等待" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:2 WithTextAlignment:NSTextAlignmentLeft];
    _downStatelabel.frame = CGRectMake(16, 120, 60, 35);
    
    _downProsseLabel = [Allview Withstring:@"0%" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:2 WithTextAlignment:NSTextAlignmentLeft];
    _downProsseLabel.frame = CGRectMake(CGRectGetMaxX(_downStatelabel.frame)+10, 120,60, 35);
    _downBtn = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"暂停" Withcolor:Deputy_Colour WithSelectcolor:Deputy_Colour Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
    [_downBtn setFrame:CGRectMake(CGRectGetMaxX(_downProsseLabel.frame)+ 30,  120,60, 35)];
    [_downBtn addTarget:self action:@selector(downBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    _deletBtn = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"暂停" Withcolor:Deputy_Colour WithSelectcolor:Deputy_Colour Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
    [_deletBtn addTarget:self action:@selector(downBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_deletBtn setFrame:CGRectMake(CGRectGetMaxX(_downBtn.frame)+10, 120,60, 35)];
    [_deletBtn addTarget:self action:@selector(deletBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    [self.contentView addSubview:_bgView];
    [_bgView addSubview:_coverimage];
    [_bgView addSubview:_namelabel];
//    [_bgView addSubview:_v_stime_v_ntime_v_addresslabel];
    [_bgView addSubview:_infolabel];
//    [_bgView addSubview:_unamelabel];
    [_bgView addSubview:_downStatelabel];
    [_bgView addSubview:_downProsseLabel];
    [_bgView addSubview:_downBtn];
    [_bgView addSubview:_deletBtn];

    
    
}

- (void)setAntiquecatalogdata:(AntiqueCatalogData *)antiquecatalogdata
{
    
    if (STRING_NOT_EMPTY(antiquecatalogdata.cover)) {
        [_coverimage sd_setImageWithURL:[NSURL URLWithString:antiquecatalogdata.cover]];
    }
    
    if (STRING_NOT_EMPTY(antiquecatalogdata.name)) {
        _namelabel.text = antiquecatalogdata.name;
    }
    
    
    if (STRING_NOT_EMPTY(antiquecatalogdata.info)) {
        _infolabel.text = antiquecatalogdata.info;
    }
//    if (STRING_NOT_EMPTY(antiquecatalogdata.uname)) {
//        _unamelabel.text = antiquecatalogdata.uname;
//    }
//    
//    if (STRING_NOT_EMPTY(antiquecatalogdata.type)) {
//        if ([antiquecatalogdata.type isEqualToString:@"0"]) {
//            _typeimage.hidden = NO;
//        }else{
//            _typeimage.hidden = YES;
//        }
//    }else{
//        _typeimage.hidden = YES;
//    }
//    if (STRING_NOT_EMPTY(antiquecatalogdata.type)) {
//        if ([antiquecatalogdata.type isEqualToString:@"0"]) {
//            _v_stime_v_ntime_v_addresslabel.hidden = NO;
//            if (STRING_NOT_EMPTY(antiquecatalogdata.v_stime)) {
//                _v_stime_v_ntime_v_addresslabel.text = antiquecatalogdata.v_stime;
//            }
//            if (STRING_NOT_EMPTY(antiquecatalogdata.v_address)) {
//                _v_stime_v_ntime_v_addresslabel.text = [NSString stringWithFormat:@"%@  %@",_v_stime_v_ntime_v_addresslabel.text,antiquecatalogdata.v_address];
//            }
//            _infolabel.frame = CGRectMake(CGRectGetMaxX(_coverimage.frame)+16, CGRectGetMaxY(_v_stime_v_ntime_v_addresslabel.frame), UI_SCREEN_WIDTH-CGRectGetMaxX(_coverimage.frame)-30, 35);
//            //            _unamelabel.frame = CGRectMake(CGRectGetMaxX(_coverimage.frame)+16, CGRectGetMaxY(_infolabel.frame), UI_SCREEN_WIDTH-CGRectGetMaxX(_coverimage.frame)-30, 20);
//            
//        }else{
//            _v_stime_v_ntime_v_addresslabel.hidden = YES;
//            _infolabel.frame = CGRectMake(CGRectGetMaxX(_coverimage.frame)+16, CGRectGetMaxY(_namelabel.frame)+5, UI_SCREEN_WIDTH-CGRectGetMaxX(_coverimage.frame)-30, 35);
//            //            _unamelabel.frame = CGRectMake(CGRectGetMaxX(_coverimage.frame)+16, CGRectGetMaxY(_infolabel.frame), UI_SCREEN_WIDTH-CGRectGetMaxX(_coverimage.frame)-30, 20);
//        }
//    }else{
//        _v_stime_v_ntime_v_addresslabel.hidden = YES;
//        _infolabel.frame = CGRectMake(CGRectGetMaxX(_coverimage.frame)+16, CGRectGetMaxY(_namelabel.frame)+5, UI_SCREEN_WIDTH-CGRectGetMaxX(_coverimage.frame)-30, 35);
//        
//    }
    
}

-(void)downBtnButtonClick:(id)sender{

}

-(void)deletBtnButtonClick:(id)sender{

}
@end
