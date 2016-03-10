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
//        if([WXApi isWXAppInstalled] && [QQApi isQQInstalled]) {
//            [self thirdLogin:35 and:UI_SCREEN_WIDTH-190 and:UI_SCREEN_WIDTH-95 andsuperView:backgroundView];
//        } else if ([WXApi isWXAppInstalled] && ![QQApi isQQInstalled]) {
//            [self thirdLogin:75 and:0 and:UI_SCREEN_WIDTH-135 andsuperView:backgroundView];
//        } else if (![WXApi isWXAppInstalled] && [QQApi isQQInstalled]) {
//            [self thirdLogin:0 and:85 and:UI_SCREEN_WIDTH-145 andsuperView:backgroundView];
//        } else {
//            [self thirdLogin:0 and:0 and:UI_SCREEN_WIDTH/2-30 andsuperView:backgroundView];
//        }
        [self thirdLogin:35 and:UI_SCREEN_WIDTH-210 and:UI_SCREEN_WIDTH-95 andsuperView:backgroundView];

    }
    
//    [self CreatUI];
    // Do any additional setup after loading the view.
}

- (void)CreatUI
{
    self.titleLabel.text = @"登录";
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = White_Color;
    self.titleImageView.backgroundColor = RGBA(43, 43, 43);
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    [control addTarget:self action:@selector(controlClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:control];
    
    UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-30, 30 + UI_NAVIGATION_BAR_HEIGHT, 60, 60)];
    iconImageView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    iconImageView.image = [UIImage imageNamed:@"Login_Icon"];
    [self.view addSubview:iconImageView];
    
    
    
    _accountTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(iconImageView.frame) + 30, UI_SCREEN_WIDTH-20, 35)];
    _accountTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭首字母大写
    _accountTextField.autocorrectionType = UITextAutocorrectionTypeNo;//关闭自动联想
    _accountTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _accountTextField.placeholder = @"请输入用户名/手机号";
    _accountTextField.text = [[NSUserDefaults standardUserDefaults] objectForKey:@"LastUserModelPassport"];
    [_accountTextField setValue:Deputy_Colour forKeyPath:@"_placeholderLabel.textColor"];
    _accountTextField.textAlignment = NSTextAlignmentCenter;
    _accountTextField.font = [UIFont systemFontOfSize:14];
    _accountTextField.layer.masksToBounds = YES;
    _accountTextField.layer.cornerRadius = 17;
    [_accountTextField.layer setBorderWidth:0.5];
    [_accountTextField.layer setBorderColor:lineRGB.CGColor];
    [self.view addSubview:_accountTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_accountTextField.frame) + 10, UI_SCREEN_WIDTH-20, 35)];
    //    _passwordTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.placeholder = @"请输入密码";
    [_passwordTextField setValue:Deputy_Colour forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTextField.textAlignment = NSTextAlignmentCenter;
    _passwordTextField.font = [UIFont systemFontOfSize:14];
    [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _passwordTextField.layer.masksToBounds = YES;
    _passwordTextField.layer.cornerRadius = 17;
    [_passwordTextField.layer setBorderWidth:0.5];
    [_passwordTextField.layer setBorderColor:lineRGB.CGColor];
    [self.view addSubview:_passwordTextField];
    
    
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
    [self.view addSubview:loginButton];
    
    UIButton *forgetButton = [UIButton buttonWithType:UIButtonTypeCustom];
    forgetButton.frame = CGRectMake(UI_SCREEN_WIDTH-90, CGRectGetMaxY(loginButton.frame) + 10, 80, 30);
    [forgetButton setTitle:@"忘记密码？" forState:UIControlStateNormal];
    forgetButton.titleLabel.font = [UIFont systemFontOfSize:14];
    [forgetButton setTitleColor:buttonRGB forState:UIControlStateNormal];
    [forgetButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    forgetButton.tag = 101;
    [self.view addSubview:forgetButton];
    
    
    UIImageView *orImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(forgetButton.frame) + 10, UI_SCREEN_WIDTH, 1)];
    //    orImageView.image = [UIImage imageNamed:@"Login_segmentLine"];
    orImageView.backgroundColor = lineRGB;
    [self.view addSubview:orImageView];
    
    UILabel *orLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-50, CGRectGetMaxY(orImageView.frame) + 10, 100, 20)];
    orLabel.text = @"其他方式登录";
    orLabel.font = [UIFont systemFontOfSize:14];
    orLabel.textAlignment = NSTextAlignmentCenter;
    orLabel.textColor = RGBA(153, 153, 153);
    [self.view addSubview:orLabel];
    
    //判断QQ或者微信是否安装
    if([WXApi isWXAppInstalled] && [QQApi isQQInstalled]) {
        [self thirdLogin:35 and:UI_SCREEN_WIDTH-190 and:UI_SCREEN_WIDTH-95 andsuperView:self.view];
    } else if ([WXApi isWXAppInstalled] && ![QQApi isQQInstalled]) {
        [self thirdLogin:75 and:0 and:UI_SCREEN_WIDTH-135 andsuperView:self.view];
    } else if (![WXApi isWXAppInstalled] && [QQApi isQQInstalled]) {
        [self thirdLogin:0 and:85 and:UI_SCREEN_WIDTH-145 andsuperView:self.view];
    } else {
        [self thirdLogin:0 and:0 and:UI_SCREEN_WIDTH/2-30 andsuperView:self.view];
    }

    
}

- (void)thirdLogin:(CGFloat)x1 and:(CGFloat)x2 and:(CGFloat)x3 andsuperView:(UIView *)backgroundView
{
    UIButton *qqButton = [UIButton buttonWithType:UIButtonTypeCustom];
    qqButton.frame = CGRectMake(x2+5, 345, 50, 50);
    qqButton.tag = 103;
    qqButton.adjustsImageWhenHighlighted = NO;
    [qqButton setBackgroundImage:[UIImage imageNamed:@"Login_qq"] forState:UIControlStateNormal];
    [qqButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *qqLabel = [[UILabel alloc] initWithFrame:CGRectMake(x2, 395, 60, 30)];
    qqLabel.text = @"QQ";
    qqLabel.textColor = othertitle;
    qqLabel.font = [UIFont systemFontOfSize:14];
    qqLabel.textAlignment = NSTextAlignmentCenter;
    [backgroundView addSubview:qqButton];
    [backgroundView addSubview:qqLabel];
    
    UIButton *weixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    weixinButton.frame = CGRectMake(x1+5, 345, 50, 50);
    weixinButton.tag = 104;
    weixinButton.adjustsImageWhenHighlighted = NO;
    [weixinButton setBackgroundImage:[UIImage imageNamed:@"Login_weixin"] forState:UIControlStateNormal];
    [weixinButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *weixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(x1, 395, 60, 30)];
    weixinLabel.text = @"微信";
    weixinLabel.textColor = othertitle;
    weixinLabel.font = [UIFont systemFontOfSize:14];
    weixinLabel.textAlignment = NSTextAlignmentCenter;
    
    [backgroundView addSubview:weixinLabel];
    [backgroundView addSubview:weixinButton];
    
    if(x1 == 0) {
        //        qqButton.hidden = YES;
        //        qqLabel.hidden = YES;
        weixinLabel.hidden = YES;
        weixinButton.hidden = YES;
    }
    if(x2 == 0) {
        //        weixinLabel.hidden = YES;
        //        weixinButton.hidden = YES;
        qqButton.hidden = YES;
        qqLabel.hidden = YES;
    }
    
    UIButton *sinaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sinaButton.frame = CGRectMake(x3 + 5, 345, 50, 50);
    sinaButton.tag = 105;
    sinaButton.adjustsImageWhenHighlighted = NO;
    [sinaButton setBackgroundImage:[UIImage imageNamed:@"Login_weibo"] forState:UIControlStateNormal];
    [sinaButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:sinaButton];
    
    UILabel *sinaLabel = [[UILabel alloc] initWithFrame:CGRectMake(x3, 395, 60, 30)];
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
            [Api requestWithbool:NO withMethod:@"get" withPath:API_URL_AUTHORIZE withParams:params withSuccess:^(id responseObject) {
                
                [UserModel saveUserPassportWithdic:responseObject];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"loaduserinfo" object:nil];
                
            } withError:^(NSError *error) {
                
            }];
        }
            break;
        case 101:
        {
            
        }
            break;
            
        default:
            break;
    }
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
