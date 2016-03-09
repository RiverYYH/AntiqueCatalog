//
//  BrowserViewController.h
//  Collector
//
//  Created by 刘鹏 on 14/11/20.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "BaseViewController.h"

@interface BrowserViewController : BaseViewController<UIWebViewDelegate>

- (id)initWithUrlString:(NSString *)urlString;

@property (nonatomic, assign) NSInteger type;//1为扫宝贝的界面

@end
