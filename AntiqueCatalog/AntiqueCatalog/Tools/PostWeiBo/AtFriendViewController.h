//
//  AtFriendViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/11/25.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"

@protocol AtFriendViewControllerDelegate <NSObject>

-(void)returnAtName:(NSString *)name;

@end

@interface AtFriendViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UISearchBarDelegate>

@property(nonatomic,assign)id<AtFriendViewControllerDelegate>delegate;

@end
