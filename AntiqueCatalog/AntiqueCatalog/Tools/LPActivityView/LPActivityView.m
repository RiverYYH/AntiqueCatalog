//
//  LPActivityView.m
//  LPActivityDemo
//
//  Created by 刘鹏 on 14/12/26.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "LPActivityView.h"

//WINDOW背景颜色及动画原背景颜色
#define WINDOW_COLOR                            [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define WINDOW_ANIMATE_COLOR                    [UIColor colorWithRed:0 green:0 blue:0 alpha:0]

//Activity背景颜色
#define ACTIVITY_BACKGROUNDCOLOR             [UIColor colorWithRed:255/255.00f green:255/255.00f blue:255/255.00f alpha:1]

//动画时间
#define ANIMATE_DURATION                        0.3f

@implementation LPActivityView

#pragma mark - Public method
+ (void)showInView:(UIView *)view delegate:(id<LPActivityViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle shareButtonImagesNameArray:(NSArray *)shareButtonImagesNameArray downButtonImagesNameArray:(NSArray *)downButtonImagesNameArray tagNumber:(NSInteger)tagNumber
{
    LPActivityView *lpActivityView = [[LPActivityView alloc] initWithDelegate:delegate cancelButtonTitle:cancelButtonTitle withShareButtonImagesName:shareButtonImagesNameArray withDownButtonImagesNameArray:downButtonImagesNameArray tagNumber:tagNumber];
    [view addSubview:lpActivityView];
}

#pragma mark - Praviate method
- (id)initWithDelegate:(id<LPActivityViewDelegate>)delegate cancelButtonTitle:(NSString *)cancelButtonTitle withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray withDownButtonImagesNameArray:(NSArray *)downButtonImagesNameArray tagNumber:(NSInteger)tagNumber
{
    self = [super init];
    if (self)
    {
        //初始化背景视图，添加手势
        self.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        self.backgroundColor = WINDOW_ANIMATE_COLOR;
        self.tag = tagNumber;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGesture)];
        [self addGestureRecognizer:tapGesture];
        
        if (delegate)
        {
            self.delegate = delegate;
        }
        
        [self creatButtonsWithCancelButtonTitle:cancelButtonTitle withShareButtonImagesName:shareButtonImagesNameArray withDownButtonImagesNameArray:downButtonImagesNameArray];
    }
    return self;
}

- (void)creatButtonsWithCancelButtonTitle:(NSString *)cancelButtonTitle withShareButtonImagesName:(NSArray *)shareButtonImagesNameArray withDownButtonImagesNameArray:(NSArray *)downButtonImagesNameArray
{
    //生成LPActivityView
    _backGroundView = [[UIView alloc] initWithFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 240)];
    _backGroundView.backgroundColor = ACTIVITY_BACKGROUNDCOLOR;
    [self addSubview:_backGroundView];
    
    UIScrollView *scrollView1 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 100)];
    scrollView1.showsVerticalScrollIndicator = NO;
    for (int i=0; i<[shareButtonImagesNameArray count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+80*i, 10, 60, 80);
        button.tag = i;
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage imageNamed:[shareButtonImagesNameArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView1 addSubview:button];
    }
    scrollView1.contentSize = CGSizeMake([shareButtonImagesNameArray count]*80+10, 100);
    [_backGroundView addSubview:scrollView1];
    
    UIScrollView *scrollView2 = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 100, [UIScreen mainScreen].bounds.size.width, 100)];
    scrollView2.showsVerticalScrollIndicator = NO;
    for (int i=0; i<[downButtonImagesNameArray count]; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10+80*i, 10, 60, 80);
        button.tag = 100+i;
        button.adjustsImageWhenHighlighted = NO;
        [button setImage:[UIImage imageNamed:[downButtonImagesNameArray objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
        [scrollView2 addSubview:button];
    }
    scrollView2.contentSize = CGSizeMake([downButtonImagesNameArray count]*80+10, 100);
    [_backGroundView addSubview:scrollView2];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(10, 99, [UIScreen mainScreen].bounds.size.width-20, 1)];
    lineView.backgroundColor = [UIColor colorWithRed:223/255.0 green:219/255.0 blue:210/255.0 alpha:1];
    [_backGroundView addSubview:lineView];
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, _backGroundView.frame.size.height-40, [UIScreen mainScreen].bounds.size.width, 40)];
    [cancelButton setBackgroundColor:[UIColor colorWithRed:202/255.0 green:202/255.0 blue:202/255.0 alpha:1]];
    [cancelButton setTitle:cancelButtonTitle forState:UIControlStateNormal];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:18];
    [cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(didClickOnImageIndex:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.tag = 99;
    [_backGroundView addSubview:cancelButton];
    
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [_backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height-240, [UIScreen mainScreen].bounds.size.width, 240)];
        self.backgroundColor = WINDOW_COLOR;
    } completion:^(BOOL finished) {
    }];
}

//按钮被点击
- (void)didClickOnImageIndex:(UIButton *)button
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(activity:clickedOnButtonIndex:)])
    {
        [self.delegate activity:self clickedOnButtonIndex:button.tag];
    }
    
    [self tappedCancel];
}

//点击屏幕取消
- (void)tapGesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(activityClickedOnCancelButton:)])
    {
        [self.delegate activityClickedOnCancelButton:self];
    }
    
//    [self tappedCancel];
}

//取消
- (void)tappedCancel
{
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [_backGroundView setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, 0)];
        self.backgroundColor = WINDOW_ANIMATE_COLOR;
    } completion:^(BOOL finished) {
        if (finished)
        {
            [self removeFromSuperview];
        }
    }];
}

@end
