//
//  SDWebViw.m
//  到处是宝
//
//  Created by Cangmin on 15/10/22.
//  Copyright © 2015年 huihao. All rights reserved.
//

#import "SDWebViw.h"

@interface SDWebViw()<UIWebViewDelegate>
{
    UILabel *_titleLabel;
    UIButton *_leftButton;
    UIImageView *_titleImageView;
    UIImageView *_lineView;
}

@end

@implementation SDWebViw

- (id)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if(self){
        _urlString = urlString;
        [self CreatUI];
    }
    return self;

}

-(void)CreatUI
{
    self.backgroundColor = [UIColor whiteColor];
    
    _titleImageView = [[UIImageView alloc] init];
    _titleImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    _titleImageView.backgroundColor = BASE_NAVIGATION_BACKGROUNDCOLOR;
    _titleImageView.userInteractionEnabled = YES;
    [self addSubview:_titleImageView];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, [UIScreen mainScreen].bounds.size.width-100, 44)];
    _titleLabel.textColor = BASE_NAVIGATION_TITLECOLOR;
    _titleLabel.font = BASE_NAVIGATION_TITLEFONT;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    [_titleImageView addSubview:_titleLabel];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    _leftButton.titleLabel.font = BASE_NAVIGATION_BUTTONFONT;
    _leftButton.adjustsImageWhenHighlighted = NO;
    [_leftButton setTitleColor:BASE_NAVIGATION_BUTTONCOLOR forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"base_fanhui"] forState:UIControlStateNormal];
    [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImageView addSubview:_leftButton];
    
    
    _lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    _lineView.backgroundColor = LINE_COLOR;
    [_titleImageView addSubview:_lineView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        _titleImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        _titleLabel.frame = CGRectMake(50, 20, [UIScreen mainScreen].bounds.size.width-100, 44);
        _leftButton.frame = CGRectMake(0, 20, 44, 44);
        _lineView.frame = CGRectMake(0, 63.5, [UIScreen mainScreen].bounds.size.width, 0.5);
    }
    
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]]];
    webView.delegate = self;
    [self addSubview:webView];
    
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    _titleLabel.text = @"正在加载";
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{

    _titleLabel.text=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    _titleLabel.text =
    @"正在加载···";
    NSLog(@"%@",error);
}


- (void)leftButtonClick:(id)sender
{
    [UIView animateWithDuration:1 animations:^{
        self.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 0);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    

    
}

@end
