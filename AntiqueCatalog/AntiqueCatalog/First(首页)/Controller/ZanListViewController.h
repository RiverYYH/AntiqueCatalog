//
//  ZanListViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/12/25.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "UserTableViewCell.h"
#import "LPActionSheetView.h"
#import "MJRefresh.h"

typedef NS_ENUM(NSInteger, ZanType)
{
    ZanTypeNormal = 0,
    ZanTypeCircle,
    ZanTypeKnowledge
};

@interface ZanListViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UserTableViewCellDelegate,LPActionSheetViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFeedID:(NSString *)feedID andType:(ZanType)zanType;

@end
