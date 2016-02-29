//
//  cimmenView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/24.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "cimmenView.h"

#define kVerticalPadding 5

@interface cimmenView ()<UITextViewDelegate>



@end

@implementation cimmenView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self CreatUI];
    }
    return self;
}

- (void)CreatUI{
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    self.backgroundColor = White_Color;
    
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 1)];
    imageView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    [self addSubview:imageView];
    
    _textView = [[UITextView  alloc] initWithFrame:CGRectMake(10, kVerticalPadding, UI_SCREEN_WIDTH-56, 36)];
    _textView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    _textView.scrollEnabled = YES;
//    _textView.returnKeyType = UIReturnKeySend;
//    _textView.enablesReturnKeyAutomatically = YES; // UITextView内部判断send按钮是否可以用
    _textView.delegate = self;
    _textView.backgroundColor = Clear_Color;
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 4.0f;
    _textView.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
    _textView.layer.borderWidth = 1.0;
    
    _label = [[UILabel alloc]init];
    _label.text = @"写评论";
    _label.textColor = Deputy_Colour;
    _label.frame = CGRectMake(0, 0, 100, 36);
    [_textView addSubview:_label];
    [self addSubview:_textView];
    
    _button = [UIButton buttonWithType:UIButtonTypeCustom];
    _button.frame = CGRectMake(UI_SCREEN_WIDTH - 46, 5, 36, 36);
    //		[smileBtn setImage:[UIImage imageNamed:@"biaoqing"] forState:0];
    [_button setTitle:@"发送" forState:UIControlStateNormal];
    [_button setTitleColor:Deputy_Colour forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(showSmile) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_button];
}

//将要开始编辑
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _label.hidden = YES;
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if (textView.text.length > 0) {
        _label.hidden = YES;
    }else{
        _label.hidden = NO;
    }
    return YES;
}

- (void)showSmile{
    [_textView resignFirstResponder];
    if (_textView.text.length>0) {
        if (_delegate && [_delegate respondsToSelector:@selector(TextForComment:)]) {
            [_delegate TextForComment:_textView.text];
        }
    }
    _textView.text = @"";
 
}

- (void)keyboardWillHide:(NSNotification *)notification
{
    self.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 46, UI_SCREEN_WIDTH, 46);
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    
    
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [endValue CGRectValue].size.height;
    [UIView animateWithDuration:0.3 animations:^{
        
        self.frame = CGRectMake(0, UI_SCREEN_HEIGHT - height - 46, UI_SCREEN_WIDTH, 46);
        
    }];
    
}


@end
