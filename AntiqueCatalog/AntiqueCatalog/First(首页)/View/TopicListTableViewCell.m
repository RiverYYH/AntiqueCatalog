//
//  TopicListTableViewCell.m
//  藏民网
//
//  Created by Hong on 15/3/17.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "TopicListTableViewCell.h"
#import "UIImageView+AFNetworking.h"

#import "UIImageView+WebCache.h"

@implementation TopicListTableViewCell
{
    UIImageView *_logoImageView;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UILabel *_readersLabel;
    UIButton *_attentionBtn;
    
    UILabel *_mylogo;
    
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
        self.backgroundColor = Global_Background;
        [self configUI];
    }
    return self;
}
- (void)configUI
{
   //专辑主图
    _logoImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_CELL_BG_WIDTH, UI_CELL_BG_WIDTH/2, UI_SCREEN_WIDTH-UI_CELL_BG_WIDTH*2, 200)];
    _logoImageView.contentMode = UIViewContentModeScaleAspectFill;
    _logoImageView.clipsToBounds = YES;
    _logoImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    _logoImageView.layer.borderWidth = 1.0;
    [self.contentView addSubview:_logoImageView];
    
    //蒙版
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, _logoImageView.frame.size.width, 60)];
    bgImageView.image = [UIImage imageNamed:@"mengban"];
    [_logoImageView addSubview:bgImageView];
    
    //专辑名字
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, UI_SCREEN_WIDTH-40, 30)];
    _titleLabel.font = [UIFont systemFontOfSize:20];
    _titleLabel.textColor = [UIColor whiteColor];
    [_logoImageView addSubview:_titleLabel];
    //专辑简介
//    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 35, UI_SCREEN_WIDTH-80-60, 20)];
//    _contentLabel.textColor = [UIColor grayColor];
//    _contentLabel.font = [UIFont systemFontOfSize:11];
//    _contentLabel.numberOfLines = 0;
//    [self.contentView addSubview:_contentLabel];
    //专辑阅读量
    _readersLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, UI_SCREEN_WIDTH-40, 20)];
    _readersLabel.textColor = [UIColor whiteColor];
    _readersLabel.font = [UIFont systemFontOfSize:14];
    [_logoImageView addSubview:_readersLabel];
    //关注
//    _attentionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _attentionBtn.frame = CGRectMake(UI_SCREEN_WIDTH-60, 15, 50, 50);
//    [_attentionBtn setImage:[UIImage imageNamed:@"jiaguanzhu"] forState:UIControlStateNormal];
//    [_attentionBtn addTarget:self action:@selector(btnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [self.contentView addSubview:_attentionBtn];
    
    
}
- (void)updateCellWithData:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath andTopicListType:(TopicListType)topicListType
{
    _indexPath = indexPath;
    
    [_logoImageView sd_setImageWithURL:[NSURL URLWithString:[dic objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"Topic_morentupian.jpg"]];
    if(STRING_NOT_EMPTY([dic objectForKey:@"des"])) {
         _contentLabel.text = [dic objectForKey:@"des"];
    } else {
        _contentLabel.text = @"暂无简介";
    }
//    NSLog(@"%@",dic[@"userinfo"][@"uid"]);
//    NSLog(@"%@",[[UserModel userPassport] objectForKey:@"uid"]);
//    if ([dic[@"userinfo"][@"uid"] isEqual: [[UserModel userInformation] objectForKey:@"uid"]]) {
//        _mylogo.hidden = NO;
//    }
    
    [_mylogo removeFromSuperview];
    _mylogo = nil;
    
    _mylogo = [Allview Withstring:@"创" Withcolor:TITLE_COLOR Withbgcolor:RGBACOLOR(255, 255, 255, 0.6) Withfont:16 WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _mylogo.frame = CGRectMake(_logoImageView.frame.size.width - 34, 10, 24, 24);
    _mylogo.layer.masksToBounds = YES;
    _mylogo.layer.cornerRadius = 12;
    [_logoImageView addSubview:_mylogo];
    _mylogo.hidden = YES;
    
    if ([dic[@"userinfo"][@"uname"] isEqualToString:[UserModel userUname]]) {
        _mylogo.hidden = NO;
    }
    
    _titleLabel.text = [NSString stringWithFormat:@"#%@#",[dic objectForKey:@"topic_name"]];
    _readersLabel.text = [NSString stringWithFormat:@"%@阅读",[dic objectForKey:@"view_count"]];
    if (topicListType == TopicListTypeSquare) {
        _contentLabel.textColor = [UIColor lightGrayColor];
        if([[dic objectForKey:@"favorite"] integerValue]) {
            [_attentionBtn setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
        } else {
            [_attentionBtn setImage:[UIImage imageNamed: @"jiaguanzhu"] forState:UIControlStateNormal];
        }
        _readersLabel.hidden = NO;
    } else if (topicListType == TopicListTypeMyself) {
        _contentLabel.textColor = [UIColor lightGrayColor];
        [_attentionBtn setImage:[UIImage imageNamed:@"TopicDetail_setting"] forState:UIControlStateNormal];
        _contentLabel.frame = CGRectMake(80, 35, UI_SCREEN_WIDTH-80-60, 20);
        _readersLabel.hidden = NO;
    } else if(topicListType == TopicListTypeMyAttention) {
        _contentLabel.textColor = [UIColor lightGrayColor];
        _contentLabel.frame = CGRectMake(80, 35, UI_SCREEN_WIDTH-80-10, 20);
        _attentionBtn.hidden = YES;
        _readersLabel.hidden = NO;
    } else if (topicListType == TopicListTypeTopicPost) {
        _contentLabel.textColor = [UIColor blueColor];
        _contentLabel.frame = CGRectMake(80, 35, UI_SCREEN_WIDTH-80-10, 20);
        _attentionBtn.hidden = YES;
        _readersLabel.hidden = YES;
    }
    
}
- (void)btnClicked
{
    if(_delegate && [_delegate respondsToSelector:@selector(topicListViewCell:guanzhuButtonClickedWithIndexPath:)]) {
        [_delegate topicListViewCell:self guanzhuButtonClickedWithIndexPath:_indexPath];
    }
}
@end
