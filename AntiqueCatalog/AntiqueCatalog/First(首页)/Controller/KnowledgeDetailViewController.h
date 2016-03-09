//
//  KnowledgeDtailViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/12/26.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableViewCell.h"
#import "MJRefresh.h"
#import "CommentView.h"
#import "LPActivityView.h"

@interface KnowledgeDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,CommentDelegate,LPActivityViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView *_webView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andID:(NSString *)ID;

@end