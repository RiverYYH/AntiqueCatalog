//
//  WeiBoTableViewCell.m
//  Collector
//
//  Created by zhishi on 14/11/20.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import "WeiBoTableViewCell.h"
#import "UIImageView+WebCache.h"
#import "UIImageView+AFNetworking.h"
#import "UIButton+WebCache.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"


#define kBgWidth (UI_SCREEN_WIDTH-UI_CELL_BG_WIDTH*2)

@interface WeiBoTableViewCell()

@property (nonatomic,assign)CGFloat weibotextviewHeight;

@end

@implementation WeiBoTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //选中无状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = BG_COLOR;
        
        _weibotextviewHeight = 82.0;
        
        _mainBgView = [[UIView alloc] initWithFrame:CGRectMake(UI_CELL_BG_WIDTH, UI_CELL_BG_WIDTH/2, kBgWidth, self.frame.size.height-UI_CELL_BG_WIDTH)];
        _mainBgView.backgroundColor = [UIColor whiteColor];
        _mainBgView.userInteractionEnabled = YES;
//        _mainBgView.layer.cornerRadius = 5;
//        _mainBgView.layer.masksToBounds = YES;
        [self.contentView addSubview:_mainBgView];
        
        _imageArray = [NSArray array];
        _dataDitionary = [NSDictionary dictionary];
        
        //头像
        _userFaceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 40, 40)];
        _userFaceImageView.layer.masksToBounds = YES;
        _userFaceImageView.layer.cornerRadius = 20;
        _userFaceImageView.userInteractionEnabled = YES;
        [_mainBgView addSubview:_userFaceImageView];
        
        UITapGestureRecognizer *faceTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(faceClick)];
        [_userFaceImageView addGestureRecognizer:faceTgr];
        
        //名字
        _nameLabel = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nameLabel setTitleColor:WEIBO_TITLE_COLOR forState:UIControlStateNormal];
        _nameLabel.titleLabel.font = [UIFont systemFontOfSize:15.0];
        [_nameLabel addTarget:self action:@selector(faceClick) forControlEvents:UIControlEventTouchUpInside];
        [_mainBgView addSubview:_nameLabel];
        
        //时间
        _timeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _timeLabel.textColor = CONTENT_COLOR;
        _timeLabel.font = [UIFont systemFontOfSize:12.0];
        [_mainBgView addSubview:_timeLabel];
        
        //来自地名
        _comeLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        _comeLabel.textColor = CONTENT_COLOR;
        _comeLabel.font = [UIFont systemFontOfSize:12.0];
        [_mainBgView addSubview:_comeLabel];
        
        //按钮底部的视图
        _btnBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _mainBgView.frame.size.width, 40)];
        _btnBgView.backgroundColor = BAR_COLOR;
        _btnBgView.userInteractionEnabled = YES;
        [_mainBgView addSubview:_btnBgView];
        
        UILabel *upLineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, kBgWidth-4, 0.3)];
        upLineLabel.backgroundColor = BG_COLOR;
        [_btnBgView addSubview:upLineLabel];
        
        UILabel *middle1LineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBgWidth/4, 0, 0.3, 40)];
        middle1LineLabel.backgroundColor = BG_COLOR;
        [_btnBgView addSubview:middle1LineLabel];
        
        UILabel *middle2LineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBgWidth/2, 0, 0.3, 40)];
        middle2LineLabel.backgroundColor = BG_COLOR;
        [_btnBgView addSubview:middle2LineLabel];
        
        UILabel *middle3LineLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBgWidth/4*3, 0, 0.3, 40)];
        middle3LineLabel.backgroundColor = BG_COLOR;
        [_btnBgView addSubview:middle3LineLabel];
        
        //转发按钮
        _forwadButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _forwadButton.frame = CGRectMake(kBgWidth/8-20, 0, 40, 40);
        _forwadButton.tag = 4;
        [_forwadButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBgView addSubview:_forwadButton];
        
        //转发数
        _forwadLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBgWidth/8+5, 0, kBgWidth/8-5, 40)];
        _forwadLabel.textColor = CONTENT_COLOR;
        _forwadLabel.font = [UIFont systemFontOfSize:15.0];
        [_btnBgView addSubview:_forwadLabel];
        
        //评论按钮
        _pinglunButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _pinglunButton.frame = CGRectMake(kBgWidth/8*3-30, 0, 40, 40);
        _pinglunButton.tag = 1;
        [_pinglunButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBgView addSubview:_pinglunButton];
        
        //评论数
        _pinglunLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBgWidth/8*3+5, 0, kBgWidth/8-5, 40)];
        _pinglunLabel.textColor = CONTENT_COLOR;
        _pinglunLabel.font = [UIFont systemFontOfSize:15.0];
        [_btnBgView addSubview:_pinglunLabel];
        
        //赞按钮
        _zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _zanButton.frame = CGRectMake(kBgWidth/8*5-30, 0, 40, 40);
        _zanButton.tag = 2;
        [_zanButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBgView addSubview:_zanButton];
        
        //赞数
        _zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBgWidth/8*5+5, 0, kBgWidth/8-5, 40)];
        _zanLabel.textColor = CONTENT_COLOR;
        _zanLabel.font = [UIFont systemFontOfSize:15.0];
        [_btnBgView addSubview:_zanLabel];
        
        //分享按钮
        _shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _shareButton.frame = CGRectMake(kBgWidth/8*7-20, 0, 40, 40);
        _shareButton.tag = 3;
        [_shareButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_btnBgView addSubview:_shareButton];
        
        //分享数
        _shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(kBgWidth/8*7+5, 0, kBgWidth/8-5, 40)];
        _shareLabel.textColor = CONTENT_COLOR;
        _shareLabel.font = [UIFont systemFontOfSize:15.0];
        [_btnBgView addSubview:_shareLabel];
        
        //原微博内容
        _weiboView  = [[LPRichTextView alloc] initWithFrame:CGRectZero];
        _weiboView.font = [UIFont systemFontOfSize:16.0];
        _weiboView.backgroundColor = [UIColor clearColor];
        _weiboView.delegage = self;
        _weiboView.isChat = NO;
        _weiboView.userInteractionEnabled = YES;
        [_weiboView setTextColor:WEIBO_TITLE_COLOR];
        
        //转发微博背景
        _forwardBgView = [[UIView alloc] initWithFrame:CGRectZero];
        //_forwardBgView.backgroundColor = RGBA(222, 218, 203);
        _forwardBgView.backgroundColor = [UIColor clearColor];
        _forwardBgView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *forwardTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forwardClick)];
        [_forwardBgView addGestureRecognizer:forwardTgr];
        
        //转发微博内容
        _forwardView  = [[LPRichTextView alloc] initWithFrame:CGRectZero];
        _forwardView.font = [UIFont systemFontOfSize:15.0];
        _forwardView.backgroundColor = [UIColor clearColor];
        _forwardView.text = @"";
        _forwardView.isChat = NO;
        [_forwardBgView addSubview:_forwardView];
        
        //放置图片底view
        _imageArrayView = [[UIView alloc] initWithFrame:CGRectZero];
        
        //放标签的View
        _categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kBgWidth-4, 40)];
        _categoryView.backgroundColor = [UIColor clearColor];
        _categoryView.userInteractionEnabled = YES;
        
    }
    return self;
}

- (void)buttonClicked:(UIButton *)button
{
    switch (button.tag)
    {
        case 1:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(weiboTableViewCell:pinglunButtonClickedWithIndexPath:)])
            {
                [_delegate weiboTableViewCell:self pinglunButtonClickedWithIndexPath:_indexPath];
            }
        }
            break;
        case 2:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(weiboTableViewCell:zanButtonClickedWithIndexPath:)])
            {
                //赞的动画效果
                CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
                k.values = @[@(0.1),@(1.5),@(1.5)];
                k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
                k.calculationMode = kCAAnimationLinear;
                [_zanButton.layer addAnimation:k forKey:@"SHOW"];
                [_zanButton.layer addAnimation:k forKey:@"SHOW"];

                [_delegate weiboTableViewCell:self zanButtonClickedWithIndexPath:_indexPath];
            }
        }
            break;
        case 3:
        {
            if(_delegate && [_delegate respondsToSelector:@selector(weiboTableViewCell:shareButtonClickedWithIndexPath:)]) {
                [_delegate weiboTableViewCell:self shareButtonClickedWithIndexPath:_indexPath];
            }
        }
            break;
        case 4:
        {
            if(_delegate && [_delegate respondsToSelector:@selector(weiboTableViewCell:forwadButtonClickedWithIndexPath:)]) {
                [_delegate weiboTableViewCell:self forwadButtonClickedWithIndexPath:_indexPath];
            }
        }
            break;
        default:
            break;
    }
}
-(void)faceClick
{
	if ([self.delegate respondsToSelector:@selector(weiboTableViewCell:showUserProfileByName:)])
	{
		[self.delegate weiboTableViewCell:self showUserProfileByName:_nameLabel.titleLabel.text];
	}
}
-(void)forwardClick
{
    if ([[_dataDitionary objectForKey:@"type"] isEqualToString:@"repost"])
    {
        if([[_dataDitionary objectForKey:@"post_type"] integerValue]) {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:gotoLongWeiboDetail:)])
            {
                [_delegate weiboTableViewCell:self gotoLongWeiboDetail:_dataDitionary];
            }
        } else {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:gotoForwardDetail:)])
            {
                [_delegate weiboTableViewCell:self gotoForwardDetail:[_dataDitionary objectForKey:@"source_info"]];
            }
        }
    }
    else if ([[_dataDitionary objectForKey:@"type"] isEqualToString:@"weiba_post"]) {
        if ([_delegate respondsToSelector:@selector(weiboTableViewCell:gotoLongWeiboDetail:)])
        {
            [_delegate weiboTableViewCell:self gotoLongWeiboDetail:_dataDitionary];
        }
        
    } else if ([[_dataDitionary objectForKey:@"type"] isEqualToString:@"weiba_repost"]) {
        if ([_delegate respondsToSelector:@selector(weiboTableViewCell:gotoLongWeiboDetail:)])
        {
            [_delegate weiboTableViewCell:self gotoLongWeiboDetail:[_dataDitionary objectForKey:@"source_info"]];
        }
    }
    else if ([[_dataDitionary objectForKey:@"type"] isEqualToString:@"blog_post"])
    {
        if ([_delegate respondsToSelector:@selector(weiboTableViewCell:gotoBlogDetail:)])
        {
            [_delegate weiboTableViewCell:self gotoBlogDetail:_dataDitionary];
        }
    }
    else if ([[_dataDitionary objectForKey:@"type"] isEqualToString:@"blog_repost"])
    {
        if ([_delegate respondsToSelector:@selector(weiboTableViewCell:gotoBlogDetail:)])
        {
            [_delegate weiboTableViewCell:self gotoBlogDetail:[_dataDitionary objectForKey:@"source_info"]];
        }
    }
    else if ([[_dataDitionary objectForKey:@"type"] isEqualToString:@"post"])
    {
        if([[_dataDitionary objectForKey:@"post_type"] integerValue]) {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:gotoLongWeiboDetail:)])
            {
                [_delegate weiboTableViewCell:self gotoLongWeiboDetail:_dataDitionary];
            }
        }
    }
}

+ (CGFloat)heightForCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    CGFloat weiboHeight = 0;
    if(![data isKindOfClass:[NSDictionary class]]) {
        return 0;
    }
    //普通微博
    if ([[data objectForKey:@"type"] isEqualToString:@"post"])
    {
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-4 font:[UIFont systemFontOfSize:16] lineSpacing:1.5];
        
        if (weiboHeight > 85.0) {
            weiboHeight = 82.0;
        }
        
    }
    //图片微博
    else if ([[data objectForKey:@"type"] isEqualToString:@"postimage"])
    {
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        
        if ([LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5] > 85.0) {
            weiboHeight += 82.0;
        }else{
            weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5];
        }
        
        NSInteger number = [[data objectForKey:@"attach_info"] count];
        if (number == 1)
        {
            NSInteger imageHeight = [[[[data objectForKey:@"attach_info"] firstObject] objectForKey:@"height"] integerValue];
            NSInteger imageWidth = [[[[data objectForKey:@"attach_info"] firstObject] objectForKey:@"width"] integerValue];
            if(imageWidth == 0) {
                imageWidth = 1;
            }
            weiboHeight += 10+imageHeight*(kBgWidth)/imageWidth;
        }else if (number == 2) {
            weiboHeight += 10+(kBgWidth-2)/2.0;
        }
        else if (number == 4)
        {
            weiboHeight += 10+(kBgWidth-2)/2.0*2+2;
        }
        else
        {
            weiboHeight += 10+(kBgWidth-4)/3.0*((number-1)/3+1)+2*((number-1)/3);
        }
    }
    //视频微博
    else if ([[data objectForKey:@"type"] isEqualToString:@"postvideo"])
    {
//        NSString *content = [[[[[data objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"title"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        
        if ([LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5] > 85.0) {
            weiboHeight += 82.0;
        }else{
            weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5];
        }
        
//        NSLog(@"-------%f",weiboHeight);
        
        weiboHeight += 10+3*(kBgWidth-4)/4;
    }
    //转发微博
	else if ([[data objectForKey:@"type"] isEqualToString:@"repost"])
    {
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5];
        
        if ([[[data objectForKey:@"source_info"] objectForKey:@"is_del"] intValue] == 1)
        {
            weiboHeight += 19+12;
        }
        else
        {
            //转发内容为普通微博
            if ([[[data objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"post"])
            {
                NSString *content = [[data objectForKey:@"source_info"] objectForKey:@"content"];
                content = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
                weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+12;
            }
            //转发内容为图片微博
            else if ([[[data objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"postimage"])
            {
                NSString *content = [[data objectForKey:@"source_info"] objectForKey:@"content"];
                
                content = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
                
                //宽高((UI_SCREEN_WIDTH-50-12)-24-4)/3.0
                NSInteger number = [[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] count];
                if (number == 1)
                {
                    NSInteger imageHeight = [[[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] firstObject] objectForKey:@"height"] integerValue];
                    NSInteger imageWidth = [[[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] firstObject] objectForKey:@"width"] integerValue];
                    if(imageWidth == 0) {
                        imageWidth = 1;
                    }
                    weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+imageHeight*(kBgWidth-4)/imageWidth+12;
                } else if (number == 4 || number == 2)
                {
                    weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+(kBgWidth-4-2)/2.0*((number-1)/2+1)+2*((number-1)/2)+12;
                }
                else
                {
                    weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+(kBgWidth-4-4)/3.0*((number-1)/3+1)+2*((number-1)/3)+12;
                }
            }
            //转发内容为视频微博
            else if ([[[data objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"postvideo"])
            {
                NSString *content = [[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"title"];
                content = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
                
                weiboHeight += [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+3*(kBgWidth-4)/4+12;
            }
        }
    }
    //帖子/知识转发过来的分享微博
    else if ([[data objectForKey:@"type"] isEqualToString:@"weiba_post"] || [[data objectForKey:@"type"] isEqualToString:@"blog_post"])
    {
        if (STRING_NOT_EMPTY([data objectForKey:@"title"]))
        {
            NSString *title = [NSString stringWithFormat:@"【%@】",[[[data objectForKey:@"title"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""]];
            NSDictionary * dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,nil];
            CGSize timeSize = [title boundingRectWithSize:CGSizeMake(kBgWidth-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            
            NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
            if (STRING_NOT_EMPTY(content))
            {
                float contentHeight;
                if(STRING_NOT_EMPTY([data objectForKey:@"post_first_image"])) {
                    contentHeight = 56;
                    timeSize.height = 30;
                } else {
                    contentHeight = [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5];
                }
                if (contentHeight > 56)
                {
                    contentHeight = 56;
                }
                weiboHeight += 10+contentHeight;
            } else {
                if(STRING_NOT_EMPTY([data objectForKey:@"post_first_image"])) {
                    weiboHeight +=90;
                }
            }
            weiboHeight += 20+timeSize.height+12;
        }
        else
        {
            weiboHeight += 20+19+12;
        }
    }
    //转发帖子/知识转发过来的分享微博
    else if ([[data objectForKey:@"type"] isEqualToString:@"weiba_repost"] || [[data objectForKey:@"type"] isEqualToString:@"blog_repost"])
    {
        NSString *content;
        if(STRING_NOT_EMPTY([data objectForKey:@"content"])) {
             content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        } else {
            content = @"";
        }
        NSInteger contentHeight = [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5];
        weiboHeight += contentHeight;
        
        if ([[[data objectForKey:@"source_info"] objectForKey:@"is_del"] intValue] == 1)
        {
            weiboHeight += 19+12;
        }
        else
        {
            NSString *title = [NSString stringWithFormat:@"【%@】",[[[[data objectForKey:@"source_info"] objectForKey:@"title"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""]];
            NSDictionary * dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,nil];
            CGSize timeSize = [title boundingRectWithSize:CGSizeMake(kBgWidth-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            
            NSString *content = [[[[data objectForKey:@"source_info"] objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
            if (STRING_NOT_EMPTY(content))
            {
                float contentHeight;
                if(STRING_NOT_EMPTY([[data objectForKey:@"source_info"] objectForKey:@"post_first_image"])) {
                    contentHeight = 56;
                    timeSize.height = 30;
                } else {
                    contentHeight = [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5];
                }
                if (contentHeight > 56)
                {
                    contentHeight = 56;
                }
                weiboHeight += 10+contentHeight;
            } else {
                if(STRING_NOT_EMPTY([[data objectForKey:@"source_info"] objectForKey:@"post_first_image"])) {
                    weiboHeight += 90;
                }
            }
            weiboHeight += timeSize.height+12;
        }
    }
    
    NSArray *plazaArray = [NSArray array];
    if ([[data objectForKey:@"type"] isEqualToString:@"repost"]){
        plazaArray = [[data objectForKey:@"source_info"] objectForKey:@"feed_category"];
    } else {
        plazaArray = [data objectForKey:@"feed_category"];
    }
    if (ARRAY_NOT_EMPTY(plazaArray)) {
        weiboHeight += 25;
        NSInteger arrayCount = 5;
        NSInteger plazaWidth = 25;
        if(plazaArray.count < 5) {
            arrayCount = plazaArray.count;
        }
        for (int i=0; i<arrayCount; i++) {
            NSString *title = [[plazaArray objectAtIndex:i] objectForKey:@"title"];
            NSInteger w = [title boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width;
            if(plazaWidth+w+5 > kBgWidth-4) {
                weiboHeight += 25;
                plazaWidth = 25;
            }
            plazaWidth = plazaWidth+w+5;
            
            if(i<arrayCount-1) {
                if(plazaWidth+5 > kBgWidth-4) {
                    weiboHeight += 25;
                    plazaWidth = 25;
                }
                plazaWidth += 5;
            }
        }
    }
    
    return weiboHeight+60+60;
}
- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    _indexPath = indexPath;
    _dataDitionary = data;
    
    if(![data isKindOfClass:[NSDictionary class]]) {
        return;
    }
    [_userFaceImageView sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"user_info"] objectForKey:@"avatar"] objectForKey:@"avatar_middle"]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    [_nameLabel setTitle:[[data objectForKey:@"user_info"] objectForKey:@"uname"] forState:UIControlStateNormal];
    _timeLabel.text = [UserModel formateTime:[data objectForKey:@"publish_time"]];
    _comeLabel.text = [data objectForKey:@"from"];
    [_pinglunButton setImage:[UIImage imageNamed:@"WeiBo_pinglun"] forState:UIControlStateNormal];
    _pinglunLabel.text = [data objectForKey:@"comment_count"];
    [_zanButton setImage:[UIImage imageNamed:[[data objectForKey:@"is_digg"] intValue]?@"WeiBo_yizan":@"WeiBo_zan"] forState:UIControlStateNormal];
    _zanLabel.text = [data objectForKey:@"digg_count"];
    _shareLabel.text = @"";
    [_shareButton setImage:[UIImage imageNamed:@"icon_weibo_share"] forState:UIControlStateNormal];
    [_forwadButton setImage:[UIImage imageNamed:@"Weibo_zhuanfa"] forState:UIControlStateNormal];
    
    NSDictionary * dic1= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName,nil];
    CGSize timeSize1;
    if(STRING_NOT_EMPTY(_nameLabel.titleLabel.text)){
        timeSize1 = [_nameLabel.titleLabel.text boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    }
	 
    _nameLabel.frame = CGRectMake(60, 10, timeSize1.width, 19);
    
    //等级小图标
	NSArray *userArr = [[data objectForKey:@"user_info"] objectForKey:@"user_group"];
	for (UIView *view in _mainBgView.subviews)
    {
		if(view.tag >= 111 && [view isKindOfClass:[UIImageView class]])
        {
			[view removeFromSuperview];
		}
	}
	if ([userArr isKindOfClass:[NSArray class]] && [userArr count])
    {
		for (int i = 0; i < [userArr count]; i ++)
        {
			UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(60+timeSize1.width+10+20*i, 15, 15, 15)];
			[userView setImageWithURL:[NSURL URLWithString:[[userArr objectAtIndex:i] objectForKey:@"user_group_icon_url"]]];
			userView.tag = 111+i;
			[_mainBgView addSubview:userView];
		}
	}
    
    //时间,来自位置
	NSDictionary * dic2 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12],NSFontAttributeName,nil];
	CGSize timeSize = [_timeLabel.text boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic2 context:nil].size;
	_timeLabel.frame = CGRectMake(60, 35, timeSize.width, 15);
	_timeLabel.textAlignment = NSTextAlignmentLeft;
	_comeLabel.frame = CGRectMake(CGRectGetMaxX(_timeLabel.frame)+5, 35, kBgWidth-(CGRectGetMaxX(_timeLabel.frame)+5)-12, 15);
    
    
    //-------------各种类型数据的显示
    //清除图片底view
    [_imageArrayView removeFromSuperview];
    //清除原图片
    for (UIImageView *view in _imageArrayView.subviews)
    {
		if(view.tag > 100 && view.tag < 110 && [view isKindOfClass:[UIImageView class]])
        {
			[view removeFromSuperview];
		}
	}
    //清除转发图片
    for (UIImageView *view in _forwardBgView.subviews)
    {
		if(view.tag > 100 && view.tag < 110 && [view isKindOfClass:[UIImageView class]])
        {
			[view removeFromSuperview];
		}
	}
    //清除视频图片
    for (UIButton *view in _mainBgView.subviews)
    {
		if(view.tag == 100 && [view isKindOfClass:[UIImageView class]])
        {
			[view removeFromSuperview];
		}
	}
    //清除转发视频图片
    for (UIButton *view in _forwardBgView.subviews)
    {
		if(view.tag == 100 && [view isKindOfClass:[UIImageView class]])
        {
			[view removeFromSuperview];
		}
	}
    //清除原微博
    [_weiboView removeFromSuperview];
    //清除转发背景下的分享title
    for (UILabel *view in _forwardBgView.subviews)
    {
        if (view.tag == 99 && [view isKindOfClass:[UILabel class]])
        {
            [view removeFromSuperview];
        }
    }
    //清除标签背景
    for(id view in _categoryView.subviews) {
        [view removeFromSuperview];
    }
    [_categoryView removeFromSuperview];
    //清除转发帖子的图片
    [_postImageView removeFromSuperview];
    //清除转发背景,_forwardView放置在转发背景上一起remove
    [_forwardBgView removeFromSuperview];
    
    
    //普通微博
    if ([[data objectForKey:@"type"] isEqualToString:@"post"])
    {
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        _weiboView.text = content;
        _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5]);
        if (_weiboView.frame.size.height > _weibotextviewHeight) {
            _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, _weibotextviewHeight);
        }
//        NSLog(@"%@",NSStringFromCGRect(_weiboView.frame));
        [_mainBgView addSubview:_weiboView];
        
        [self updateSomeThing:CGRectGetMaxY(_weiboView.frame)];
    }
    //图片微博
    else if ([[data objectForKey:@"type"] isEqualToString:@"postimage"])
    {
        _imageArray = [data objectForKey:@"attach_info"];
        
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        _weiboView.text = content;
        
        if ([LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5] > 85.0) {
            _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, _weibotextviewHeight);
        }else{
            _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5]);
        }
        
        [_mainBgView addSubview:_weiboView];
        
        [_mainBgView addSubview:_imageArrayView];
        
        //宽高(UI_SCREEN_WIDTH-24-24-4)/3.0
        NSInteger number = [[data objectForKey:@"attach_info"] count];
        if (number == 1)
        {
            NSInteger imageHeight = [[[[data objectForKey:@"attach_info"] firstObject] objectForKey:@"height"] integerValue];
            NSInteger imageWidth = [[[[data objectForKey:@"attach_info"] firstObject] objectForKey:@"width"] integerValue];
            if(imageWidth == 0) {
                imageWidth = 1;
            }
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kBgWidth, imageHeight*(kBgWidth-4)/imageWidth)];
//            [imageView sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"attach_small"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
            [imageView sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"attach_small"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
//            imageView.contentMode = UIViewContentModeScaleAspectFit;
//            imageView.clipsToBounds = YES;
            imageView.tag = 101;
            imageView.userInteractionEnabled = YES;
            [_imageArrayView addSubview:imageView];
            
            UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageButtonClicked:)];
            [imageView addGestureRecognizer:imageTgr];
            
            _imageArrayView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame)+10, kBgWidth, imageHeight*(kBgWidth-4)/imageWidth + 2);
            
            [self updateSomeThing:CGRectGetMaxY(_weiboView.frame)+10+imageHeight*(kBgWidth-4)/imageWidth];
        }else if (number == 4 || number == 2)
        {
            int k = 0;
            for (int i=0; i<(number-1)/2+1; i++)
            {
                for (int j=0; j<2; j++)
                {
                    if (k < number)
                    {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((kBgWidth-2)/2.0+2)*j, ((kBgWidth-2)/2.0+2)*i, (kBgWidth-2)/2.0, (kBgWidth-2)/2.0)];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"attach_info"] objectAtIndex:k] objectForKey:@"attach_small"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
//                        UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(((kBgWidth-4-2)/2.0+2)*j, ((kBgWidth-4-2)/2.0+2)*i, (kBgWidth-4-2)/2.0, (kBgWidth-4-2)/2.0)];
//                        [imageView sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"attach_info"] objectAtIndex:k] objectForKey:@"attach_small"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];

                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.clipsToBounds = YES;
                        imageView.tag = 101+k;
//                        imageView.tag = k;
                        imageView.userInteractionEnabled = YES;
                        [_imageArrayView addSubview:imageView];
                        
                        UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageButtonClicked:)];
                        [imageView addGestureRecognizer:imageTgr];
                    }
                    k++;
                }
            }
            _imageArrayView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame)+10, kBgWidth-4, (kBgWidth-2)/2.0*((number-1)/2+1)+2*((number-1)/2));
            [self updateSomeThing:CGRectGetMaxY(_weiboView.frame)+10+(kBgWidth-2)/2.0*((number-1)/2+1)+2*((number-1)/2)];
        }
        else
        {
            int k = 0;
            for (int i=0; i<(number-1)/3+1; i++)
            {
                for (int j=0; j<3; j++)
                {
                    if (k < number)
                    {
                        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((kBgWidth-4)/3.0+2)*j, ((kBgWidth-4)/3.0+2)*i, (kBgWidth-4)/3.0, (kBgWidth-4)/3.0)];
                        [imageView sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"attach_info"] objectAtIndex:k] objectForKey:@"attach_small"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
//                        UIButton *imageView = [[UIButton alloc] initWithFrame:CGRectMake(((kBgWidth-4-4)/3.0+2)*j, ((kBgWidth-4-4)/3.0+2)*i, (kBgWidth-4-4)/3.0, (kBgWidth-4-4)/3.0)];
//                        [imageView sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"attach_info"] objectAtIndex:k] objectForKey:@"attach_small"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
                        imageView.contentMode = UIViewContentModeScaleAspectFill;
                        imageView.clipsToBounds = YES;
                        imageView.tag = 101+k;
//                        imageView.tag = k;
                        imageView.userInteractionEnabled = YES;
                        [_imageArrayView addSubview:imageView];
                        
                        UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageButtonClicked:)];
                        [imageView addGestureRecognizer:imageTgr];
                    }
                    k++;
                }
            }
            _imageArrayView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame)+10, kBgWidth, (kBgWidth-4)/3.0*((number-1)/3+1)+2*((number-1)/3));
            [self updateSomeThing:CGRectGetMaxY(_weiboView.frame)+10+(kBgWidth-4)/3.0*((number-1)/3+1)+2*((number-1)/3)];
        }
    }
    //视频微博
    else if ([[data objectForKey:@"type"] isEqualToString:@"postvideo"])
    {
//        NSString *content = [[[[[data objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"title"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        _weiboView.text = content;
        _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5]);
        
        if ([LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5] > 85.0) {
            _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, _weibotextviewHeight);
        }else{
            _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5]);
        }
        
        [_mainBgView addSubview:_weiboView];
        
        UIImageView *button = [[UIImageView alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(_weiboView.frame)+10, kBgWidth-4, (kBgWidth-4)*3/4)];
        [button sd_setImageWithURL:[NSURL URLWithString:[[[data objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"flashimg"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
        
        button.contentMode = UIViewContentModeScaleAspectFill;
        button.clipsToBounds = YES;
        button.userInteractionEnabled = YES;
        button.tag = 100;
        [_mainBgView addSubview:button];
        
        UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width/2-35, button.frame.size.height/2-35, 70, 70)];
        playImageView.image = [UIImage imageNamed:@"WeiBo_play"];
        [button addSubview:playImageView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoButtonClicked)];
        [button addGestureRecognizer:tap];
        
        [self updateSomeThing:CGRectGetMaxY(_weiboView.frame)+10+(kBgWidth-4)*3/4];
    }
    //转发微博
	else if ([[data objectForKey:@"type"] isEqualToString:@"repost"])
    {
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        _weiboView.text = content;
        _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5]);
        [_mainBgView addSubview:_weiboView];
        
        if ([[[data objectForKey:@"source_info"] objectForKey:@"is_del"] intValue] == 1)
        {
            _forwardView.text = @"内容已经被删除";
            _forwardView.textColor = [UIColor redColor];
            _forwardBgView.userInteractionEnabled = NO;
            [_mainBgView addSubview:_forwardBgView];
            _forwardView.frame = CGRectMake(10, 12, kBgWidth-20, 19);
            _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, 19+12);
        }
        else
        {
            //转发内容为普通微博
            if ([[[data objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"post"])
            {
                NSString *content = [[data objectForKey:@"source_info"] objectForKey:@"content"];
                content = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
                _forwardView.text = content;
                _forwardView.textColor = [UIColor lightGrayColor];
                _forwardBgView.userInteractionEnabled = YES;
                [_mainBgView addSubview:_forwardBgView];
                _forwardView.frame = CGRectMake(10, 12, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]);
                _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+12);
            }
            //转发内容为图片微博
            else if ([[[data objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"postimage"])
            {
                _imageArray = [[data objectForKey:@"source_info"] objectForKey:@"attach_info"];
                
                NSString *content = [[data objectForKey:@"source_info"] objectForKey:@"content"];
                content = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
                _forwardView.text = content;
                _forwardView.textColor = [UIColor lightGrayColor];
                _forwardBgView.userInteractionEnabled = YES;
                [_mainBgView addSubview:_forwardBgView];
                _forwardView.frame = CGRectMake(10, 12, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]);
                
                [_mainBgView addSubview:_imageArrayView];
                
                //宽高((UI_SCREEN_WIDTH-24)-24-4)/3.0
                NSInteger number = [[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] count];
                if (number == 1)
                {
                    NSInteger imageHeight = [[[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] firstObject] objectForKey:@"height"] integerValue];
                    NSInteger imageWidth = [[[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] firstObject] objectForKey:@"width"] integerValue];
                    if(imageWidth == 0) {
                        imageWidth = 1;
                    }
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, (kBgWidth-4), imageHeight*(kBgWidth-4)/imageWidth)];
                    [imageView sd_setImageWithURL:[NSURL URLWithString:[[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"attach_origin"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
//                    imageView.contentMode = UIViewContentModeScaleAspectFit;
//                    imageView.clipsToBounds = YES;
                    imageView.tag = 101;
                    imageView.userInteractionEnabled = YES;
                    [_imageArrayView addSubview:imageView];
                    
                    UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageButtonClicked:)];
                    [imageView addGestureRecognizer:imageTgr];
                    
                    _imageArrayView.frame = CGRectMake(2, CGRectGetMaxY(_weiboView.frame)+[LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+12, kBgWidth-4, imageHeight*(kBgWidth-4)/imageWidth);
                    
                    _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+imageHeight*(kBgWidth-4)/imageWidth+12);
                } else if (number == 4 || number == 2)
                {
                    int k = 0;
                    for (int i=0; i<(number-1)/2+1; i++)
                    {
                        for (int j=0; j<2; j++)
                        {
                            if (k < number)
                            {
                                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((kBgWidth-4-2)/2.0+2)*j, ((kBgWidth-4-2)/2.0+2)*i, (kBgWidth-4-2)/2.0, (kBgWidth-4-2)/2.0)];
                                [imageView sd_setImageWithURL:[NSURL URLWithString:[[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:k] objectForKey:@"attach_small"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
                                imageView.contentMode = UIViewContentModeScaleAspectFill;
                                imageView.clipsToBounds = YES;
                                imageView.tag = 101+k;
                                imageView.userInteractionEnabled = YES;
                                [_imageArrayView addSubview:imageView];
                                
                                UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageButtonClicked:)];
                                [imageView addGestureRecognizer:imageTgr];
                            }
                            k++;
                        }
                    }
                    _imageArrayView.frame = CGRectMake(2, CGRectGetMaxY(_weiboView.frame)+[LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+12, kBgWidth-4, (kBgWidth-4-2)/2.0*((number-1)/2+1)+2*((number-1)/2));
                    _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+(kBgWidth-4-2)/2.0*((number-1)/2+1)+2*((number-1)/2)+12);
                }
                else
                {
                    int k = 0;
                    for (int i=0; i<(number-1)/3+1; i++)
                    {
                        for (int j=0; j<3; j++)
                        {
                            if (k < number)
                            {
                                UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(((kBgWidth-4-4)/3.0+2)*j, ((kBgWidth-4-4)/3.0+2)*i, (kBgWidth-4-4)/3.0, (kBgWidth-4-4)/3.0)];
                                [imageView sd_setImageWithURL:[NSURL URLWithString:[[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:k] objectForKey:@"attach_small"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
                                imageView.contentMode = UIViewContentModeScaleAspectFill;
                                imageView.clipsToBounds = YES;
                                imageView.tag = 101+k;
                                imageView.userInteractionEnabled = YES;
                                [_imageArrayView addSubview:imageView];
                                
                                UITapGestureRecognizer *imageTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(imageButtonClicked:)];
                                [imageView addGestureRecognizer:imageTgr];
                            }
                            k++;
                        }
                    }
                    _imageArrayView.frame = CGRectMake(2, CGRectGetMaxY(_weiboView.frame)+[LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+12, kBgWidth-4, (kBgWidth-4-4)/3.0*((number-1)/3+1)+2*((number-1)/3));
                    _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+(kBgWidth-4-4)/3.0*((number-1)/3+1)+2*((number-1)/3)+12);
                }
            }
            //转发内容为视频微博
            else if ([[[data objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"postvideo"])
            {
                NSString *content = [[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"title"];
                content = [[content componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
                _forwardView.text = content;
                _forwardView.textColor = [UIColor lightGrayColor];
                _forwardBgView.userInteractionEnabled = YES;
                [_mainBgView addSubview:_forwardBgView];
                _forwardView.frame = CGRectMake(10, 12, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]);
                
                UIImageView *button = [[UIImageView alloc] initWithFrame:CGRectMake(2, CGRectGetMaxY(_forwardView.frame)+10, kBgWidth-4, 3*(kBgWidth-4)/4)];
                [button sd_setImageWithURL:[NSURL URLWithString:[[[[data objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"flashimg"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
                button.contentMode = UIViewContentModeScaleAspectFill;
                button.clipsToBounds = YES;
                button.userInteractionEnabled = YES;
                button.tag = 100;
                [_forwardBgView addSubview:button];
                
                UIImageView *playImageView = [[UIImageView alloc] initWithFrame:CGRectMake(button.frame.size.width/2-35, button.frame.size.height/2-35, 70, 70)];
                playImageView.image = [UIImage imageNamed:@"WeiBo_play"];
                [button addSubview:playImageView];
                
                UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoButtonClicked)];
                [button addGestureRecognizer:tap];
                
                _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5]+10+3*(kBgWidth-4)/4+12);
            }
        }
        
        [self updateSomeThing:CGRectGetMaxY(_forwardBgView.frame)];
    }
    //帖子/知识转发过来的分享微博
    else if ([[data objectForKey:@"type"] isEqualToString:@"weiba_post"] || [[data objectForKey:@"type"] isEqualToString:@"blog_post"] )
    {
        NSString *title = @"";
        if (STRING_NOT_EMPTY([data objectForKey:@"post_type"])) {
            if ([[data objectForKey:@"post_type"] isEqualToString:@"1"]){
                title = @"分享长文";
            }
        }
        else if ([[data objectForKey:@"type"] isEqualToString:@"weiba_post"] )
        {
            title = @"分享长文";
        }
        else
        {
            title = @"分享知识";
        }

        
        _weiboView.text = title;
        _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, 20);
        [_mainBgView addSubview:_weiboView];
        
        if (STRING_NOT_EMPTY([data objectForKey:@"title"]))
        {
            UILabel *tieziLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            tieziLabel.textColor = TITLE_COLOR;
            tieziLabel.font = [UIFont systemFontOfSize:16];
            tieziLabel.shadowOffset = CGSizeMake(0, -3);
            tieziLabel.numberOfLines = 0;
            tieziLabel.tag = 99;
            tieziLabel.text = [NSString stringWithFormat:@"【%@】",[[[data objectForKey:@"title"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""]];
            NSDictionary * dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,nil];
            CGSize timeSize = [tieziLabel.text boundingRectWithSize:CGSizeMake(kBgWidth-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            tieziLabel.frame = CGRectMake(10, 12, kBgWidth-20, timeSize.height);
            [_forwardBgView addSubview:tieziLabel];
            
            NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
            if (STRING_NOT_EMPTY(content))
            {
                float contentHeight = [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5];
                if (contentHeight > 56)
                {
                    contentHeight = 56;
                }
                _forwardView.text = content;
                _forwardView.textColor = [UIColor lightGrayColor];
                _forwardBgView.userInteractionEnabled = YES;
                [_mainBgView addSubview:_forwardBgView];
                _forwardView.frame = CGRectMake(10, CGRectGetMaxY(tieziLabel.frame)+10, kBgWidth-20, contentHeight);
                _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, timeSize.height+contentHeight+12+10);
            }
            else
            {
                _forwardBgView.userInteractionEnabled = YES;
                [_mainBgView addSubview:_forwardBgView];
                _forwardView.frame = CGRectMake(10, CGRectGetMaxY(tieziLabel.frame), kBgWidth-20, 0);
                _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, timeSize.height+0+12);
                _forwardView.text = @"";
            }
            if(STRING_NOT_EMPTY([data objectForKey:@"post_first_image"])) {
                _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 12, 96, 96)];
                [_postImageView sd_setImageWithURL:[NSURL URLWithString:[data objectForKey:@"post_first_image"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
                _postImageView.contentMode = UIViewContentModeScaleAspectFill;
                _postImageView.clipsToBounds = YES;
                [_forwardBgView addSubview:_postImageView];
                 tieziLabel.frame = CGRectMake(102, 12, kBgWidth-4-112, 40);
                _forwardView.frame = CGRectMake(102, CGRectGetMaxY(tieziLabel.frame), kBgWidth-4-112, 56);
                _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, 20+90);
            }
        }
        else
        {
            _forwardView.text = @"内容已经被删除";
            _forwardView.textColor = [UIColor redColor];
            _forwardBgView.userInteractionEnabled = NO;
            [_mainBgView addSubview:_forwardBgView];
            _forwardView.frame = CGRectMake(10, 12, kBgWidth-20, 19);
            _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, 19+12);
        }
        
        [self updateSomeThing:CGRectGetMaxY(_forwardBgView.frame)];
    }
    //转发帖子/知识转发过来的分享微博
    else if ([[data objectForKey:@"type"] isEqualToString:@"weiba_repost"] || [[data objectForKey:@"type"] isEqualToString:@"blog_repost"])
    {
        NSString *content = [[[data objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
        _weiboView.text = content;
        _weiboView.frame = CGRectMake(10, 60, kBgWidth-20, [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:16] lineSpacing:1.5]);
        [_mainBgView addSubview:_weiboView];
        
        if ([[[data objectForKey:@"source_info"] objectForKey:@"is_del"] intValue] == 1)
        {
            _forwardView.text = @"内容已经被删除";
            _forwardView.textColor = [UIColor redColor];
            _forwardBgView.userInteractionEnabled = NO;
            [_mainBgView addSubview:_forwardBgView];
            _forwardView.frame = CGRectMake(10, 12, kBgWidth-20, 19);
            _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, 19+12);
        }
        else
        {
            UILabel *tieziLabel = [[UILabel alloc] initWithFrame:CGRectZero];
            tieziLabel.textColor = TITLE_COLOR;
            tieziLabel.font = [UIFont systemFontOfSize:16];
            tieziLabel.shadowOffset = CGSizeMake(0, -3);
            tieziLabel.numberOfLines = 0;
            tieziLabel.tag = 99;
            tieziLabel.text = [NSString stringWithFormat:@"【%@】",[[[[data objectForKey:@"source_info"] objectForKey:@"title"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""]];
            NSDictionary * dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:16.0],NSFontAttributeName,nil];
            CGSize timeSize = [tieziLabel.text boundingRectWithSize:CGSizeMake(kBgWidth-20, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
            tieziLabel.frame = CGRectMake(10, 12, kBgWidth-20, timeSize.height);
            [_forwardBgView addSubview:tieziLabel];
            
            NSString *content = [[[[data objectForKey:@"source_info"] objectForKey:@"content"] componentsSeparatedByCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<(^>*)>\\*|\t|\r|\n"]]componentsJoinedByString:@""];
            if (STRING_NOT_EMPTY(content))
            {
                float contentHeight = [LPRichTextView getRechTextViewHeightWithText:content viewWidth:kBgWidth-20 font:[UIFont systemFontOfSize:15] lineSpacing:1.5];
                if (contentHeight > 56)
                {
                    contentHeight = 56;
                }
                
                _forwardView.text = content;
                _forwardView.textColor = [UIColor lightGrayColor];
                _forwardBgView.userInteractionEnabled = YES;
                [_mainBgView addSubview:_forwardBgView];
                _forwardView.frame = CGRectMake(10, CGRectGetMaxY(tieziLabel.frame)+10, kBgWidth-20, contentHeight);
                _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, timeSize.height+contentHeight+12+10);
            }
            else
            {
                _forwardBgView.userInteractionEnabled = YES;
                [_mainBgView addSubview:_forwardBgView];
                _forwardView.frame = CGRectMake(10, CGRectGetMaxY(tieziLabel.frame), kBgWidth-20, 0);
                _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, timeSize.height+0+12);
                _forwardView.text = @"";
            }
            if(STRING_NOT_EMPTY([[data objectForKey:@"source_info"] objectForKey:@"post_first_image"])) {
                _postImageView = [[UIImageView alloc] initWithFrame:CGRectMake(2, 12, 96, 96)];
                [_postImageView sd_setImageWithURL:[NSURL URLWithString:[[data objectForKey:@"source_info"] objectForKey:@"post_first_image"]] placeholderImage:[UIImage imageNamed:@"morentupian"] options:SDWebImageProgressiveDownload];
                _postImageView.contentMode = UIViewContentModeScaleAspectFill;
                _postImageView.clipsToBounds = YES;
                [_forwardBgView addSubview:_postImageView];
                tieziLabel.frame = CGRectMake(102, 12, kBgWidth-4-112, 40);
                _forwardView.frame = CGRectMake(102, CGRectGetMaxY(tieziLabel.frame), kBgWidth-4-112, 56);
                _forwardBgView.frame = CGRectMake(0, CGRectGetMaxY(_weiboView.frame), kBgWidth, 20+90);
            }
        }
        
        [self updateSomeThing:CGRectGetMaxY(_forwardBgView.frame)];
    }
}

- (void)imageButtonClicked:(UITapGestureRecognizer *)tap
{
    NSInteger count = _imageArray.count;
	// 1.封装图片数据
	NSMutableArray *photos = [NSMutableArray arrayWithCapacity:count];
	for (int i = 0; i<count; i++)
    {
		// 替换为中等尺寸图片
		NSString *url = [[_imageArray objectAtIndex:i] objectForKey:@"attach_origin"];
		MJPhoto *photo = [[MJPhoto alloc] init];
		photo.url = [NSURL URLWithString:url]; // 图片路径
		photo.srcImageView = _imageArrayView.subviews[i]; // 来源于哪个UIImageView
		[photos addObject:photo];
        
	}
	
	// 2.显示相册
	MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
	browser.currentPhotoIndex = tap.view.tag-101; // 弹出相册时显示的第一张图片是？
	browser.photos = photos; // 设置所有的图片
	[browser show];


}



- (void)videoButtonClicked
{
    if (_delegate && [_delegate respondsToSelector:@selector(weiboTableViewCell:videoButtonClickedWithIndexPath:)])
    {
        [_delegate weiboTableViewCell:self videoButtonClickedWithIndexPath:_indexPath];
    }
}
- (void)updateSomeThing:(float)y
{
    NSArray *categoryArray = [NSArray array];
    if ([[_dataDitionary objectForKey:@"type"] isEqualToString:@"repost"]){
        categoryArray = [[_dataDitionary objectForKey:@"source_info"] objectForKey:@"feed_category"];
    } else {
        categoryArray = [_dataDitionary objectForKey:@"feed_category"];
    }
    
    if (ARRAY_NOT_EMPTY(categoryArray)) {
        [_mainBgView addSubview:_categoryView];
        NSInteger categoryWidth = 25;
        NSInteger categoryHeight = 5;
        NSInteger arrayCount = 5;
        if (categoryArray.count < 5) {
            arrayCount = categoryArray.count;
        }
        UIImageView *categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 5, 20, 20)];
        categoryImageView.image = [UIImage imageNamed:@"Weibo_biaoqian"];
        [_categoryView addSubview:categoryImageView];
        
        for(int i=0; i<arrayCount; i++) {
            NSString *title = [[categoryArray objectAtIndex:i] objectForKey:@"title"];
            NSInteger w = [title boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size.width;
            if(categoryWidth+w+5 > kBgWidth-4) {
                categoryHeight += 25;
                categoryWidth = 25;
            }
            UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
            btn.frame = CGRectMake(categoryWidth, categoryHeight, w+5, 20);
            [btn setTitle:title forState:UIControlStateNormal];
            [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
            btn.titleLabel.font = [UIFont systemFontOfSize:16];
            [btn addTarget:self action:@selector(categoryBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
            btn.tag = i+1;
            [_categoryView addSubview:btn];
            
            categoryWidth = categoryWidth + w+5;
            
            if(i<arrayCount-1) {
                if(categoryWidth+5 > kBgWidth-4) {
                    categoryHeight += 25;
                    categoryWidth = 25;
                }
                UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(categoryWidth, categoryHeight, 5, 20)];
                label.text = @",";
                label.textAlignment = NSTextAlignmentCenter;
                label.textColor = [UIColor lightGrayColor];
                [_categoryView addSubview:label];
                
                categoryWidth += 5;
            }
        }
        _categoryView.frame = CGRectMake(2, y+5, kBgWidth-4, categoryHeight+25);
        _btnBgView.frame = CGRectMake(0, CGRectGetMaxY(_categoryView.frame), kBgWidth, 40);
        _mainBgView.frame = CGRectMake(UI_CELL_BG_WIDTH, UI_CELL_BG_WIDTH/2, kBgWidth, CGRectGetMaxY(_categoryView.frame)+40);
    } else {
        _btnBgView.frame = CGRectMake(0, y+10, kBgWidth, 40);
        _mainBgView.frame = CGRectMake(UI_CELL_BG_WIDTH, UI_CELL_BG_WIDTH/2, kBgWidth, y+50);
    }
    
}

#pragma mark - LPRichTextViewDelegate
- (void)richTextView:(LPRichTextView *)view touchEndRun:(LPRichTextBaseRun *)run
{
    switch (run.type)
    {
        case LPRichTextURLRunType:
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:showUrl:)])
            {
                NSString *httpString = run.originalText;
                if (![run.originalText hasPrefix:@"http"])
                {
                    httpString = [NSString stringWithFormat:@"http://%@",run.originalText];
                }
                [_delegate weiboTableViewCell:self showUrl:httpString];
            }
            break;
        case LPRichTextATRunType:
        {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:showUserProfileByName:)])
            {
                [_delegate weiboTableViewCell:self showUserProfileByName:[run.originalText substringFromIndex:1]];
            }
            break;
        }
        case LPRichTextTopicRunType:
        {
            if ([_delegate respondsToSelector:@selector(weiboTableViewCell:showTopicByName:)])
            {
                [_delegate weiboTableViewCell:self showTopicByName:[run.originalText substringWithRange:NSMakeRange(1, run.originalText.length-2)]];
            }
            break;
        }
        case LPRichTextEmojiRunType:
            break;
        default:
            break;
    }
}
-(void)touchClick:(LPRichTextView *)view
{
    if ([_delegate respondsToSelector:@selector(weiboTableViewCell:tableViewCellClickAtIndex:)])
    {
        [_delegate weiboTableViewCell:self tableViewCellClickAtIndex:_indexPath.row];
    }
}
- (void)categoryBtnClicked:(UIButton *)btn
{
    NSArray *categoryArray = [NSArray array];
    if ([[_dataDitionary objectForKey:@"type"] isEqualToString:@"repost"]){
        categoryArray = [[_dataDitionary objectForKey:@"source_info"] objectForKey:@"feed_category"];
    } else {
        categoryArray = [_dataDitionary objectForKey:@"feed_category"];
    }
    if([_delegate respondsToSelector:@selector(weiboTableViewCell:gotocategoryDetail:)]) {
        [_delegate weiboTableViewCell:self gotocategoryDetail:[categoryArray objectAtIndex:btn.tag-1]];
    }
}
@end
