//
//  BrowserViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/20.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()
{
    NSString *_urlString;
}
@end

@implementation BrowserViewController

- (id)initWithUrlString:(NSString *)urlString
{
    self = [super init];
    if (self) {
        // Custom initialization
        
        _urlString = urlString;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [UIView animateWithDuration:0.3 animations:^{
//        [CustomTabBarViewController sharedInstance].imageView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 49);
//    } completion:^(BOOL finished){
//        [CustomTabBarViewController sharedInstance].imageView.hidden = YES;
//    }];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME];
    [webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[_urlString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]]]];
    webView.delegate = self;
    [self.view addSubview:webView];
}

- (void)leftButtonClick:(id)sender
{

    [self dismissViewControllerAnimated:YES completion:^{}];
    
}

#pragma mark UIWebViewDelegate
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    self.titleLabel.text = @"正在加载";
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if (_type == 1) {
        self.titleLabel.text = @"扫宝贝";
    } else {
        self.titleLabel.text=[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    }
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
	self.titleLabel.text =
    @"链接错误";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
