//
//  CommentView.m
//  ThinkSNS
//
//  Created by ZhouWeiMing on 14/9/1.
//  Copyright (c) 2014年 zhishi. All rights reserved.
//

#import "CommentView.h"

@implementation CommentView

-(void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
		
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
		
		self.backgroundColor = [UIColor clearColor];
		
		_bgView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 46)];
		self.bgView.backgroundColor = RGBA(246, 245, 243);
		self.bgView.layer.shadowOffset = CGSizeMake(0, 2);
		self.bgView.layer.shadowOpacity = 0.80;
//		self.bgView.layer.shadowColor = TITLE_COLOR.CGColor;
		[self addSubview:_bgView];
		
		self.maxTextInputViewHeight = kInputTextViewMaxHeight;
		
		smileBtn = [UIButton buttonWithType:UIButtonTypeCustom];
		smileBtn.frame = CGRectMake(UI_SCREEN_WIDTH - 46, 5, 36, 36);
//		[smileBtn setImage:[UIImage imageNamed:@"biaoqing"] forState:0];
        [smileBtn setTitle:@"发送" forState:UIControlStateNormal];
		[smileBtn addTarget:self action:@selector(showSmile) forControlEvents:UIControlEventTouchUpInside];
//		[_bgView addSubview:smileBtn];
		
		// 输入框的高度和宽度
		// 初始化输入框
		self.inputTextView = [[XHMessageTextView  alloc] initWithFrame:CGRectMake(10, kVerticalPadding, UI_SCREEN_WIDTH-56, kInputTextViewMinHeight)];
		self.inputTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
		_inputTextView.scrollEnabled = YES;
		_inputTextView.returnKeyType = UIReturnKeySend;
		_inputTextView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
		_inputTextView.placeHolder = @"请输入评论...";
		_inputTextView.delegate = self;
		_inputTextView.backgroundColor = [UIColor whiteColor];

		_inputTextView.layer.masksToBounds = YES;
		_inputTextView.layer.cornerRadius = 4.0f;
		_previousTextViewContentHeight = [self getTextViewContentH:_inputTextView];
		
		[self.bgView addSubview:_inputTextView];
		
		[_inputTextView becomeFirstResponder];
		
		BackView = [[UIView alloc]init];
		BackView.backgroundColor = RGBA(242, 242, 242);
		BackView.userInteractionEnabled = YES;
		[self addSubview:BackView];
		
		faceBgView = [[UIView alloc]init];
		faceBgView.backgroundColor = [UIColor clearColor];
		faceBgView.hidden = YES;
		faceBgView.userInteractionEnabled = YES;
		[BackView addSubview:faceBgView];
		
    }
    return self;
}

-(void)selectedFacialView:(NSString *)str{
		
	NSInteger location =  [_inputTextView selectedRange].location;
	NSMutableString *contentViewText = [NSMutableString stringWithString:_inputTextView.text];
	[contentViewText insertString:[NSString stringWithFormat:@"[%@]",str] atIndex:location];
	_inputTextView.text= contentViewText;
	NSArray *arr = [_inputTextView.text componentsSeparatedByString:@"//@"];
	NSString *str2 = [arr objectAtIndex:0];
	_inputTextView.selectedRange = NSMakeRange(str2.length, 0);
	
	NSString *chatText = self.inputTextView.text;
    if (chatText.length > 0) {
		[self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];;
    }
	
}

- (void)keyboardWillHide:(NSNotification *)notification{
	isKeyBoard = NO;
	[UIView animateWithDuration:0.3 animations:^{
		_bgView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-self.bgView.frame.size.height-186-30, UI_SCREEN_WIDTH, _previousTextViewContentHeight+10);
	}];
}

- (void)keyboardWillShow:(NSNotification *)notification{
	
	faceScrollview.hidden = YES;
	isKeyBoard = YES;
	[smileBtn setImage:[UIImage imageNamed:@"biaoqing"] forState:0];
	
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
	CGFloat height = [endValue CGRectValue].size.height;
	[UIView animateWithDuration:0.3 animations:^{
		_bgView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-height-self.bgView.frame.size.height, UI_SCREEN_WIDTH, self.bgView.frame.size.height);
	}];
}

-(void)showSmile{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(sendTextForComment:)]) {
        [self.delegate sendTextForComment:_inputTextView.text];
    }
//	[smileBtn setImage:[UIImage imageNamed:isKeyBoard?@"jianpan":@"biaoqing"] forState:0];
//	if (isKeyBoard) {
//		[_inputTextView resignFirstResponder];
//		if (!faceScrollview) {
//			faceScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 186+30)];
//		}else{
//			[faceScrollview removeFromSuperview];
//		}
//		faceBgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 186+30);
//		BackView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-186-30, UI_SCREEN_WIDTH, 186+30);
//		faceBgView.hidden = NO;
//		faceScrollview.hidden = NO;
//
//		for (int i=0; i<4; i++)
//		{
//			ExpressionView *fview=[[ExpressionView alloc] initWithFrame:CGRectMake(i*UI_SCREEN_WIDTH, 0, 315, 186)];
//			[fview loadFacialView:i size:CGSizeMake(46, 46)];
//			fview.delegate=self;
//			[faceScrollview addSubview:fview];
//		}
//		faceScrollview.showsHorizontalScrollIndicator = NO;
//		faceScrollview.delegate = self;
//		faceScrollview.contentSize=CGSizeMake(UI_SCREEN_WIDTH*4, 186);
//		faceScrollview.pagingEnabled=YES;
//		
//		faceBgView.backgroundColor = [UIColor clearColor];
//		
//		if (pageControl) {
//			[pageControl removeFromSuperview];
//		}else{
//			pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 186, UI_SCREEN_WIDTH, 30)];
//		}
//		pageControl.backgroundColor = [UIColor colorWithRed:241/255.0 green:241/255.0 blue:241/255.0 alpha:1];
//		pageControl.numberOfPages = 4;
//		pageControl.currentPage = 0;
//		if (iOSVersion>=6.0) {
//			pageControl.pageIndicatorTintColor = [UIColor whiteColor];
//			pageControl.currentPageIndicatorTintColor = TITLE_COLOR;
//		}
//		[faceBgView addSubview:pageControl];
//		[faceBgView addSubview:faceScrollview];
//	}else{
//		[_inputTextView becomeFirstResponder];
//		faceBgView.hidden = YES;
//	}
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
	NSInteger count = scrollView.contentOffset.x/UI_SCREEN_WIDTH;
	pageControl.currentPage = count;
}

- (void)setMaxTextInputViewHeight:(CGFloat)maxTextInputViewHeight
{
    if (maxTextInputViewHeight > kInputTextViewMaxHeight) {
        maxTextInputViewHeight = kInputTextViewMaxHeight;
    }
    _maxTextInputViewHeight = maxTextInputViewHeight;
}

- (void)willShowInputTextViewToHeight:(CGFloat)toHeight
{
    if (toHeight < kInputTextViewMinHeight) {
        toHeight = kInputTextViewMinHeight;
    }
    if (toHeight > self.maxTextInputViewHeight) {
        toHeight = self.maxTextInputViewHeight;
    }
    
    if (toHeight == _previousTextViewContentHeight)
    {
        return;
    }
    else{
        CGFloat changeHeight = toHeight - _previousTextViewContentHeight;
        
//        CGRect rect = self.frame;
//        rect.size.height += changeHeight;
//        rect.origin.y -= changeHeight;
//        self.frame = rect;
		
        CGRect rect;
        rect = self.bgView.frame;
        rect.size.height += changeHeight;
		rect.origin.y -= changeHeight;
        self.bgView.frame = rect;
        
        if (iOSVersion < 7.0) {
            [self.inputTextView setContentOffset:CGPointMake(0.0f, (self.inputTextView.contentSize.height - self.inputTextView.frame.size.height) / 2) animated:YES];
        }
        _previousTextViewContentHeight = toHeight;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
		[self willShowInputTextViewToHeight:[self getTextViewContentH:self.inputTextView]];
        if (_inputTextView.text.length > 300)
        {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"您输入的内容已经超过300限制" delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alertView show];
            return NO;
        }
		if (self.delegate && [self.delegate respondsToSelector:@selector(sendTextForComment:)]) {
			[self.delegate sendTextForComment:textView.text];
		}
		[UIView animateWithDuration:0.3 animations:^{
			[_inputTextView resignFirstResponder];
			self.frame =CGRectMake(0, UI_SCREEN_HEIGHT - 46, UI_SCREEN_WIDTH, 46);
		}];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    [self willShowInputTextViewToHeight:[self getTextViewContentH:textView]];
}


- (CGFloat)getTextViewContentH:(UITextView *)textView
{
	
    if (iOSVersion >= 7.0)
    {
        return ceilf([textView sizeThatFits:textView.frame.size].height);
    } else {
        return textView.contentSize.height;
    }
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[_inputTextView resignFirstResponder];

	[UIView animateWithDuration:0.5 animations:^{
		self.frame =CGRectMake(0, UI_SCREEN_HEIGHT - 46, UI_SCREEN_WIDTH, 46);
	}];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
