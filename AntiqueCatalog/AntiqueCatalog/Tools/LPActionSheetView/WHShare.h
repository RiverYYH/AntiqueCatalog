//
//  WHShare.h
//  藏民网
//
//  Created by Hong on 15/8/27.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol WHShareDelegate <NSObject>

- (void)WHShareSucceed;
- (void)WHShareFailedWithError:(NSString *)error;

@end

@interface WHShare : NSObject

@property (nonatomic, assign) id<WHShareDelegate> delegate;
/**
 *  分享到站外
 *
 *  @param title         标题
 *  @param content       内容
 *  @param shareImageUrl 分享的图片
 *  @param urlstring     分享的网址
 *  @param index         被点击的位置判断分享到哪里
 */
- (void)whShareWithTitle:(NSString *)title content:(NSString *)content shareImageUrl:(id)shareImageUrl urlString:(NSString *)urlString index:(NSInteger)index;
@end
