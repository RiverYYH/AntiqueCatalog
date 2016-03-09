//
//  DHHshowLoading.h
//  到处是宝
//
//  Created by Cangmin on 15/10/30.
//  Copyright © 2015年 huihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DHHshowLoading : UIView

+ (void)showLoadingForView:(UIView *)view;
+ (void)showLoadingForView:(UIView *)view allowUserInteraction:(BOOL)allowUserInteraction;

+ (void)showGrayLoadingForView:(UIView *)view;
+ (void)showGrayLoadingForView:(UIView *)view allowUserInteraction:(BOOL)allowUserInteraction;

+ (BOOL)hideLoadingForView:(UIView *)view;

@end
