//
//  PostCommentViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/11/24.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"
#import "UIPlaceHolderTextView.h"
#import "ExpressionView.h"
#import "AtFriendViewController.h"
#import "TopicViewController.h"
#import "InsertLocationViewController.h"
#import <CoreLocation/CoreLocation.h>
#import "LPActionSheetView.h"

typedef NS_ENUM(NSInteger, PostType)
{
    PostTypeComment = 0, //评论微博
    PostTypeForward,     //转发微博
    PostTypeForwardCircle, //转发帖子
    PostTypeForwardKnowledge  //转发知识
};

@interface PostCommentViewController : BaseViewController<UITextViewDelegate,ExpressionViewDelegate,UIScrollViewDelegate,AtFriendViewControllerDelegate,TopicViewControllerDelegate,CLLocationManagerDelegate,insertLocationDelegate,LPActionSheetViewDelegate>

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFeedID:(NSString *)feedID andPlaceHolderContent:(NSString *)placeHolderContent andPostType:(PostType)postType andPostShowTitle:(NSString *)titleString andPostShowImage:(NSString *)imageStringUrl andPostShowcontent:(NSString *)contentString;

@end
