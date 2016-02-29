//
//  ScreenscrollView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/23.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ScreenscrollView.h"

@implementation ScreenscrollView

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.frame = frame;
        
    }
    return self;
}


- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]]) {
        UIPanGestureRecognizer *pan = (UIPanGestureRecognizer *)gestureRecognizer;
        CGPoint panPoint = [pan locationInView:self];
        if ([pan translationInView:self].x > 0.0f  && panPoint.x > 0 && panPoint.x < (UI_SCREEN_WIDTH - 40)/4) {
            return NO;
        }
//        else if ([pan translationInView:self].x > 0.0f && panPoint.x > UI_SCREEN_WIDTH-40 && panPoint.x < UI_SCREEN_WIDTH-40 + ((UI_SCREEN_WIDTH - 40)/3)) {
//            
//            return NO;
//        }
//        NSLog(@"%f",panPoint.x);
    }
    //    BOOL qq = [super gestureRecognizerShouldBegin:gestureRecognizer];
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

@end
