//
//  CircleDetailViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/12/8.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "CommentTableViewCell.h"
#import "MJRefresh.h"
#import "CommentView.h"
#import "LPActivityView.h"
#import "LPActionSheetView.h"

#import <ShareSDK/ShareSDK.h>

@interface CircleDetailViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate,UIWebViewDelegate,CommentDelegate,LPActivityViewDelegate,LPActionSheetViewDelegate,UIGestureRecognizerDelegate>
{
    UIWebView *_webView;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andID:(NSString *)postID;

@end
