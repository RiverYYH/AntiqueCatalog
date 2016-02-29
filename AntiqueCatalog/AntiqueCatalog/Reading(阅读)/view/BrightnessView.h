//
//  BrightnessView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/2/24.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol BrightnessViewDelegate <NSObject>

@optional
-(void)BrightnessViewhan:(float)value;
-(void)NightMode:(BOOL)isnight;

@end

@interface BrightnessView : UIView

@property (nonatomic,assign)id<BrightnessViewDelegate>delegate;

@end
