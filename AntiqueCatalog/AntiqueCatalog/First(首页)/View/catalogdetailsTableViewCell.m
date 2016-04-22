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
        
        //[self initSubView];
        
    }
    return self;
}

- (void)initSubView
{
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = White_Color;
    
    _cover = [[UIImageView alloc]initWithFrame:CGRectMake(40, 40, 88, 116)];
    _cover.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _cover.layer.shadowColor = [UIColor blackColor].CGColor;
    _cover.layer.shadowOffset = CGSizeMake(4, 4);
    _cover.layer.shadowOpacity = 0.5;
    _cover.layer.shadowRadius = 2.0;
    
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
        
        UILabel * backgroundColorLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cover.frame)+40, UI_SCREEN_WIDTH, 20)];
        backgroundColorLabel.backgroundColor = [UIColor colorWithConvertString:Background_Color];
        [view addSubview:backgroundColorLabel];
        
        float everyViewWidth = (UI_SCREEN_WIDTH - 4) / 3;
        
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(everyViewWidth, CGRectGetMaxY(_cover.frame)+75, 1, 30)];
        label1.backgroundColor = Deputy_Colour;
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(everyViewWidth * 2 + 2, CGRectGetMaxY(_cover.frame)+75, 1, 30)];
        label2.backgroundColor = Deputy_Colour;
        [view addSubview:label1];
        [view addSubview:label2];
        
        UIView * leftView = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_cover.frame)+60, everyViewWidth, 60)];
        leftView.backgroundColor = [UIColor whiteColor];
        
        UIView * centerView = [[UIView alloc]initWithFrame:CGRectMake(everyViewWidth + 2, CGRectGetMaxY(_cover.frame)+60, everyViewWidth, 60)];
        centerView.backgroundColor = [UIColor whiteColor];
        
        UIView * rightView = [[UIView alloc]initWithFrame:CGRectMake(everyViewWidth * 2 + 4, CGRectGetMaxY(_cover.frame)+60, everyViewWidth, 60)];
        rightView.backgroundColor = [UIColor whiteColor];
        
        [view addSubview:leftView];
        [view addSubview:centerView];
        [view addSubview:rightView];
        
        UIImage * image1 = [UIImage imageNamed:@"photoDetail1"];
        UIImageView * imgeV1 = [[UIImageView alloc] initWithImage:image1];
        imgeV1.frame = CGRectMake((leftView.bounds.size.width - 30) / 2, 5, 30, 30);
        UILabel * image1Label = [[UILabel alloc]initWithFrame:CGRectMake((leftView.bounds.size.width - 70) /2, 35, 70, 20)];
        image1Label.text = @"加入云库";
        image1Label.textAlignment = NSTextAlignmentCenter;
        image1Label.font = [UIFont systemFontOfSize:14];
        image1Label.textColor = Deputy_Colour;
        UIButton * leftButton = [UIButton buttonWithType:UIButtonTypeSystem];
        leftButton.frame = leftView.bounds;
        leftButton.tag = 11;
        [leftButton addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [leftView addSubview:imgeV1];
        [leftView addSubview:image1Label];
        [leftView addSubview:leftButton];
        
        UIImage * image2 = [UIImage imageNamed:@"photoDetail2"];
        UIImageView * imgeV2 = [[UIImageView alloc] initWithImage:image2];
        imgeV2.frame = CGRectMake((centerView.bounds.size.width - 30) / 2, 5, 30, 30);
        UILabel * image2Label = [[UILabel alloc]initWithFrame:CGRectMake((centerView.bounds.size.width - 70) /2, 35, 70, 20)];
        image2Label.text = @"评论";
        image2Label.textAlignment = NSTextAlignmentCenter;
        image2Label.font = [UIFont systemFontOfSize:14];
        image2Label.textColor = Deputy_Colour;
        UIButton * centerButton = [UIButton buttonWithType:UIButtonTypeSystem];
        centerButton.frame = centerView.bounds;
        centerButton.tag = 22;
        [centerButton addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [centerView addSubview:imgeV2];
        [centerView addSubview:image2Label];
        [centerView addSubview:centerButton];
        
        UIImage * image3 = [UIImage imageNamed:@"photoDetail3"];
        UIImageView * imgeV3 = [[UIImageView alloc] initWithImage:image3];
        imgeV3.frame = CGRectMake((rightView.bounds.size.width - 30) / 2, 5, 30, 30);
        UILabel * image3Label = [[UILabel alloc]initWithFrame:CGRectMake((rightView.bounds.size.width - 70) /2, 35, 70, 20)];
        image3Label.text = @"分享";
        image3Label.textAlignment = NSTextAlignmentCenter;
        image3Label.font = [UIFont systemFontOfSize:14];
        image3Label.textColor = Deputy_Colour;
        UIButton * rightButton = [UIButton buttonWithType:UIButtonTypeSystem];
        rightButton.frame = rightView.bounds;
        rightButton.tag = 33;
        [rightButton addTarget:self action:@selector(threeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [rightView addSubview:imgeV3];
        [rightView addSubview:image3Label];
        [rightView addSubview:rightButton];
        
        
        _reading = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"阅读" Withcolor:White_Color WithSelectcolor:White_Color Withfont:Catalog_Cell_Name_Font WithBgcolor:Blue_color WithcornerRadius:4 Withbold:YES];
        //_reading.frame = CGRectMake(16, CGRectGetMaxY(_cover.frame)+40, (UI_SCREEN_WIDTH-16-8-16)/2, 40);
        _reading.frame = CGRectMake(16, CGRectGetMaxY(centerView.frame), (UI_SCREEN_WIDTH-16-8-16)/2, 40);
        [_reading addTarget:self action:@selector(readingclick) forControlEvents:UIControlEventTouchUpInside];
        
        _cataloglist = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"下载" Withcolor:Deputy_Colour WithSelectcolor:Deputy_Colour Withfont:Catalog_Cell_Name_Font WithBgcolor:White_Color WithcornerRadius:4 Withbold:YES];
        //_cataloglist.frame = CGRectMake(CGRectGetMaxX(_reading.frame)+8, CGRectGetMaxY(_cover.frame)+40, (UI_SCREEN_WIDTH-16-8-16)/2, 40);
        _cataloglist.frame = CGRectMake(CGRectGetMaxX(_reading.frame)+8, CGRectGetMaxY(centerView.frame), (UI_SCREEN_WIDTH-16-8-16)/2, 40);
        [_cataloglist addTarget:self action:@selector(downloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
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
        //view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 40+116+40+40+16);
        view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 40+116+60+60+40+16);
    }else{
        view.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 40+116+39);

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
    
    if (_delegate &&[_delegate respondsToSelector:@selector(readingButtonDidClick)]) {
        [_delegate readingButtonDidClick];
    }
    
}
- (void)downloadButtonClick{
    if (_delegate &&[_delegate respondsToSelector:@selector(downloadButtonDidClick)]) {
        [_delegate downloadButtonDidClick];
    }
}


-(void)threeButtonClick:(UIButton*)sender{
    switch (sender.tag) {
        case 11:{
            [self.delegate leftViewDidClick];
        }break;
            
        case 22:{
            [self.delegate centerViewDidClick];
        }break;
            
        case 33:{
            [self.delegate rightViewDidClick];
        }break;
            
        default:
            break;
    }
}
@end
