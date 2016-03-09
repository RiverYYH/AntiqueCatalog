//
//  LPActionSheetView.h
//  LPActionSheet
//
//  Created by 刘鹏 on 14-10-16.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPActionSheetView;

@protocol LPActionSheetViewDelegate <NSObject>
@optional
//除删除及取消按钮以外的其他按钮被点击调用,按钮从上到下buttonIndex从0开始递增
- (void)actionSheet:(LPActionSheetView *)actionSheetView clickedOnButtonIndex:(NSInteger)buttonIndex;
//删除按钮被点击调用
- (void)actionSheetClickedOnDestructiveButton:(LPActionSheetView *)actionSheetView;
//取消按钮被点击调用
- (void)actionSheetClickedOnCancelButton:(LPActionSheetView *)actionSheetView;

@end

@interface LPActionSheetView : UIView

@property (nonatomic,assign) id<LPActionSheetViewDelegate>delegate;
@property (nonatomic,strong) UIView *backGroundView;
@property (nonatomic,strong) NSString *actionTitle;
@property (nonatomic,assign) NSInteger postionIndexNumber;
@property (nonatomic,assign) BOOL isHadTitle;
@property (nonatomic,assign) BOOL isHadDestructionButton;
@property (nonatomic,assign) BOOL isHadOtherButton;
@property (nonatomic,assign) BOOL isHadCancelButton;
@property (nonatomic,assign) CGFloat LPActionSheetHeight;

/**
 *初始化方法
 *参数1 -- ActionSheet在哪里展示,一般为self(原实现方法使用了[[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];参数没有实际意义)
 *参数2 -- ActionSheet最上方title
 *参数3 -- ActionSheet是否添加代理,用于回调,一般为self
 *参数4 -- ActionSheet取消按钮title
 *参数5 -- ActionSheet删除按钮title
 *参数6 -- ActionSheet其他按钮title
 */
+ (void)showInView:(UIView *)customView title:(NSString *)title delegate:(id<LPActionSheetViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle destructiveButtonTitle:(NSString *)destructiveButtonTitle otherButtonTitles:(NSArray *)otherButtonTitlesArray tagNumber:(NSInteger)tagNumber;

@end