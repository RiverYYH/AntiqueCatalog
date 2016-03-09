//
//  LPActivityView.h
//  LPActivityDemo
//
//  Created by 刘鹏 on 14/12/26.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LPActivityView;

@protocol LPActivityViewDelegate <NSObject>

@optional
//上方分享按钮从前到后从0依次递增,下方功能按钮从前到后从101依次递增
- (void)activity:(LPActivityView *)activityView clickedOnButtonIndex:(NSInteger)index;
//取消按钮被点击调用
- (void)activityClickedOnCancelButton:(LPActivityView *)activityView;

@end

@interface LPActivityView : UIView
{
    UIView *_backGroundView;
}
@property (nonatomic,assign) id<LPActivityViewDelegate>delegate;

/**
 *初始化方法
 *参数1 -- activity在哪里展示,一般为self(原实现方法使用了[[UIApplication sharedApplication].delegate.window.rootViewController.view addSubview:self];参数没有实际意义)
 *参数2 -- activity最上方title
 *参数3 -- activity是否添加代理,用于回调,一般为self
 *参数4 -- activity取消按钮title
 *参数5 -- activity上方按钮图片name
 *参数6 -- activity下方按钮图片name
 *参数7 -- activity的tag
 */
+ (void)showInView:(UIView *)view delegate:(id<LPActivityViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle shareButtonImagesNameArray:(NSArray *)shareButtonImagesNameArray downButtonImagesNameArray:(NSArray *)downButtonImagesNameArray tagNumber:(NSInteger)tagNumber;

@end