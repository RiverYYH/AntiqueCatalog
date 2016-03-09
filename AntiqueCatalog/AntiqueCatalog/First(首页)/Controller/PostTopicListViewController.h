//
//  PostTopicListViewController.h
//  藏民网
//
//  Created by Hong on 15/4/7.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MJRefresh.h"

@protocol PostTopicListViewControllerDelegate <NSObject>

- (void)PostTopicListViewWithTopicName:(NSString *)name;

@end

@interface PostTopicListViewController : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, assign) id <PostTopicListViewControllerDelegate> delegate;

@property (nonatomic, assign) NSInteger type;

@end
