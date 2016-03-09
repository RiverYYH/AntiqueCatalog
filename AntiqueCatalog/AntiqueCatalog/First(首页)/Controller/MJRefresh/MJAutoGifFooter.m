//
//  MJAutoGifFooter.m
//  到处是宝
//
//  Created by Cangmin on 15/10/24.
//  Copyright © 2015年 huihao. All rights reserved.
//

#import "MJAutoGifFooter.h"

@implementation MJAutoGifFooter

#pragma mark - 重写方法
#pragma mark 基本设置
- (void)prepare
{
    [super prepare];
    
    // 设置正在刷新状态的动画图片
    NSMutableArray *refreshingImages = [NSMutableArray array];
    for (NSUInteger i = 1; i<=3; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"dropdown_loading_0%zd", i]];
        [refreshingImages addObject:image];
    }
    [self setImages:refreshingImages forState:MJRefreshStateRefreshing];
}

@end
