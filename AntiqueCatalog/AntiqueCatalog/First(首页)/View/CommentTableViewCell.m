//
//  CommentTableViewCell.m
//  Collector
//
//  Created by 刘鹏 on 14/11/22.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

@implementation CommentTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //选中无状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        //头像
        _userFaceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 40, 40)];
        _userFaceImageView.layer.masksToBounds = YES;
        _userFaceImageView.layer.cornerRadius = 20;
        _userFaceImageView.userInteractionEnabled = YES;
        [self addSubview:_userFaceImageView];
        
        //名字
        _nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, 13, 250, 19)];
        _nameLabel.textColor = WEIBO_TITLE_COLOR;
        _nameLabel.font = [UIFont systemFontOfSize:15.0];
        [self addSubview:_nameLabel];
        
        //楼层
        _floorLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _floorLabel.textColor = CONTENT_COLOR;
        _floorLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_floorLabel];
        
        //时间
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLabel.textColor = CONTENT_COLOR;
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        [self addSubview:_timeLabel];
        
        //评论
        _pinglunButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pinglunButton.frame = CGRectMake(UI_SCREEN_WIDTH-12-22, 15, 22, 22);
        _pinglunButton.adjustsImageWhenHighlighted = NO;
        [_pinglunButton setImage:[UIImage imageNamed:@"WeiBoConmment_pinglun"] forState:UIControlStateNormal];
        [_pinglunButton addTarget:self action:@selector(pinglunButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_pinglunButton];
        
        //评论内容
        _pinglunView  = [[LPRichTextView alloc] initWithFrame:CGRectZero];
        _pinglunView.font = [UIFont systemFontOfSize:16.0];
        _pinglunView.backgroundColor = [UIColor clearColor];
        [_pinglunView setTextColor:WEIBO_TITLE_COLOR];
        _pinglunView.isChat = NO;
        [self addSubview:_pinglunView];
        
        //分割线
        _lineImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
        _lineImageView.backgroundColor = LINE_COLOR;
        [self addSubview:_lineImageView];
    }
    return self;
}

- (void)pinglunButtonClicked
{
    
}

+ (CGFloat)heightForCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    float weiboHeight = 0;
    
    NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
    weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:UI_SCREEN_WIDTH-76 font:[UIFont systemFontOfSize:16] lineSpacing:1.5];
    
    return weiboHeight+60;
}
- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    [_userFaceImageView sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"user_info"] objectForKey:@"avatar"] objectForKey:@"avatar_middle"]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    _nameLabel.text = [[data objectForKey:@"user_info"] objectForKey:@"uname"];
	_floorLabel.text = [NSString stringWithFormat:@"%@楼",[data objectForKey:@"floor"]];
    _timeLabel.text = [UserModel formateTime:[data objectForKey:@"ctime"]];

    //等级小图标
    NSDictionary * dic1= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName,nil];
	CGSize titleSize = [_nameLabel.text boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
	NSArray *userArr = [[data objectForKey:@"user_info"] objectForKey:@"user_group"];
    //remove原小图标
	for (UIView *view in self.contentView.subviews)
    {
		if(view.tag >= 111 && [view isKindOfClass:[UIImageView class]])
        {
			[view removeFromSuperview];
		}
	}
    //新建新小图标
	if ([userArr isKindOfClass:[NSArray class]] && [userArr count])
    {
		for (int i = 0; i < [userArr count]; i ++)
        {
			UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(64+titleSize.width+10+20*i, 15, 15, 15)];
			[userView sd_setImageWithURL:[NSURL URLWithString:[[userArr objectAtIndex:i] objectForKey:@"user_group_icon_url"]]];
			userView.tag = 111+i;
			[self.contentView addSubview:userView];
		}
	}
    
    //时间,楼层
	NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
	CGSize timeSize = [_floorLabel.text boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
	_floorLabel.frame = CGRectMake(64, 40, timeSize.width, 15);
	_floorLabel.textAlignment = NSTextAlignmentLeft;
	_timeLabel.frame = CGRectMake(CGRectGetMaxX(_floorLabel.frame)+5, 40, UI_SCREEN_WIDTH-(CGRectGetMaxX(_floorLabel.frame)+5)-12, 15);
    
    NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
    _pinglunView.text = content;
    _pinglunView.frame = CGRectMake(64, 60, UI_SCREEN_WIDTH-76, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:UI_SCREEN_WIDTH-76 font:[UIFont systemFontOfSize:16] lineSpacing:1.5]);
    
    _lineImageView.frame = CGRectMake(12, CGRectGetMaxY(_pinglunView.frame), UI_SCREEN_WIDTH-24, 0.5);
}

@end