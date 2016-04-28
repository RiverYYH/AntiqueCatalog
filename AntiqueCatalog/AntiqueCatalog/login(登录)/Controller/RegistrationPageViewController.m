//
//  RegistrationPageViewController.m
//  到处是宝
//
//  Created by Cangmin on 15/10/8.
//  Copyright © 2015年 huihao. All rights reserved.
//

#import "RegistrationPageViewController.h"
#import "otherregisactionView.h"
#import "LoginViewController.h"
#import "RegisterDetailViewController.h"
#import "RegisterViewController.h"

#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import "Allview.h"
@interface RegistrationPageViewController ()<UIActionSheetDelegate>

@property(nonatomic,strong)UIImageView *registrationBgimageview;
@property(nonatomic,strong)UIImageView *logoIconimageview;
@property(nonatomic,strong)UILabel *iconlabel;
@property(nonatomic,strong)UIButton *weixinbutton;
@property(nonatomic,strong)UIButton *otherRegbutton;
@property(nonatomic,strong)UIButton *loginbutton;

@property(nonatomic,strong)UIActionSheet *regisactionSheetview;
@property(nonatomic,strong)otherregisactionView *otherregView;

@end

@implementation RegistrationPageViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleImageView.hidden = YES;
    self.view.backgroundColor = Black_Color;
    
    [self CreatUI];
    
    double delayInSeconds = 0.01;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after (popTime, dispatch_get_main_queue(), ^(void){
        [self BackgroundAnimation];
    });
    
}

-(void)CreatUI
{
    if (iPhone4) {
        _registrationBgimageview = [Allview Withimagename:@"RegistrationPageBg_960" WithcornerRadius:0.0 WithBgcolor:Clear_Color];
    }else{
        _registrationBgimageview = [Allview Withimagename:@"RegistrationPageBg_1136" WithcornerRadius:0.0 WithBgcolor:Clear_Color];
    }
    _registrationBgimageview.frame = CGRectMake(30, 30, UI_SCREEN_WIDTH - 60, UI_SCREEN_HEIGHT - 60);
    [self.view addSubview:_registrationBgimageview];
    
    _logoIconimageview = [Allview Withimagename:@"logoluminousIcon" WithcornerRadius:3.0 WithBgcolor:Clear_Color];
    _logoIconimageview.frame = CGRectMake(UI_SCREEN_WIDTH/2 - 30, 130, 60, 60);
    [self.view addSubview:_logoIconimageview];
    
    _iconlabel = [Allview Withstring:@"发现属于你的艺术" Withcolor:White_Color Withbgcolor:Clear_Color Withfont:16 WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _iconlabel.frame = CGRectMake(0, CGRectGetMaxY(_logoIconimageview.frame) + 20, UI_SCREEN_WIDTH, 30);
    [self.view addSubview:_iconlabel];
    
    
    if ([WXApi isWXAppInstalled]) {
        _weixinbutton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"微信注册" Withcolor:White_Color Withfont:16 WithBgcolor:RGBA(96,200,79) WithcornerRadius:3];
        [_weixinbutton setImage:[UIImage imageNamed:@"weixinicon"] forState:UIControlStateNormal];
    }else{
        _weixinbutton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"手机注册" Withcolor:White_Color Withfont:16 WithBgcolor:RGBA(96,200,79) WithcornerRadius:3];
        [_weixinbutton setImage:[UIImage imageNamed:@"regisactionPhon"] forState:UIControlStateNormal];
    }
    
    _weixinbutton.adjustsImageWhenHighlighted = NO;
    _weixinbutton.tag = 100;
    [_weixinbutton addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchDown];
    _weixinbutton.frame = CGRectMake(10, UI_SCREEN_HEIGHT - 130, UI_SCREEN_WIDTH - 20, 50);
    [self.view addSubview:_weixinbutton];
    
    _otherRegbutton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"其他方式注册" Withcolor:Black_Color Withfont:16 WithBgcolor:White_Color WithcornerRadius:3];
    _otherRegbutton.tag = 101;
    [_otherRegbutton addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    _otherRegbutton.frame = CGRectMake(10, CGRectGetMaxY(_weixinbutton.frame) + 10, UI_SCREEN_WIDTH/2 - 10, 50);
    [self.view addSubview:_otherRegbutton];
//    NSLog(@"%@",NSStringFromCGRect(_otherRegbutton.frame));
    
    _loginbutton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"已有账号登录" Withcolor:Black_Color Withfont:16 WithBgcolor:White_Color WithcornerRadius:3];
    _loginbutton.tag = 102;
    [_loginbutton addTarget:self action:@selector(buttonclick:) forControlEvents:UIControlEventTouchUpInside];
    _loginbutton.frame = CGRectMake(UI_SCREEN_WIDTH/2 + 10, CGRectGetMaxY(_weixinbutton.frame) + 10, UI_SCREEN_WIDTH/2 - 20, 50);
    [self.view addSubview:_loginbutton];
   
}

-(void)buttonclick:(UIButton *)button
{
    switch (button.tag) {
        case 100:
        {
            if ([WXApi isWXAppInstalled]) {
                [self weixinRegis];
            }else{
                RegisterViewController *registerVC = [[RegisterViewController alloc] init];
                [self.navigationController pushViewController:registerVC animated:YES];
            }
        }
            
            break;
        case 101:
        {

            if (_otherregView != NULL) {
                _otherregView.hidden = NO;
                if ([QQApi isQQInstalled]) {
                    _otherregView.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 50*5+20, UI_SCREEN_WIDTH, 50*4+20+0.5*2);
                }else{
                    _otherregView.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 50*4+20, UI_SCREEN_WIDTH, 50*3+20+0.5*2);
                }
            }else{
                _otherregView = [[otherregisactionView alloc]init];
                [_otherregView block:^(NSInteger clickIndex) {
                    [self otherregclick:clickIndex];
                }];
                if ([QQApi isQQInstalled]) {
                    _otherregView.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 50*5+20, UI_SCREEN_WIDTH, 50*4+20+0.5*2);
                }else{
                    _otherregView.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 50*4+20, UI_SCREEN_WIDTH, 50*3+20+0.5*2);
                }
                
    //            NSLog(@"%@",NSStringFromCGRect(_otherregView.frame));
                [self.view addSubview:_otherregView];
            }
            
            
        }
            
            break;
        case 102:
        {
            LoginViewController *longinVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:longinVC animated:YES];
        }
            
            break;
            
        default:
            break;
    }
}

#pragma mark-其他注册方式
-(void)otherregclick:(NSInteger)integer
{
    switch (integer) {
        case 0:
        {
            [self closeotherrdg];
            RegisterViewController *registerVC = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
            break;
        case 1:
        {
            [self closeotherrdg];
            if ([QQApi isQQInstalled]) {
                [self qqRegis];
            }else{
                [self weiboRegis];
            }
        }
            break;
        case 2:
        {
            [self closeotherrdg];
            [self weiboRegis];
        }
            break;
        case 3:
        {
            [self closeotherrdg];
        }
            break;
            
        default:
            break;
    }
}


#pragma mark-背景动画
-(void)BackgroundAnimation
{
    [UIView animateWithDuration:2 animations:^{
        _registrationBgimageview.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}
#pragma mark-关闭注册页面
-(void)closeotherrdg
{
    [UIView animateWithDuration:1 animations:^{
        
        _otherregView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 0);
        
    } completion:^(BOOL finished) {
        
        if (finished) {
            _otherregView.hidden = NO;
        }
        
    }];
}

#pragma mark-微信注册
-(void)weixinRegis
{
    [ShareSDK getUserInfoWithType:ShareTypeWeixiSession //平台类型
                      authOptions:nil //授权选项
                           result:^(BOOL result, id userInfo, id error) { //返回回调
                               if (result)
                               {
                                   NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"type",[[ShareSDK getCredentialWithType:ShareTypeWeixiSession] uid],@"type_uid",[[ShareSDK getCredentialWithType:ShareTypeWeixiSession] token],@"access_token", nil];
                                   [self updateParam:param];
                               }
                               else
                               {
                                   NSLog(@"授权失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                               }
                           }];
}

#pragma mark-QQ注册
-(void)qqRegis
{
    [ShareSDK getUserInfoWithType:ShareTypeQQSpace //平台类型
                      authOptions:nil //授权选项
                           result:^(BOOL result, id userInfo, id error) { //返回回调
                               if (result)
                               {
                                   NSLog(@"uid = %@",[userInfo uid]);
                                   NSLog(@"name = %@",[userInfo nickname]);
                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                   NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"qzone",@"type",[[ShareSDK getCredentialWithType:ShareTypeQQSpace] uid],@"type_uid",[[ShareSDK getCredentialWithType:ShareTypeQQSpace] token],@"access_token", nil];
                                   [self updateParam:param];
                               }
                               else
                               {
                                   NSLog(@"授权失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                               }
                           }];
}

#pragma mark-微博注册
-(void)weiboRegis
{
    [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo //平台类型
                      authOptions:nil //授权选项
                           result:^(BOOL result, id userInfo, id error) { //返回回调
                               if (result)
                               {
                                   NSLog(@"uid = %@",[userInfo uid]);
                                   NSLog(@"name = %@",[userInfo nickname]);
                                   NSLog(@"icon = %@",[userInfo profileImage]);
                                   NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"sina",@"type",[[ShareSDK getCredentialWithType:ShareTypeSinaWeibo] uid],@"type_uid",[[ShareSDK getCredentialWithType:ShareTypeSinaWeibo] token],@"access_token", nil];
                                   [self updateParam:param];
                               }
                               else
                               {
                                   NSLog(@"授权失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                               }
                           }];
}

#pragma marl-检查第三方账号是否与账号进行过绑定
-(void)updateParam:(NSDictionary *)param
{
    //检查第三方账号是否与账号进行过绑定
    [Api requestWithMethod:@"get" withPath:API_URL_Other_Login withParams:param withSuccess:^(id responseObject) {
        //        NSLog(@"responseObject = %@",responseObject);
        if ([[responseObject objectForKey:@"status"] isEqualToNumber:[NSNumber numberWithInt:0]])
        {
            //帐号尚未绑定
            RegisterDetailViewController *registerDetailVC =
            [[RegisterDetailViewController alloc]initWithNibName:nil bundle:nil andPhone:nil andRegCode:nil andDic:param andType:DiSanFang];
            [self.navigationController pushViewController:registerDetailVC animated:YES];
        }
        else
        {
            [UserModel saveUserLoginType:[param objectForKey:@"type"]];
            //帐号已经绑定
            [UserModel saveUserPassportWithUname:[responseObject objectForKey:@"uname"] andUid:[responseObject objectForKey:@"uid"] andToken:[responseObject objectForKey:@"oauth_token"] andTokenSecret:[responseObject objectForKey:@"oauth_token_secret"] andAvatar:[responseObject objectForKey:@"avatar_middle"]];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSFULL" object:self userInfo:nil];
        }
    } withError:^(NSError *error) {
        [self hideHud];
        [self showHudInView:self.view showHint:@"操作失败"];
    }];
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
