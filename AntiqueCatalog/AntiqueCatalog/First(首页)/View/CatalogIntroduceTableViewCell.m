//
//  CatalogIntroduceTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/9.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "CatalogIntroduceTableViewCell.h"

@interface CatalogIntroduceTableViewCell ()
@property (nonatomic,strong)UILabel *v_stime;
@property (nonatomic,strong)UILabel *v_address;
@property (nonatomic,strong)UILabel *stime;
@property (nonatomic,strong)UILabel *address;
@property (nonatomic,strong)UILabel *info;
@property (nonatomic,strong)UIButton *up_down;
@property (nonatomic,strong)NSIndexPath *indexPath;
@end

@implementation CatalogIntroduceTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    _v_stime = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _v_stime.frame = CGRectMake(16, 16, UI_SCREEN_WIDTH - 16 - 16, 15);
    
    _v_address = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _v_address.frame = CGRectMake(16, CGRectGetMaxY(_v_stime.frame)+5, UI_SCREEN_WIDTH - 16 - 16, 15);
    
    _stime = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _stime.frame = CGRectMake(16, CGRectGetMaxY(_v_address.frame)+5, UI_SCREEN_WIDTH - 16 - 16, 15);
    
    _address = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _address.frame = CGRectMake(16, CGRectGetMaxY(_stime.frame)+5, UI_SCREEN_WIDTH - 16 - 16, 15);
    
    _info = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    
    _up_down = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"" Withcolor:White_Color WithSelectcolor:White_Color Withfont:1 WithBgcolor:Clear_Color WithcornerRadius:1 Withbold:NO];
    [_up_down addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_v_stime];
    [self.contentView addSubview:_v_address];
    [self.contentView addSubview:_stime];
    [self.contentView addSubview:_address];
    [self.contentView addSubview:_info];
    [self.contentView addSubview:_up_down];
        
}

- (void)updateCellWithData:(catalogdetailsdata *)data andmore:(BOOL)more andIndexPath:(NSIndexPath *)indexPath
{
    if ([data.type isEqualToString:@"0"]) {
        
        _v_stime.hidden = NO;
        _v_address.hidden = NO;
        _stime.hidden = NO;
        _address.hidden = NO;
        _v_stime.text = [NSString stringWithFormat:@"预展时间  %@ 至 %@",data.v_stime,data.v_ntime];
        _v_address.text = [NSString stringWithFormat:@"预展地址  %@",data.v_address];
        _stime.text = [NSString stringWithFormat:@"拍卖时间  %@",data.stime];
        _address.text = [NSString stringWithFormat:@"拍卖地址  %@",data.address];
        _info.text = [NSString stringWithFormat:@"图录简介  %@",data.info];
        
        CGSize infosize = [Allview String:data.info Withfont:Catalog_Cell_info_Font WithCGSize:UI_SCREEN_WIDTH - 64 Withview:_info Withinteger:0];
        
        if (infosize.height > 156) {
            if (more) {
                
                _info.frame = CGRectMake(16, CGRectGetMaxY(_address.frame)+5, UI_SCREEN_WIDTH - 16 - 16 , infosize.height);
                _up_down.hidden = NO;
                
                [_up_down setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:UIControlStateNormal];
                _up_down.frame = CGRectMake(0, CGRectGetMaxY(_info.frame), UI_SCREEN_WIDTH, 30);
                
            }else{
                
                _info.frame = CGRectMake(16, CGRectGetMaxY(_address.frame)+5, UI_SCREEN_WIDTH - 16 - 16 , 156);
                _up_down.hidden = NO;
                
                [_up_down setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
                _up_down.frame = CGRectMake(0, CGRectGetMaxY(_info.frame), UI_SCREEN_WIDTH, 30);
            }
        }else{
            
            _info.frame = CGRectMake(16, CGRectGetMaxY(_address.frame)+5, UI_SCREEN_WIDTH - 16 - 16 , infosize.height);
            _up_down.hidden = YES;
            
        }

        
    }else{
        
        _v_stime.hidden = YES;
        _v_address.hidden = YES;
        _stime.hidden = YES;
        _address.hidden = YES;
        _info.text = [NSString stringWithFormat:@"图录简介  %@",data.info];
        CGSize infosize = [Allview String:data.info Withfont:Catalog_Cell_info_Font WithCGSize:UI_SCREEN_WIDTH - 64 Withview:_info Withinteger:0];
        
        if (infosize.height > 156) {
            if (more) {
                
                _info.frame = CGRectMake(16, 16, UI_SCREEN_WIDTH - 16 - 16 , infosize.height);
                _up_down.hidden = NO;
                
                [_up_down setImage:[UIImage imageNamed:@"icon_arrow_up"] forState:UIControlStateNormal];
                _up_down.frame = CGRectMake(0, CGRectGetMaxY(_info.frame), UI_SCREEN_WIDTH, 30);
                
            }else{
                
                _info.frame = CGRectMake(16, 16, UI_SCREEN_WIDTH - 16 - 16 , 156);
                _up_down.hidden = NO;
                
                [_up_down setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
                _up_down.frame = CGRectMake(0, CGRectGetMaxY(_info.frame), UI_SCREEN_WIDTH, 30);
            }
        }else{
            
            _info.frame = CGRectMake(16, 16, UI_SCREEN_WIDTH - 16 - 16 , infosize.height);
            _up_down.hidden = YES;
            
        }
    }
    _indexPath = indexPath;
}

- (void)clickbutton:(UIButton *)button{
    
    if (_delegate && [self.delegate respondsToSelector:@selector(han:andIndexPath:)]) {
        
        [self.delegate han:nil andIndexPath:_indexPath];
    }
    
}

@end
