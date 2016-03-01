//
//  ImageBrowser.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/27.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ImageBrowser.h"

static CGRect oldframe;
static int didDoubleClick; //累计双击放大的次数
static BOOL currViewDidZoom; //判断当前页面是否已经双击放大
@implementation ImageBrowser


+(void)showImage:(UIImageView *)avatarImageView{
    didDoubleClick = 0;
    UIImage *image=avatarImageView.image;
    UIWindow *window=[UIApplication sharedApplication].keyWindow;
    UIScrollView *backgroundView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    backgroundView.contentSize = CGSizeMake(backgroundView.bounds.size.width , backgroundView.bounds.size.height);
    oldframe=[avatarImageView convertRect:avatarImageView.bounds toView:window];
    backgroundView.backgroundColor=[UIColor blackColor];
    backgroundView.alpha=0;
    backgroundView.bounces = NO;
    UIImageView *imageView=[[UIImageView alloc]initWithFrame:oldframe];
    imageView.image=image;
    imageView.tag=1;
    [backgroundView addSubview:imageView];
    [window addSubview:backgroundView];
    
    UITapGestureRecognizer * singleTapGestureRecognizer=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage:)];
    [backgroundView addGestureRecognizer: singleTapGestureRecognizer];
    
    UITapGestureRecognizer *doubleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(doubleTap:)];
    [doubleTapGestureRecognizer setNumberOfTapsRequired:2];
    [backgroundView addGestureRecognizer:doubleTapGestureRecognizer];
    
    //这行很关键，意思是只有当没有检测到doubleTapGestureRecognizer 或者 检测doubleTapGestureRecognizer失败，singleTapGestureRecognizer才有效
    [singleTapGestureRecognizer requireGestureRecognizerToFail:doubleTapGestureRecognizer];
    
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2,[UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
        backgroundView.alpha=1;
    } completion:^(BOOL finished) {
        
    }];
}

+(void)hideImage:(UITapGestureRecognizer*)tap{
    if(currViewDidZoom){
        UIScrollView * imageScrollView = (UIScrollView*)tap.view;
        [self CurrViewToNormalRectWithScrollView:imageScrollView];
    }else{
        UIView *backgroundView=tap.view;
        UIImageView *imageView=(UIImageView*)[tap.view viewWithTag:1];
        [UIView animateWithDuration:0.3 animations:^{
            imageView.frame=oldframe;
            backgroundView.alpha=0;
        } completion:^(BOOL finished) {
            [backgroundView removeFromSuperview];
        }];
    }
    
}

//当前放大页面恢复到正常大小
+(void)CurrViewToNormalRectWithScrollView:(UIScrollView*)imageScrollView{
    
    CGRect rect = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
    imageScrollView.frame = rect;
    imageScrollView.contentSize = CGSizeMake(imageScrollView.bounds.size.width , imageScrollView.bounds.size.height);
    
    currViewDidZoom = NO;
    didDoubleClick = 0;
    UIImageView * imageView = [imageScrollView viewWithTag:1];
    UIImage * image = imageView.image;
    [UIView animateWithDuration:0.1 animations:^{
        imageView.frame=CGRectMake(0,([UIScreen mainScreen].bounds.size.height-image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width)/2,[UIScreen mainScreen].bounds.size.width, image.size.height*[UIScreen mainScreen].bounds.size.width/image.size.width);
    }];
}

//点击2次 每次在原先的尺寸上放大1.5
+(void)doubleTap:(UITapGestureRecognizer*)tap{
    didDoubleClick = didDoubleClick + 1;
    if(didDoubleClick > 2){
        return;
    }
    UIScrollView * imageScroll = (UIScrollView*)tap.view;
    
    float scrollContentWidth = imageScroll.contentSize.width*1.5;
    float imageViewWidth = scrollContentWidth;
    float imageViewHeight = imageViewWidth / 0.79;
    float scrollContentHeight = imageViewHeight;
    
    imageScroll.contentSize = CGSizeMake(scrollContentWidth, scrollContentHeight);
    float scrollX = (scrollContentWidth - [UIScreen mainScreen].bounds.size.width) / 2;
    float scrollY = (scrollContentHeight - [UIScreen mainScreen].bounds.size.height) / 2;
    
    UIImageView * imgv = [imageScroll viewWithTag:1];
    CGRect rect = imgv.frame;
    rect.size.width = imageViewWidth;
    rect.size.height = imageViewHeight;
    rect.origin.x = 0;
    rect.origin.y = 0;
    
    [imageScroll setContentOffset:CGPointMake(scrollX, scrollY) animated:NO];
    imgv.frame = rect;
    
    NSLog(@"scrollX=%.2f",scrollX);
    NSLog(@"scrollY=%.2f",scrollY);
    NSLog(@"scrollViewWidth=%.2f",scrollContentWidth);
    NSLog(@"scrollViewHeight=%.2f",scrollContentHeight);
    
    NSLog(@"imageView=%@",imgv);
    currViewDidZoom = YES;
}
@end
