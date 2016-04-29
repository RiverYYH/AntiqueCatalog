//
//  LoginViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/25.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "LoginViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "WXApi.h"
#import <TencentOpenAPI/QQApi.h>
#import "ForgetViewController.h"
#import "RegisterDetailViewController.h"
#import "RegisterViewController.h"
#define lineRGB RGBA(209,209,209)
#define buttonRGB RGBA(190, 71, 49)
#define othertitle RGBA(153, 153, 153)

@interface LoginViewController ()

@property (nonatomic,strong)UITextField *accountTextField;
@property (nonatomic,strong)UITextField *passwordTextField;

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        
        self.titleLabel.text = @"登录";
        self.titleLabel.font = [UIFont systemFontOfSize:16];
        self.titleLabel.textColor = White_Color;
        self.titleImageView.backgroundColor = RGBA(43, 43, 43);
        
        UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
        //    bgImageView.image = [UIImage imageNamed:@"Login_bgImage"];
        [self.view addSubview:bgImageView];
        
        UIView *backgroundView = [[UIView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME];
        backgroundView.backgroundColor = RGBA(243, 243, 243);
        [self.view addSubview:backgroundView];
        
        UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
        [control addTarget:self action:@selector(controlClicked) forControlEvents:UIControlEventTouchUpInside];
        [backgroundView addSubview:control];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-30, 30, 60, 60)];
        iconImageView.image = [UIImage imageNamed:@"Login_Icon"];
        [backgroundView addSubview:iconImageView];
        
        
        
        _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(iconImageView.frame) + 30, UI_SCREEN_WIDTH-20, 35)];
        _accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭首字母大写
        _accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;//关闭自动联想
        _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _accountTextField.placeholder = @"请输入用户名/手机号";
        _accountTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUserModelPassport"];
        [_accountTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
        _accountTextField.textAlignment = NSTextAlignmentCenter;
        _accountTextField.font = [UIFont systemFontOfSize:14];
        _accountTextField.layer.masksToBounds = YES;
        _accountTextField.layer.cornerRadius = 17;
        [_accountTextField.layer setBorderWidth:0.5];
        [_accountTextField.layer setBorderColor:lineRGB.CGColor];
        [backgroundView addSubview:_accountTextField];
        
        _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_accountTextField.frame) + 10, UI_SCREEN_WIDTH-20, 35)];
        //    _passwordTextField.keyboardType = UIKeyboardTypeNamePhonePad;
        _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
        _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _passwordTextField.placeholder = @"请输入密码";
        [_passwordTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
        _passwordTextField.textAlignment = NSTextAlignmentCenter;
        _passwordTextField.font = [UIFont systemFontOfSize:14];
        [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
        _passwordTextField.layer.masksToBounds = YES;
        _passwordTextField.layer.cornerRadius = 17;
        [_passwordTextField.layer setBorderWidth:0.5];
        [_passwordTextField.layer setBorderColor:lineRGB.CGColor];
        [backgroundView addSubview:_passwordTextField];
        
        //    UIImageView *accountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
        //    accountImageView.image = [UIImage imageNamed:@"Login_zhanghao"];
        //    [inputView addSubview:accountImageView];
        //
        //    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 54, 25, 25)];
        //    passwordImageView.image = [UIImage imageNamed:@"Login_mima"];
        //    [inputView addSubview:passwordImageView];
        //
        //    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, UI_SCREEN_WIDTH-20, 0.5)];
        //    lineImageView.backgroundColor = [UIColor grayColor];
        //    [inputView addSubview:lineImageView];
        
        //    _showPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        //    _showPasswordBtn.frame = CGRectMake(UI_SCREEN_WIDTH-54, 60, 25, 15);
        //    [_showPasswordBtn setImage:[UIImage imageNamed:@"Login_noshowpd"] forState:UIControlStateNormal];
        //    [_showPasswordBtn addTarget:self action:@selector(showPassWordBtnClicked) forControlEvents:UIControlEventTouchUpInside];
        //    [inputView addSubview:_showPasswordBtn];
        
        UIButton *loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        loginButton.frame = CGRectMake(10, CGRectGetMaxY(_passwordTextField.frame) + 10, UI_SCREEN_WIDTH-20, 35);
        [loginButton setTitle:@"登录" forState:UIControlStateNormal];
        loginButton.titleLabel.font = [UIFont systemFontOfSize:17];
        //    [loginButton setBackgroundImage:[UIImage imageNamed:@"Login_login"] forState:UIControlStateNormal];
        [loginButton setBackgroundColor:buttonRGB];
        [loginButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        loginButton.tag = 100;
        loginButton.layer.masksToBounds = YES;
        loginButton.layer.cornerRadius = 17;
        [backgroundView addSubview:loginButton];
        
        //    UIButton *registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        //    registerButton.frame = CGRectMake(UI_SCREEN_WIDTH/2+10, 250, UI_SCREEN_WIDTH/2-20, 40);
        //    [registerButton setTitle:@"注册" forState:UIControlStateNormal];
        //    registerButton.titleLabel.font = [UIFont boldSystemFontOfSize:17];
        //    [registerButton setBackgroundImage:[UIImage imageNamed:@"Login_register"] forState:UIControlStateNormal];
        //    [registerButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        //    registerButton.tag = 101;
        //    [backgroundView addSubview:registerButton];
        
        UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
        forgetButton.frame = CGRectMake(UI_SCREEN_WIDTH-90, CGRectGetMaxY(loginButton.frame) + 5, 80, 30);
        [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
        forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [forgetButton setTitleColor:buttonRGB forState:UIControlStateNormal];
        [forgetButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        forgetButton.tag = 102;
        [backgroundView addSubview:forgetButton];
        
        
        
        UIImageView *orImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(forgetButton.frame) + 10, UI_SCREEN_WIDTH, 1)];
        //    orImageView.image = [UIImage imageNamed:@"Login_segmentLine"];
        orImageView.backgroundColor = lineRGB;
        [backgroundView addSubview:orImageView];
        
        UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-50, CGRectGetMaxY(orImageView.frame) + 10, 100, 20)];
        orLabel.text = @"其他方式登录";
        orLabel.font = [UIFont systemFontOfSize:14];
        orLabel.textAlignment = NSTextAlignmentCenter;
        orLabel.textColor = RGBA(153, 153, 153);
        [backgroundView addSubview:orLabel];
        
        //判断QQ或者微信是否安装
        float tempF3 = UI_SCREEN_WIDTH / 4;
        float tempF2 = UI_SCREEN_WIDTH / 3;
        float tempF1 = UI_SCREEN_WIDTH / 2;
        
        float x1,x2,x3;

        if([WXApi isWXAppInstalled] && [QQApi isQQInstalled]) {
            x1 = tempF3 - 25;
            x2 = tempF3 * 2 - 25;
            x3 = tempF3 * 3 - 25;
            [self thirdLogin:x1 and:x2 and:x3 andsuperView:self.view];
        } else if ([WXApi isWXAppInstalled] && ![QQApi isQQInstalled]) {
            x1 = tempF2 - 25;
            x2 = 0;
            x3 = tempF2 * 2 -25;
            [self thirdLogin:x1 and:x2 and:x3 andsuperView:self.view];
        } else if (![WXApi isWXAppInstalled] && [QQApi isQQInstalled]) {
            x1 = 0;
            x2 = tempF2 - 25;
            x3 = tempF2 * 2 - 25;
            [self thirdLogin:x1 and:x2 and:x3 andsuperView:self.view];
        } else {
            x1 = 0;
            x2 = 0;
            x3 = tempF1 - 25;
            [self thirdLogin:x1 and:x2 and:x3 andsuperView:self.view];
        }
        
    }
    // Do any additional setup after loading the view.
}


- (void)thirdLogin:(CGFloat)x1 and:(CGFloat)x2 and:(CGFloat)x3 andsuperView:(UIView *)backgroundView
{
    UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinButton.frame = CGRectMake(x1, 405, 50, 50);
    weixinButton.tag = 104;
    weixinButton.adjustsImageWhenHighlighted = NO;
    [weixinButton setBackgroundImage:[UIImage imageNamed:@"Login_weixin"] forState:UIControlStateNormal];
    [weixinButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(x1 - 5 , 455, 60, 30)];
    weixinLabel.text = @"微信";
    weixinLabel.textColor = othertitle;
    weixinLabel.font = [UIFont systemFontOfSize:14];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    

    [backgroundView addSubview:weixinLabel];
    [backgroundView addSubview:weixinButton];

    
    
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.frame = CGRectMake(x2 , 405, 50, 50);
    qqButton.tag = 103;
    qqButton.adjustsImageWhenHighlighted = NO;
    [qqButton setBackgroundImage:[UIImage imageNamed:@"Login_qq"] forState:UIControlStateNormal];
    [qqButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2 - 5, 455, 60, 30)];
    qqLabel.text = @"QQ";
    qqLabel.textColor = othertitle;
    qqLabel.font = [UIFont systemFontOfSize:14];
    qqLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:qqButton];
    [backgroundView addSubview:qqLabel];
    
    
    if(x1 == 0) {
        weixinLabel.hidden = YES;
        weixinButton.hidden = YES;
    }
    if(x2 == 0) {
        qqButton.hidden = YES;
        qqLabel.hidden = YES;
    }
    
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.frame = CGRectMake(x3 , 405, 50, 50);
    sinaButton.tag = 105;
    sinaButton.adjustsImageWhenHighlighted = NO;
    [sinaButton setBackgroundImage:[UIImage imageNamed:@"Login_weibo"] forState:UIControlStateNormal];
    [sinaButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:sinaButton];
    
    UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(x3 - 5, 455, 60, 30)];
    sinaLabel.text = @"微博";
    sinaLabel.textColor = othertitle;
    sinaLabel.font = [UIFont systemFontOfSize:14];
    sinaLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:sinaLabel];
}


- (void)buttonClicked:(UIButton *)button
{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    
    switch (button.tag) {
        case 100:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           _accountTextField.text,@"login",
                                           _passwordTextField.text,@"password",
                                           nil];
            [Api showLoadMessage:@"正在登录"];
            [Api requestWithbool:NO withMethod:@"get" withPath:API_URL_AUTHORIZE withParams:params withSuccess:^(id responseObject) {
                [Api hideLoadHUD];
                if([responseObject[@"status"] intValue] == 0){
                    [self showHudInView:self.view showHint:responseObject[@"msg"]];
                }else{
                    [UserModel saveUserPassportWithdic:responseObject];
                    if([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLogin"] intValue] == 1) {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSFULL" object:self userInfo:nil];
                        [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"firstLogin"];
                        [[NSUserDefaults standardUserDefaults] synchronize];
                        
                    }else{
                        [self.navigationController popToRootViewControllerAnimated:YES];
                        
                    }
                    [[NSNotificationCenter defaultCenter]postNotificationName:@"loaduserinfo" object:nil];
                }

            } withError:^(NSError *error) {
                [Api hideLoadHUD];
            }];
        }
            break;
        case 101:
        {
            RegisterViewController *registerVC = [[RegisterViewController alloc] init];
            [self.navigationController pushViewController:registerVC animated:YES];
        }
            break;
        case 102:
        {
            ForgetViewController *forgetVC = [[ForgetViewController alloc] init];
            [self.navigationController pushViewController:forgetVC animated:YES];
        }
            break;
        case 103:
        {
            NSLog(@"QQ");
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
            break;
        case 104:
        {
            NSLog(@"微信");
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
            break;
        case 105:
        {
            NSLog(@"微博");
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
            break;

            
        default:
            break;
    }
}


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
            [[NSNotificationCenter defaultCenter]postNotificationName:@"loaduserinfo" object:nil];
            if([[[NSUserDefaults standardUserDefaults] objectForKey:@"firstLogin"] intValue] == 1) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSFULL" object:self userInfo:nil];
                [[NSUserDefaults standardUserDefaults] setObject:@"0" forKey:@"firstLogin"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
            }else{
                [self.navigationController popToRootViewControllerAnimated:YES];
                
            }
//            [self.navigationController popViewControllerAnimated:YES];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSFULL" object:self userInfo:nil];

            
        }
    } withError:^(NSError *error) {
        [self hideHud];
        [self showHudInView:self.view showHint:@"操作失败"];
    }];
}



- (void)controlClicked
{
    [_accountTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
}

//限制15字符
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 15)
    {
        textField.text = [textField.text substringToIndex:15];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
