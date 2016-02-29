//
//  firstScrollView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/6.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "firstScrollView.h"

@interface firstScrollView()<UIGestureRecognizerDelegate>



@end

@implementation firstScrollView

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
        if ([pan translationInView:self].x > 0.0f && self.contentOffset.x == 0 && panPoint.x > 0 && panPoint.x < 50) {
            return NO;
        }else if ([pan translationInView:self].x > 0.0f && self.contentOffset.x == UI_SCREEN_WIDTH && panPoint.x > UI_SCREEN_WIDTH && panPoint.x < UI_SCREEN_WIDTH+30) {

            return NO;
        }
    }
//    BOOL qq = [super gestureRecognizerShouldBegin:gestureRecognizer];
    return [super gestureRecognizerShouldBegin:gestureRecognizer];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
