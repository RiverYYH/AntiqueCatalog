//
//  SDOptionsView.h
//  SDPhotoBrowser
//
//  Created by Cangmin on 15/10/20.
//  Copyright © 2015年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SDOptionsView;
typedef void (^SDOptionsViewblack)(NSInteger clickIndex);
@interface SDOptionsView : UIView
- (void)block:(SDOptionsViewblack)block;

@end
