//
//  SDWebImageManager+HH.m
//  到处是宝
//
//  Created by Cangmin on 15/10/21.
//  Copyright © 2015年 huihao. All rights reserved.
//

#import "SDWebImageManager+HH.h"

@implementation SDWebImageManager (HH)
+ (void)downloadWithURL:(NSURL *)url
{
   [[self sharedManager] downloadImageWithURL:url options:SDWebImageLowPriority|SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
       
   } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
       
   }];
}
@end
