//
//  TopicDetailViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/12/29.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "WeiBoTableViewCell.h"
#import "LPActivityView.h"
#import "LPActionSheetView.h"

@interface TopicDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,WeiBoTableViewCellDelegate,LPActivityViewDelegate,LPActionSheetViewDelegate,WHShareDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithTopicName:(NSString *)topicName;
@property (nonatomic, assign) BOOL isNewTopic;//判断是否是新创建专辑进入详情页面，如果是新创建的专辑，那么屏蔽掉通知
@end
