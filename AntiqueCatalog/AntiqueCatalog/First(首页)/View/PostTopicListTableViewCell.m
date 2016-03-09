//
//  PostTopicListTableViewCell.m
//  藏民网
//
//  Created by Hong on 15/5/9.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "PostTopicListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

@implementation PostTopicListTableViewCell
{
    UIImageView *_logoImageView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UILabel *_readersLabel;
    UIButton *_attentionBtn;
    
    NSIndexPath *_indexPath;
}
- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self configUI];
    }
    return self;
}
- (void)configUI
{
    //专辑主图
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 60, 60)];
    _logoImageView.image = [UIImage imageNamed:@"morentupian"];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _logoImageView.clipsToBounds = YES;
    [self.contentView addSubview:_logoImageView];
    //专辑名字
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 10, UI_SCREEN_WIDTH-80-60, 20)];
    [self.contentView addSubview:_titleLabel];
    //专辑简介
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, UI_SCREEN_WIDTH-80-60, 20)];
    _contentLabel.textColor = [UIColor grayColor];
    _contentLabel.font = [UIFont systemFontOfSize:11];
    _contentLabel.numberOfLines = 0;
    [self.contentView addSubview:_contentLabel];
    //专辑阅读量
    _readersLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 55, UI_SCREEN_WIDTH-90, 20)];
    _readersLabel.textColor = [UIColor lightGrayColor];
    _readersLabel.font = [UIFont systemFontOfSize:11];
    [self.contentView addSubview:_readersLabel];
    //关注
//    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _attentionBtn.frame = CGRectMake(UI_SCREEN_WIDTH-60, 15, 50, 50);
//    [_attentionBtn setImage:[UIImage imageNamed:@"jiaguanzhu"] forState:UIControlStateNormal];
//    [_attentionBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_attentionBtn];
}
- (void)updateCellWithData:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    
    if(STRING_NOT_EMPTY([dic objectForKey:@"pic"])) {
        [_logoImageView setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"Topic_morentupian.jpg"]];
    } else {
        [_logoImageView setImage:[UIImage imageNamed:@"Topic_morentupian.jpg"]];
    }
    if(STRING_NOT_EMPTY([dic objectForKey:@"des"])) {
        _contentLabel.text = [dic objectForKey:@"des"];
    } else {
        _contentLabel.text = @"暂无简介";
    }
    _titleLabel.text = [NSString stringWithFormat:@"#%@#",[dic objectForKey:@"topic_name"]];
    _readersLabel.text = [NSString stringWithFormat:@"%@阅读",[dic objectForKey:@"view_count"]];
    if (indexPath.section == 0) {
        _contentLabel.textColor = BLUE_COLOR;
    } else{
        _contentLabel.textColor = [UIColor grayColor];
    }
    _contentLabel.frame = CGRectMake(80, 35, UI_SCREEN_WIDTH-80-10, 20);
//    _attentionBtn.hidden = YES;
    if(indexPath.section) {
        _readersLabel.hidden = NO;
    } else {
        _readersLabel.hidden = YES;
    }
    
}
@end
