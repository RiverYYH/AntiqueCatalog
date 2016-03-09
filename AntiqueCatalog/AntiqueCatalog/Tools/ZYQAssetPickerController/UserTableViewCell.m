//
//  UserTableViewCell.m
//  Collector
//
//  Created by 刘鹏 on 14/11/17.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "UserTableViewCell.h"
#import "UIImageView+WebCache.h"

@implementation UserTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //选中无状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        _userFaceImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12 , 10, 40, 40)];
        [_userFaceImageView.layer setMasksToBounds:YES];
        [_userFaceImageView.layer setCornerRadius:20];
        _userFaceImageView.userInteractionEnabled = YES;
        [self.contentView addSubview:_userFaceImageView];
        
        _userfanceV = [[UIImageView alloc] initWithFrame:CGRectMake(37, 35, 15, 15)];
        _userfanceV.image = [UIImage imageNamed:@"FindPerson_V"];
        _userfanceV.hidden = YES;
        [self.contentView addSubview:_userfanceV];
        
        UITapGestureRecognizer *faceTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(faceClick)];
        [_userFaceImageView addGestureRecognizer:faceTgr];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 10, UI_SCREEN_WIDTH-64-50, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = TITLE_COLOR;
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(64, 30, UI_SCREEN_WIDTH-64-50, 20)];
        _contentLabel.font = [UIFont systemFontOfSize:14];
        _contentLabel.textColor = CONTENT_COLOR;
        [self.contentView addSubview:_contentLabel];
        
        _attentionButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _attentionButton.frame = CGRectMake(UI_SCREEN_WIDTH-48, 6, 48, 48);
        [_attentionButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _jiechuButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _jiechuButton.frame = CGRectMake(UI_SCREEN_WIDTH-70-12, 17.5, 70, 25);
        [_jiechuButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)buttonClicked:(UIButton *)button
{
    if (_delegate && [_delegate respondsToSelector:@selector(attentionButtonClicked:)])
    {
        [_delegate attentionButtonClicked:_indexPath];
    }
}

-(void)faceClick
{
	if ([self.delegate respondsToSelector:@selector(showUserProfileByName:)])
	{
		[self.delegate showUserProfileByName:_titleLabel.text];
	}
}

+ (CGFloat)heightForCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    return 60.0f;
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath andUserCellType:(UserCellType)userCellType
{
    [_attentionButton removeFromSuperview];
    [_jiechuButton removeFromSuperview];
    
    _indexPath = indexPath;
    
    if (userCellType == UserCellTypeNormal)
    {
        [self.contentView addSubview:_attentionButton];
        
        NSString *string = [data objectForKey:@"avatar"];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_userFaceImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        _titleLabel.text = [data objectForKey:@"uname"];
        
        if([[data objectForKey:@"recommend"] intValue] == 1) {
            _userfanceV.hidden = NO;
        } else {
            _userfanceV.hidden = YES;
        }
        
        if (STRING_NOT_EMPTY([data objectForKey:@"intro"]))
        {
            _contentLabel.text = [data objectForKey:@"intro"];
        }
        else
        {
            _contentLabel.text = @"";
        }
        
        [_attentionButton setImage:[UIImage imageNamed:[[[data objectForKey:@"follow_status"] objectForKey:@"following"] intValue]==1?@"xiaoguanzhu":@"jiaguanzhu"] forState:UIControlStateNormal];
    }
    else if (userCellType == UserCellTypeBlack)
    {
        [self.contentView addSubview:_jiechuButton];
        
        NSString *string = [data objectForKey:@"avatar"];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_userFaceImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        _titleLabel.text = [data objectForKey:@"uname"];
        
        if (STRING_NOT_EMPTY([data objectForKey:@"intro"]))
        {
            _contentLabel.text = [data objectForKey:@"intro"];
        }
        else
        {
            _contentLabel.text = @"";
        }
        
        [_jiechuButton setImage:[UIImage imageNamed:@"Me_jiechu"] forState:UIControlStateNormal];
    }
    else if (userCellType == UserCellTypeUnion)
    {
        NSString *string = [data objectForKey:@"avatar_middle"];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_userFaceImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        if (STRING_NOT_EMPTY([data objectForKey:@"uname"])) {
            _titleLabel.text = [data objectForKey:@"uname"];
        } else {
            _titleLabel.text = @"";
        }
        
        
        if (STRING_NOT_EMPTY([data objectForKey:@"intro"]))
        {
            _contentLabel.text = [data objectForKey:@"intro"];
        }
        else
        {
            _contentLabel.text = @"";
        }
    } else if (userCellType == UserCellTypeAttent) {
        [self.contentView addSubview:_attentionButton];
        
        NSString *string = [data objectForKey:@"avatar"];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_userFaceImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        _titleLabel.text = [data objectForKey:@"uname"];
        
        if (STRING_NOT_EMPTY([data objectForKey:@"intro"]))
        {
            _contentLabel.text = [data objectForKey:@"intro"];
        }
        else
        {
            _contentLabel.text = @"";
        }
        
        if([[[data objectForKey:@"follow_status"] objectForKey:@"following"] intValue]){
            [_attentionButton setImage:[UIImage imageNamed:@"yiguanzhu"] forState:UIControlStateNormal];
        } else {
            [_attentionButton setImage:[UIImage imageNamed:@"jiaguanzhu"] forState:UIControlStateNormal];
        }
        
    } else if (userCellType == UserCellTypeFans) {
        
        NSString *string = [[data objectForKey:@"avatar"] objectForKey:@"avatar_middle"];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_userFaceImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        _titleLabel.text = [data objectForKey:@"uname"];
        
        if (STRING_NOT_EMPTY([data objectForKey:@"intro"]))
        {
            _contentLabel.text = [data objectForKey:@"intro"];
        }
        else
        {
            _contentLabel.text = @"";
        }
    } else if (userCellType == UserCellTypeNear) {
        [self.contentView addSubview:_attentionButton];
        
        NSString *string = [data objectForKey:@"avatar"];
        string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [_userFaceImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
        
        _titleLabel.text = [data objectForKey:@"uname"];
        
        if (STRING_NOT_EMPTY([data objectForKey:@"distinct"]))
        {
            CGFloat distance = [[data objectForKey:@"distinct"] floatValue]*1000;
            if(distance >= 900) {
                NSInteger dis = distance/1000 + 1;
                _contentLabel.text = [NSString stringWithFormat:@"%ldkm以内",dis];
            } else {
                NSInteger dis = distance/100 + 1;
                _contentLabel.text = [NSString stringWithFormat:@"%ldm以内",dis*100];
            }
        }
        else
        {
            _contentLabel.text = @"";
        }
        
        [_attentionButton setImage:[UIImage imageNamed:[[[data objectForKey:@"follow_status"] objectForKey:@"following"] intValue]==1?@"xiaoguanzhu":@"jiaguanzhu"] forState:UIControlStateNormal];
    }
}

@end