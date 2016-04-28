//
//  RegisterViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/8.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "RegisterViewController.h"
#import "RegisterDetailViewController.h"

#import <SMS_SDK/SMS_SDK.h>

@interface RegisterViewController ()
{
    UITextField *_phoneTextField;
    UITextField *_verificationTextField;
    UIButton *_verificationButton;
    
    int remainTime;
    NSTimer *_timer;
    NSTimer *_requestTimer;
}
@end

@implementation RegisterViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"注册";
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME];
    [self.view addSubview:backgroundView];
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    [control addTarget:self action:@selector(controlClicked) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:control];
    
    UIView *backView1 = [[UIView alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH, 44)];
    backView1.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:backView1];
    
    UIView *backView2 = [[UIView alloc] initWithFrame:CGRectMake(0, 74, UI_SCREEN_WIDTH, 44)];
    backView2.backgroundColor = [UIColor whiteColor];
    [backgroundView addSubview:backView2];
    
    _phoneTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, UI_SCREEN_WIDTH-30, 44)];
    _phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    _phoneTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _phoneTextField.placeholder = @"输入手机号";
    [_phoneTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _phoneTextField.font = [UIFont systemFontOfSize:15];
    [_phoneTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:_phoneTextField];
    
    _verificationTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 74, 170, 44)];
    _verificationTextField.keyboardType = UIKeyboardTypeNumberPad;
    _verificationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _verificationTextField.placeholder = @"输入验证码";
    [_verificationTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _verificationTextField.font = [UIFont systemFontOfSize:15];
    [_verificationTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:_verificationTextField];
    
    _verificationButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _verificationButton.frame = CGRectMake(UI_SCREEN_WIDTH-120, 80, 110, 32);
    _verificationButton.layer.masksToBounds = YES;
    _verificationButton.layer.cornerRadius = 4.0;
    [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    _verificationButton.titleLabel.font = [UIFont systemFontOfSize:16];
    [_verificationButton setBackgroundColor:RGBA(19, 196, 119)];
    [_verificationButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _verificationButton.tag = 101;
    [backgroundView addSubview:_verificationButton];
    
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(10, 138, UI_SCREEN_WIDTH-20, 40);
    nextButton.layer.masksToBounds = YES;
    nextButton.layer.cornerRadius = 4.0;
    [nextButton setTitle:@"下一步" forState:UIControlStateNormal];
    nextButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [nextButton setBackgroundColor:ICON_COLOR];
    [nextButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    nextButton.tag = 102;
    [backgroundView addSubview:nextButton];
}

- (void)controlClicked
{
    [_phoneTextField resignFirstResponder];
    [_verificationTextField resignFirstResponder];
}

- (void)buttonClicked:(UIButton *)button
{
    [_phoneTextField resignFirstResponder];
    [_verificationTextField resignFirstResponder];
    
    switch (button.tag)
    {
        case 101:
        {
            if (STRING_NOT_EMPTY(_phoneTextField.text))
            {
                _verificationButton.enabled = NO;
                [_verificationButton setTitle:@"发送中" forState:UIControlStateDisabled];//注意此处状态为UIControlStateDisabled
                [_verificationButton setBackgroundColor:[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1]];
//
                _requestTimer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(requestOut) userInfo:nil repeats:NO];
//                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_phoneTextField.text,@"phone", nil];
                [self showHudInView:self.view hint:@"发送中..."];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [SMS_SDK getVerificationCodeBySMSWithPhone:_phoneTextField.text zone:@"86" result:^(SMS_SDKError *error) {
                        if(!error) {
                            [self hideHud];
                            [self showHudInView:self.view showHint:@"发送成功"];
                            
                            [_requestTimer invalidate];
                            _requestTimer = nil;
                            
                            remainTime = 59;
                            _timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timerBegin:) userInfo:nil repeats:YES];
                        } else {
                            [_requestTimer invalidate];
                            _requestTimer = nil;
                            
                            [self hideHud];
                            [self showHudInView:self.view showHint:error.description];
                            
                            _verificationButton.enabled = YES;
                            [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
                            [_verificationButton setBackgroundColor:RGBA(19, 196, 119)];
                        }
                    }];
                });
            }
            else
            {
                [self showHudInView:self.view showHint:@"手机号码不能为空"];
            }
        }
            break;
        case 102:
        {
            if (STRING_NOT_EMPTY(_phoneTextField.text)&&STRING_NOT_EMPTY(_verificationTextField.text))
            {
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_phoneTextField.text,@"phone",_verificationTextField.text, @"code", nil];
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    [self showHudInView:self.view hint:@"验证中..."];
                    [Api requestWithMethod:@"GET" withPath:API_URL_User_Send_Code_New withParams:params withSuccess:^(id responseObject){
                        if ([[responseObject objectForKey:@"status"] intValue] == 1)
                        {
                            [self hideHud];
                            
                            [_timer invalidate];
                            _timer = nil;
                            
//                            RegisterDetailViewController *registerDetailVC = [[RegisterDetailViewController alloc] initWithNibName:nil bundle:nil andPhone:_phoneTextField.text andRegCode:_verificationTextField.text];
                            RegisterDetailViewController *registerDetailVC = [[RegisterDetailViewController alloc] initWithNibName:nil bundle:nil andPhone:_phoneTextField.text andRegCode:_verificationTextField.text andDic:nil andType:Phone];
                            [self.navigationController pushViewController:registerDetailVC animated:YES];
                        }
                        else
                        {
                            [self hideHud];
                            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                        });
                    } withError:^(NSError *error){
                        [self hideHud];
                        [self showHudInView:self.view showHint:@"请检查网络设置"];
                    }];
                });
            }
            else
            {
                [self showHudInView:self.view showHint:@"手机号码/验证码不能为空"];
            }
        }
            break;
        default:
            break;
    }
}

#pragma mark - 定时器调用方法
- (void)requestOut
{
    [self hideHud];
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"请求超时" message:@"请检查网络设置" delegate:self cancelButtonTitle:@"返回" otherButtonTitles:@"重新请求", nil];
    [alertView show];
    [_requestTimer invalidate];
    _requestTimer = nil;
}

- (void)timerBegin:(NSTimer *)timer
{
    _verificationButton.enabled = NO;
    [_verificationButton setTitle:[NSString stringWithFormat:@"(%d)重新发送",remainTime] forState:UIControlStateDisabled];//注意此处状态为UIControlStateDisabled
    [_verificationButton setBackgroundColor:[UIColor colorWithRed:181/255.0 green:181/255.0 blue:181/255.0 alpha:1]];
    
    remainTime -= 1;
    
    if (remainTime == -1)
    {
        [_timer invalidate];
        _timer = nil;
        
        remainTime = 59;
        _verificationButton.enabled = YES;
        [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verificationButton setBackgroundColor:RGBA(19, 196, 119)];
        
        [timer invalidate];
        timer = nil;
    }
}
#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        [self.navigationController popViewControllerAnimated:YES];
    } else if (buttonIndex == 1) {
        remainTime = 59;
        _verificationButton.enabled = YES;
        [_verificationButton setTitle:@"获取验证码" forState:UIControlStateNormal];
        [_verificationButton setBackgroundColor:RGBA(19, 196, 119)];
        
        [self buttonClicked:_verificationButton];
    }
}
#pragma mark - 限制字符
//限制字符
- (void)textFieldDidChange:(UITextField *)textField
{
    if ([textField isEqual:_phoneTextField])
    {
        if (textField.text.length > 11)
        {
            textField.text = [textField.text substringToIndex:11];
        }
    }
    else
    {
        if (textField.text.length > 4)
        {
            textField.text = [textField.text substringToIndex:4];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
