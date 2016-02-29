//
//  CommentView.h
//  ThinkSNS
//
//  Created by ZhouWeiMing on 14/9/1.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMessageTextView.h"
//#import "ExpressionView.h"

#define kInputTextViewMinHeight 36
#define kInputTextViewMaxHeight 200
#define kHorizontalPadding 8
#define kVerticalPadding 5

@protocol CommentDelegate <NSObject>

-(void)sendTextForComment:(NSString *)commStr;

@end


@interface CommentView : UIView<UITextViewDelegate,UIScrollViewDelegate>{
	CGFloat _previousTextViewContentHeight;//上一次inputTextView的contentSize.height
	BOOL isKeyBoard;
	UIButton *smileBtn;
    
	UIScrollView *faceScrollview;
	UIView *faceBgView;
	UIPageControl *pageControl;
	
	UIView *BackView;

}

@property (strong, nonatomic) XHMessageTextView *inputTextView;
@property(strong,nonatomic)UIView *bgView;

@property(nonatomic,assign)id<CommentDelegate>delegate;

/**
 *  文字输入区域最大高度，必须 > KInputTextViewMinHeight(最小高度)并且 < KInputTextViewMaxHeight，否则设置无效
 */
@property (nonatomic) CGFloat maxTextInputViewHeight;


@end
