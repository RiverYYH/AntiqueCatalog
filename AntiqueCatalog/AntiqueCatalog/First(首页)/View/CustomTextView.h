//
//  CustomTextView.h
//  AntiqueCatalog
//
//  Created by cssweb on 16/3/10.
//  Copyright © 2016年 Cangmin. All rights reserved.
//
#define SCREEN_FRAME ([UIScreen mainScreen].bounds)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import <UIKit/UIKit.h>

@protocol CustomTextViewDelegate <NSObject>

-(void)getNumberTextView:(NSString*)textViewStr withViewRect:(CGRect)viewFrame;

@end

@interface CustomTextView : UIView

@property (nonatomic, strong) UITextView * textView;
@property (nonatomic, assign) id<CustomTextViewDelegate>delegate;

@end
