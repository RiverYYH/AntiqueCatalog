//
//  catalogdetailsTagTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/10.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "catalogdetailsTagTableViewCell.h"

@interface catalogdetailsTagTableViewCell ()

@property (nonatomic,strong)UILabel      *taglabel;
@property (nonatomic,strong)UIScrollView *scroellView;
@property (nonatomic,strong)NSArray      *dicarray;

@end

@implementation catalogdetailsTagTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        _dicarray = [[NSArray alloc]init];
        
    }
    return self;
}

- (void)initSubView{
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 10, UI_SCREEN_WIDTH, 80)];
    view.backgroundColor = White_Color;
    self.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _taglabel = [Allview Withstring:@"图录标签" Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _taglabel.frame = CGRectMake(16, 0, UI_SCREEN_WIDTH - 32, 30);
    
    _scroellView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_taglabel.frame), UI_SCREEN_WIDTH, 50)];
    _scroellView.showsVerticalScrollIndicator = NO;
    _scroellView.showsHorizontalScrollIndicator = NO;
    _scroellView.scrollEnabled = YES;
    
    [view addSubview: _taglabel];
    [view addSubview:_scroellView];
    [self.contentView addSubview:view];
    
}

- (void)setCatalogdetailsData:(catalogdetailsdata *)catalogdetailsData{
    
    _dicarray = catalogdetailsData.tag;
    NSArray *array = catalogdetailsData.tag;
    NSArray *colorarray = @[@"#fef3dd",@"#c6ebf8",@"#ddf0d7"];
    CGFloat x = 0.0f;
    for (NSInteger i = 0; i < array.count; i++) {
        NSInteger j = i%colorarray.count;
        UILabel *label = [Allview Withstring:[[array objectAtIndex:i] objectForKey:@"name"] Withcolor:Deputy_Colour Withbgcolor:[UIColor colorWithConvertString:[colorarray objectAtIndex:j]] Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
        label.tag = i;
        //开启交互功能
        label.userInteractionEnabled = YES;
        //添加点击动作
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTapOne:)];
        tap.numberOfTouchesRequired = 1;
        tap.numberOfTapsRequired = 1;
        [label addGestureRecognizer:tap];
        
        CGSize labelsize = [Allview String:[[array objectAtIndex:i] objectForKey:@"name"] Withfont:Catalog_Cell_info_Font WithCGSize:2000 Withview:label Withinteger:1];
        if (i == 0) {
            label.frame = CGRectMake(16 + x, 0, labelsize.width + 20, 32);
        }else{
            label.frame = CGRectMake(x + 8, 0, labelsize.width + 20, 32);
        }
        
        x = CGRectGetMaxX(label.frame);
        [_scroellView addSubview:label];
        
        if (x > UI_SCREEN_WIDTH) {
            _scroellView.contentSize = CGSizeMake(x + 16, 0);
 
        }
    }
    
}

-(void)handleTapOne:(UITapGestureRecognizer *)recognizer{
    
    NSDictionary *dic = _dicarray[recognizer.view.tag];
    
    
    if (_delegate && [self.delegate respondsToSelector:@selector(hanTapOne:)]) {
        
        [self.delegate hanTapOne:dic];
    }
    
}

@end
