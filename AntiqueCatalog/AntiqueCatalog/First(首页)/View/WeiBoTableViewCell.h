//
//  WeiBoTableViewCell.h
//  Collector
//
//  Created by zhishi on 14/11/20.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPRichTextView.h"

@class WeiBoTableViewCell;
@protocol WeiBoTableViewCellDelegate <NSObject>

@optional

/**
 *  转发按钮
 *
 */

- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell forwadButtonClickedWithIndexPath:(NSIndexPath *)indexPath;
/**
 *  分享按钮
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell shareButtonClickedWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  评论按钮
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell pinglunButtonClickedWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  赞按钮
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell zanButtonClickedWithIndexPath:(NSIndexPath *)indexPath;

/**
 *  播放
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell videoButtonClickedWithIndexPath:(NSIndexPath *)indexPath;

/**
 *   正文话题跳转
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell showUserProfileByName:(NSString *)name;

/**
 *   正文url跳转
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell showUrl:(NSString *)url;

/**
 *   正文name跳转
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell showTopicByName:(NSString *)name;


/**
 *  进入当前微博详情
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell tableViewCellClickAtIndex:(NSInteger)index;
/**
 *  进去标签详情
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotocategoryDetail:(NSDictionary *)dic;

/**
 *  进入原微博详情
 *
 */
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotoForwardDetail:(NSDictionary *)dic;

- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotoWeibaDetail:(NSDictionary *)dic;

- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotoBlogDetail:(NSDictionary *)dic;

- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotoLongWeiboDetail:(NSDictionary *)dic;

@end

@interface WeiBoTableViewCell : UITableViewCell<LPRichTextViewDelegate>
{
    UIView *_mainBgView;
    
    UIImageView *_userFaceImageView;
    UIButton *_nameLabel;
    UILabel *_timeLabel;
    UILabel *_comeLabel;
    
    UIView *_btnBgView;
    UIButton *_pinglunButton;
    UIButton *_zanButton;
    UILabel *_pinglunLabel;
    UILabel *_zanLabel;
    UIButton *_shareButton;
    UILabel *_shareLabel;
    UIButton *_forwadButton;
    UILabel *_forwadLabel;
    
    LPRichTextView *_weiboView;
    LPRichTextView *_forwardView;
    UIView *_forwardBgView;
    UIView *_imageArrayView;
    UIImageView *_postImageView;
    
    UIView *_categoryView;
    
    NSIndexPath *_indexPath;
    NSDictionary *_dataDitionary;
    NSArray *_imageArray;
    
}

@property (assign,nonatomic)id<WeiBoTableViewCellDelegate> delegate;

+ (CGFloat)heightForCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;
- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;

@end
