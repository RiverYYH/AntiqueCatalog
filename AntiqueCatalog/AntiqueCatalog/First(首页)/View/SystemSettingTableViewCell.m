//
//  SystemSettingTableViewCell.m
//  Collector
//
//  Created by 刘鹏 on 14/11/13.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "SystemSettingTableViewCell.h"
#import "APService.h" //极光推送JPush

@implementation SystemSettingTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        // Initialization code
        
        //选中无状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 200-12, 50)];
        _titleLabel.font = [UIFont systemFontOfSize:16];
        _titleLabel.textColor = TITLE_COLOR;
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(200, 0, UI_SCREEN_WIDTH-200-12, 50)];
        _contentLabel.font = [UIFont systemFontOfSize:15];
        _contentLabel.textColor = CONTENT_COLOR;
        _contentLabel.textAlignment = NSTextAlignmentRight;
        
        _jiantouImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-23 , 18.5, 8, 13)];
        _jiantouImageView.image = [UIImage imageNamed:@"jiantou"];
        
        _switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-60, 10, 50, 30)];
        _switchButton.onTintColor = ICON_COLOR;
        [_switchButton addTarget:self action:@selector(switchButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    [_contentLabel removeFromSuperview];
    [_jiantouImageView removeFromSuperview];
    [_switchButton removeFromSuperview];
    
    if ([[data objectForKey:@"type"] isEqualToString:@"jiantou"])
    {
        [self.contentView addSubview:_jiantouImageView];
    }
    else if ([[data objectForKey:@"type"] isEqualToString:@"switch"])
    {
        [self.contentView addSubview:_switchButton];
    }
    else if ([[data objectForKey:@"type"] isEqualToString:@"label"])
    {
        [self.contentView addSubview:_contentLabel];
    }
    
    _titleLabel.text = [data objectForKey:@"title"];
    _contentLabel.text = [data objectForKey:@"content"];
    _switchButton.on = [[NSUserDefaults standardUserDefaults] boolForKey:@"ReceiveNewMessageAlert"];
}

- (void)switchButtonClicked
{
    if (_switchButton.on == YES)
    {
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"ReceiveNewMessageAlert"];
        //JPush相关
        // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0)
        {
            //可以添加自定义categories
            [APService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                           UIUserNotificationTypeSound |
                                                           UIUserNotificationTypeAlert)
                                               categories:nil];
        }
        else
        {
            //categories 必须为nil
            [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                           UIRemoteNotificationTypeSound |
                                                           UIRemoteNotificationTypeAlert)
                                               categories:nil];
        }
#else
        //categories 必须为nil
        [APService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                       UIRemoteNotificationTypeSound |
                                                       UIRemoteNotificationTypeAlert)
                                           categories:nil];
#endif

    }
    else
    {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"ReceiveNewMessageAlert"];
//        [[UIApplication sharedApplication] cancelAllLocalNotifications];//取消所有的通知
        [[UIApplication sharedApplication] unregisterForRemoteNotifications];
    }
}

@end
