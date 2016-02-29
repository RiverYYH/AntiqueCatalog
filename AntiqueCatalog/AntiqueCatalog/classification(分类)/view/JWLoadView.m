//
//  JWLoadView.h
//
//  Created by JW on 12/17/15.
//  Copyright © 2015 JW. All rights reserved.
//

#import "JWLoadView.h"

@implementation JWLoadView

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    }
    return self;
}

-(void)showMessage:(NSString *)message{
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    [window addSubview:self];
    
    self.frame = window.bounds;
    
    _loadingView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 172, 60)];
    _loadingView.image = [UIImage imageNamed:@"load_backgroud"];
    _loadingView.center = self.center;
    
    UIImageView * iconView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 0, 40, 40)];
    iconView.image = [UIImage imageNamed:@"load_loading"];
    
    CGFloat y = _loadingView.frame.size.height/2;
    iconView.center = CGPointMake(10+20, y);
    
    CABasicAnimation * animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.cumulative = YES;
    animation.duration = 0.5;
    animation.repeatCount = 1000;
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeRotation(3.14, 0, 0, 1.0)];
    [iconView.layer addAnimation:animation forKey:@"animation"];
    
    UILabel * label = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 40)];
    label.text = message;
    label.textColor = [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0];
    label.font = [UIFont systemFontOfSize:13];
    label.center = CGPointMake(65+50, y);
    
    [_loadingView addSubview:iconView];
    [_loadingView addSubview:label];
    [window addSubview:_loadingView];
}


- (void)dismiss{
    [self.loadingView removeFromSuperview];
    self.loadingView = nil;
    [self removeFromSuperview];
    
}

+(JWLoadView *)sharedJWLoadView{
    static JWLoadView *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[JWLoadView alloc] init];
    });
    return _sharedClient;
    
}

@end
