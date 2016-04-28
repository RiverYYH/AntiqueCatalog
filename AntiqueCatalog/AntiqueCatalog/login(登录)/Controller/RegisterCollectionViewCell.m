//
//  RegisterCollectionViewCell.m
//  Collector
//
//  Created by 刘鹏 on 14/12/2.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "RegisterCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation RegisterCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _registerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.width)];
        _registerImageView.userInteractionEnabled = YES;
        _registerImageView.layer.masksToBounds = YES;
        [self addSubview:_registerImageView];
        
        _registerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.width+12, frame.size.width, 20)];
        _registerLabel.textColor = TITLE_COLOR;
        _registerLabel.font = [UIFont systemFontOfSize:12];
        _registerLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:_registerLabel];
        
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_registerButton setImage:[UIImage imageNamed:@"Login_tuijian"] forState:UIControlStateNormal];
        [_registerButton setImage:[UIImage imageNamed:@"Login_tuijian_selected"] forState:UIControlStateSelected];
        _registerButton.selected = YES;
        [self addSubview:_registerButton];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(registerCollectionViewCell:buttonClicked:andIndexPath:)])
    {
        [self.delegate registerCollectionViewCell:self buttonClicked:button.selected andIndexPath:_indexPath];
    }
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
//    if (indexPath.section == 0)
//    {
//        [_registerImageView setImageWithURL:[NSURL URLWithString:[data objectForKey:@"avatar_middle"]] placeholderImage:[UIImage imageNamed:@"morentupian"]];
//        _registerImageView.layer.cornerRadius = 4;
//        _registerLabel.text = [data objectForKey:@"weiba_name"];
//        _registerButton.frame = CGRectMake(_registerImageView.frame.size.width-22, _registerImageView.frame.size.height-22, 22, 22);
//    }
//    else
//    {
//
//    }
    [_registerImageView sd_setImageWithURL:[NSURL URLWithString:[[data objectForKey:@"userInfo"] objectForKey:@"avatar_middle"]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    _registerImageView.layer.cornerRadius = _registerImageView.frame.size.width/2.0;
    _registerLabel.text = [[data objectForKey:@"userInfo"] objectForKey:@"uname"];
    _registerButton.frame = CGRectMake(_registerImageView.frame.size.width-22, 0, 22, 22);
}

@end
