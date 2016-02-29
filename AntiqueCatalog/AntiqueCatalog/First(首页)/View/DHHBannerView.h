//
//  DHHBannerView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DHHBannerView;



@protocol DHHBannerViewDelegate <NSObject>

@optional

- (void)bannerView:(DHHBannerView *)bannerView didClickedImageIndex:(NSInteger)index;

@end



@interface DHHBannerView : UIView

#pragma mark - Class methods

/**
 *  init a LCBannerView object from local
 *
 *  @param frame                         frame
 *  @param delegate                      delegate
 *  @param imageName                     image name. eg: `banner_01@2x.png`, `banner_02@2x.png`... you should set it `banner`
 *  @param count                         images count
 *  @param timeInterval                  time interval
 *  @param currentPageIndicatorTintColor current page indicator tint color
 *  @param pageIndicatorTintColor        other page indicator tint color
 *
 *  @return a LCBannerView object
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame
                           delegate:(id<DHHBannerViewDelegate>)delegate
                          imageName:(NSString *)imageName
                              count:(NSInteger)count
                      timerInterval:(NSInteger)timeInterval
      currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
             pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;

/**
 *  init a LCBannerView object from internet
 *
 *  @param frame                         frame
 *  @param delegate                      delegate
 *  @param imageURLs                     image's URLs
 *  @param placeholderImage              placeholder image
 *  @param timeInterval                  time interval
 *  @param currentPageIndicatorTintColor current page indicator tint color
 *  @param pageIndicatorTintColor        other page indicator tint color
 *
 *  @return a LCBannerView object
 */
+ (instancetype)bannerViewWithFrame:(CGRect)frame
                           delegate:(id<DHHBannerViewDelegate>)delegate
                          imageURLs:(NSArray *)imageURLs
                   placeholderImage:(NSString *)placeholderImage
                      timerInterval:(NSInteger)timeInterval
      currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
             pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;



#pragma mark - Instance methods

/**
 *  init a LCBannerView object from local
 *
 *  @param frame                         frame
 *  @param delegate                      delegate
 *  @param imageName                     image name. eg: `banner_01@2x.png`, `banner_02@2x.png`... you should set it `banner`
 *  @param count                         images count
 *  @param timeInterval                  time interval
 *  @param currentPageIndicatorTintColor current page indicator tint color
 *  @param pageIndicatorTintColor        other page indicator tint color
 *
 *  @return a LCBannerView object
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<DHHBannerViewDelegate>)delegate
                    imageName:(NSString *)imageName
                        count:(NSInteger)count
                timerInterval:(NSInteger)timeInterval
currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
       pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;

/**
 *  init a LCBannerView object from internet
 *
 *  @param frame                         frame
 *  @param delegate                      delegate
 *  @param imageURLs                     image's URLs
 *  @param placeholderImage              placeholder image
 *  @param timeInterval                  time interval
 *  @param currentPageIndicatorTintColor current page indicator tint color
 *  @param pageIndicatorTintColor        other page indicator tint color
 *
 *  @return a LCBannerView object
 */
- (instancetype)initWithFrame:(CGRect)frame
                     delegate:(id<DHHBannerViewDelegate>)delegate
                    imageURLs:(NSArray *)imageURLs
             placeholderImage:(NSString *)placeholderImage
                timerInterval:(NSInteger)timeInterval
currentPageIndicatorTintColor:(UIColor *)currentPageIndicatorTintColor
       pageIndicatorTintColor:(UIColor *)pageIndicatorTintColor;

@end
