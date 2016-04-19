//
//  MybookCollectionViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/7.
//  Copyright © 2016年 Cangmin. All rights reserved.
//


#define borderHeight 3
#import "MybookCollectionViewCell.h"
#import "FMDB.h"
#import "MF_Base64Additions.h"

@interface MybookCollectionViewCell(){
    FMDatabase *db;

}

@property (nonatomic,strong)UIImageView *cover;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UIImageView *typeimage;
@property (nonatomic,strong)UIImageView * downImage;
//@property (nonatomic,strong)UIImageView *select;

@end

@implementation MybookCollectionViewCell


- (instancetype)init
{
    self = [super init];
    if(self){
        [self CreatUI];
    }
    return self;
}
- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self CreatUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self CreatUI];
    }
    return self;
}

- (void)CreatUI{
    db = [Api initTheFMDatabase];

    _cover = [[UIImageView alloc]initWithFrame:CGRectMake(10, 0, 88, 116)];
    _cover.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _typeimage = [[UIImageView alloc]initWithFrame:CGRectMake(88-36, 0, 36, 36)];
    _typeimage.backgroundColor = Clear_Color;
    _typeimage.image = [UIImage imageNamed:@"icon_paimai"];
    _typeimage.hidden = YES;
    
    [_cover addSubview:_typeimage];
    
    _downImage = [[UIImageView alloc]initWithFrame:CGRectMake(88-15, 116-15, 15, 15)];
    _downImage.backgroundColor = Clear_Color;
    _downImage.image = [UIImage imageNamed:@"download"];
//    _downImage.hidden = YES;
    
    [_cover addSubview:_downImage];
    
    _selectedImageview = [[UIImageView alloc]initWithFrame:CGRectMake(88-12, -12, 24, 24)];
    _selectedImageview.backgroundColor = Clear_Color;
    _selectedImageview.image = [UIImage imageNamed:@"select_catalog"];
    _selectedImageview.hidden = YES;
    //[_cover addSubview:_select];
    
    _name = [Allview Withstring:@"" Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_uname_Font WithLineBreakMode:2 WithTextAlignment:NSTextAlignmentLeft];
    _name.frame = CGRectMake(10, CGRectGetMaxY(_cover.frame)+12, 88, 30);
    
    [self addSubview:_cover];
    [self addSubview:_name];
    [self addSubview:_selectedImageview];
}


-(void)setMybookCatalogdata:(MybookCatalogdata *)mybookCatalogdata{
    
    [_cover sd_setImageWithURL:[NSURL URLWithString:mybookCatalogdata.cover]];
    
    _name.text = mybookCatalogdata.name;
}

- (void)reloaddata:(MybookCatalogdata *)mybookCatalogdata andWithbool:(BOOL)isedit andWithIndexPath:(NSIndexPath *)indexPath{
    
    [_cover sd_setImageWithURL:[NSURL URLWithString:mybookCatalogdata.cover]];
    
    _name.text = mybookCatalogdata.name;

    if (isedit) {
        _selectedImageview.hidden = NO;
       
    }else{
        _selectedImageview.hidden = YES;
    }
    if ([mybookCatalogdata.type isEqualToString:@"0"]) {
        _typeimage.hidden = NO;
    }else{
        _typeimage.hidden = YES;
    }
    [self isHaveDown:mybookCatalogdata.ID withName:mybookCatalogdata.name];
    
}

-(void)isHaveDown:(NSString*)bookId withName:(NSString*)fileName{
    
    NSString *pathOne = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@_%@",bookId,fileName] ];
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    BOOL bRet = [fileMgr fileExistsAtPath:pathOne];
    
    if (bRet) {
        //
        self.downImage.hidden = YES;
        
    }else{
        self.downImage.hidden = NO;

    }

    
//    [db open];
//    FMResultSet * tempRs = [Api queryResultSetWithWithDatabase:db AndTable:TABLE_ACCOUNTINFOS AndWhereName:DATAID AndValue:bookId];
//    if([tempRs next]){
//        self.downImage.hidden = YES;
//    }else{
//        self.downImage.hidden = NO;
//
//    }
//    [db close];
}

- (void)setCatalogCollectiondata:(catalogdetailsCollectiondata *)catalogCollectiondata
{
    [_cover sd_setImageWithURL:[NSURL URLWithString:catalogCollectiondata.cover]];
    
    _name.text = catalogCollectiondata.name;
    if ([catalogCollectiondata.type isEqualToString:@"0"]) {
        _typeimage.hidden = NO;
    }else{
        _typeimage.hidden = YES;
    }
    
}

@end
