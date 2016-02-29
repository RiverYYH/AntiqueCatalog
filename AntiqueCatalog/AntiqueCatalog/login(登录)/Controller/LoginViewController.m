//
//  LoginViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/25.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "LoginViewController.h"

#define lineRGB RGBA(209,209,209)
#define buttonRGB RGBA(190, 71, 49)

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
    
    [self CreatUI];
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
