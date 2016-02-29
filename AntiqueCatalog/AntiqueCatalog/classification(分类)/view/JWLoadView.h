//
//  JWLoadView.h
//  网络加载指示器
//
//  Created by JW on 12/17/15.
//  Copyright © 2015 JW. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JWLoadView : UIView

@property (strong,nonatomic) UIImageView * loadingView;

- (void)showMessage:(NSString *)message;

- (void)dismiss;

+(JWLoadView *)sharedJWLoadView;
@end
