//
//  AccountTableViewCell.m
//  Collector
//
//  Created by 刘鹏 on 14/12/3.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "AccountTableViewCell.h"

@implementation AccountTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //选中无状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _imageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 14, 22, 22)];
        [self.contentView addSubview:_imageView];
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(46, 14, UI_SCREEN_WIDTH-46-62, 22)];
        _label.font = [UIFont systemFontOfSize:16];
        _label.textColor = TITLE_COLOR;
        [self.contentView addSubview:_label];
        
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.frame = CGRectMake(UI_SCREEN_WIDTH-62, 14, 50, 22);
        _button.layer.masksToBounds = YES;
        _button.layer.cornerRadius = 4;
        _button.titleLabel.font = [UIFont systemFontOfSize:15];
        [_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_button];
    }
    return self;
}

- (void)buttonClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(buttonClicked:)])
    {
        [_delegate buttonClicked:_indexPath];
    }
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    NSLog(@"%ld",indexPath.row);
    
    if ([[data objectForKey:@"type"] isEqualToString:@"phone"])
    {
        _imageView.image = [UIImage imageNamed:@"Me_shouji"];
        _label.text = @"手机号";
    }
    else if ([[data objectForKey:@"type"] isEqualToString:@"qzone"])
    {
        _imageView.image = [UIImage imageNamed:@"Me_qq"];
        _label.text = @"腾讯QQ";
    }
    else if ([[data objectForKey:@"type"] isEqualToString:@"weixin"])
    {
        _imageView.image = [UIImage imageNamed:@"Me_weixin"];
        _label.text = @"微信";
    }
    else if ([[data objectForKey:@"type"] isEqualToString:@"sina"])
    {
        _imageView.image = [UIImage imageNamed:@"Me_weibo"];
        _label.text = @"新浪微博";
    }
    
    if ([[data objectForKey:@"isBind"] intValue])
    {
        if (indexPath.row == 0) {
            [_button setTitle:@"重置" forState:UIControlStateNormal];
            [_button setBackgroundColor:TITLE_COLOR];
        }else{
        [_button setTitle:@"解绑" forState:UIControlStateNormal];
        [_button setBackgroundColor:TITLE_COLOR];
        }
    }
    else
    {
        
        [_button setTitle:@"绑定" forState:UIControlStateNormal];
        [_button setBackgroundColor:CONTENT_COLOR];
    }
}

@end
