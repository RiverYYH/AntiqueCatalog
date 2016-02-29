//
//  chapterTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/25.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "chapterTableViewCell.h"
@interface chapterTableViewCell()


@property (nonatomic,strong)UIButton     *namelabel;//章节名称


@end

@implementation chapterTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView{
    
    self.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    
    _namelabel = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH - 40, 40)];
    _namelabel.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    [_namelabel setContentEdgeInsets:UIEdgeInsetsMake(0,20, 0, 0)];
    [_namelabel setTitleColor:Essential_Colour forState:UIControlStateNormal];
    _namelabel.backgroundColor = White_Color;
    [_namelabel addTarget:self action:@selector(nameclick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self.contentView addSubview:_namelabel];
 
}

-(void)loadstring:(NSString *)string andIndexPath:(NSIndexPath *)indexPath{
    _namelabel.tag = indexPath.row;
    [_namelabel setTitle:string forState:UIControlStateNormal];
    
}

- (void)nameclick:(UIButton *)btn{
    
    if (_delegate && [_delegate respondsToSelector:@selector(gomenu:)]) {
        [_delegate gomenu:btn.tag];
    }
    
}

@end
