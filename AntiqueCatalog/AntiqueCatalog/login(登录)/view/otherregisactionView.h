//
//  otherregisactionView.h
//  到处是宝
//
//  Created by Cangmin on 15/10/9.
//  Copyright © 2015年 huihao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class otherregisactionView;
typedef void (^otherregisactionViewblack)(NSInteger clickIndex);

@interface otherregisactionView : UIView
- (void)block:(otherregisactionViewblack)block;
@end
