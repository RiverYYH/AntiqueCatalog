//
//  CatalogListTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/22.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "CatalogListTableViewCell.h"

@interface CatalogListTableViewCell ()

@property (nonatomic,strong)UIView  *bgView;
@property (nonatomic,strong)UILabel *title;
@property (nonatomic,strong)UILabel *info;
@property (nonatomic,strong)UILabel *product;

@end

@implementation CatalogListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    _bgView = [[UIView alloc]init];
    _bgView.backgroundColor = White_Color;
    self.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _title = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:2 WithTextAlignment:NSTextAlignmentLeft];
    
    _info = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:6 WithTextAlignment:NSTextAlignmentLeft];
    
    _product = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:5 WithTextAlignment:NSTextAlignmentLeft];
    
    [_bgView addSubview:_title];
    [_bgView addSubview:_info];
    [_bgView addSubview:_product];
    [self.contentView addSubview:_bgView];
    
}

-(void)initWithdic:(NSDictionary *)dic andWithcataloggetlist:(CatalogGetList *)cataloggetlist andWithIndexPath:(NSIndexPath *)indexPath{
    
    _height = 0.f;
    NSString *titlestring = @"";
    if (cataloggetlist.type == 0) {
        titlestring = [dic objectForKey:@"name"];
    }else{
        titlestring = [dic objectForKey:@"title"];
    }
    
    if (STRING_NOT_EMPTY(titlestring)) {
        _title.hidden = NO;
        _title.text = titlestring;
        
        CGSize titlesize = [Allview String:titlestring Withfont:Catalog_Cell_Name_Font WithCGSize:UI_SCREEN_WIDTH - 40 Withview:_title Withinteger:2];
        
        _title.frame = CGRectMake(20, 16, UI_SCREEN_WIDTH - 40, titlesize.height);
        
        _height = CGRectGetMaxY(_title.frame);
        
    }else{
        _title.hidden = YES;
        _height = 16.f;
    }
    
    
    
    NSString *infostring = @"";
    infostring = [dic objectForKey:@"info"];
    
    if (STRING_NOT_EMPTY(titlestring) && infostring.length>0) {
        _info.hidden = NO;
        _info.text = infostring;
        NSString * tmpStr;
        if (infostring.length > 110) {
            NSRange rang = {0,110};
            //location (起始索引的位置,包含该索引) length(要截取的长度)
            tmpStr = [infostring substringWithRange:rang];
        }else{
            tmpStr = infostring;
        }
        
        
        CGSize infosize = [Allview String:tmpStr Withfont:Catalog_Cell_Name_Font WithCGSize:UI_SCREEN_WIDTH - 40 Withview:_info Withinteger:6];
        
        _info.frame = CGRectMake(20, _height, infosize.width, infosize.height + 10);
        
        _height = CGRectGetMaxY(_info.frame);
        
    }else{
        _info.hidden = YES;
    }
    
    
    if (cataloggetlist.type == 0) {
        _product.hidden = YES;
    }else{
        _product.hidden = NO;
        NSString *productstring = @"";
        if (ARRAY_NOT_EMPTY([dic objectForKey:@"product"])) {
            NSArray *array = [dic objectForKey:@"product"];
            NSInteger idx = 0;
            for (NSDictionary *dicunit in array) {
                
                if (idx == 0) {
                    productstring = [NSString stringWithFormat:@"%@%@",productstring,[dicunit objectForKey:@"name"]];
                }else if (idx <5){
                    productstring = [NSString stringWithFormat:@"%@\n%@",productstring,[dicunit objectForKey:@"name"]];
                }
                

                idx ++;

            }
          
            CGSize productsize = [Allview String:productstring Withfont:Catalog_Cell_Name_Font WithCGSize:UI_SCREEN_WIDTH - 40 Withview:_product Withinteger:5];
            _product.text = productstring;
            _product.frame = CGRectMake(20, _height +5, productsize.width, productsize.height);
            
            _height = CGRectGetMaxY(_product.frame) ;
            
        }else{
            
            
            
        }
        
    }
    
    
    _bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, _height + 16);
    _height = _height + 17;
    
}



@end
