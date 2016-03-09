/************************************************************
  *  * EaseMob CONFIDENTIAL 
  * __________________ 
  * Copyright (C) 2013-2014 EaseMob Technologies. All rights reserved. 
  *  
  * NOTICE: All information contained herein is, and remains 
  * the property of EaseMob Technologies.
  * Dissemination of this information or reproduction of this material 
  * is strictly forbidden unless prior written permission is obtained
  * from EaseMob Technologies.
  */

#import <UIKit/UIKit.h>

@interface UIViewController (HUD)

//显示提示信息,1s后隐藏
- (void)showHudInView:(UIView *)view showHint:(NSString *)hint;

//显示提示信息,需要调用方法手动隐藏
- (void)showHudInView:(UIView *)view hint:(NSString *)hint;

//隐藏提示信息
- (void)hideHud;

// 从默认(showHint:)显示的位置再往上(下)yOffset
- (void)showHint:(NSString *)hint yOffset:(float)yOffset;

@end
