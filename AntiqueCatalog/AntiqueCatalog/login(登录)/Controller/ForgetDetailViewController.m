//
//  ForgetDetailViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/8.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "ForgetDetailViewController.h"

@interface ForgetDetailViewController ()
{
    UITextField *_passwordTextField;
    UITextField *_repeatTextField;
    
    NSString *_phone;
    NSString *_regCode;
}
@end

@implementation ForgetDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPhone:(NSString *)phone andRegCode:(NSString *)regCode
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _phone = phone;
        _regCode = regCode;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"重置密码";
    
    UIView *backgroundView = [[UIView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME];
    backgroundView.backgroundColor = [UIColor clearColor];
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
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 20, UI_SCREEN_WIDTH-30, 44)];
   // _passwordTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    _passwordTextField.placeholder = @"输入新密码";
    [_passwordTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:_passwordTextField];
    
    _repeatTextField = [[UITextField alloc] initWithFrame:CGRectMake(20, 74, UI_SCREEN_WIDTH-30, 44)];
   // _repeatTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    _repeatTextField.placeholder = @"确认新密码";
    [_repeatTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _repeatTextField.secureTextEntry = YES;
    _repeatTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _repeatTextField.font = [UIFont systemFontOfSize:15];
    [_repeatTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [backgroundView addSubview:_repeatTextField];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(10, 128, UI_SCREEN_WIDTH-20, 40);
    finishButton.layer.masksToBounds = YES;
    finishButton.layer.cornerRadius = 4.0;
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [finishButton setBackgroundColor:ICON_COLOR];
    [finishButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:finishButton];
}

- (void)controlClicked
{
    [_passwordTextField resignFirstResponder];
    [_repeatTextField resignFirstResponder];
}

- (void)buttonClicked:(UIButton *)button
{
    [_passwordTextField resignFirstResponder];
    [_repeatTextField resignFirstResponder];
    
    if (STRING_NOT_EMPTY(_passwordTextField.text) && STRING_NOT_EMPTY(_repeatTextField.text))
    {
        if ([_passwordTextField.text isEqualToString:_repeatTextField.text])
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                           _phone,@"login",
                                           _regCode,@"code",
                                           _passwordTextField.text,@"pwd",
                                           nil];
            [self showHudInView:self.view showHint:@"修改中..."];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [Api requestWithMethod:@"GET" withPath:API_UIL_SAVEUSERPW withParams:params withSuccess:^(id responseObject){
                    if ([[responseObject objectForKey:@"status"] intValue] == 1)
                    {
                        [self hideHud];
                        [self showHudInView:self.view showHint:@"修改成功"];
                    }
                    else
                    {
                        [self hideHud];
                        [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        sleep(1);
                        [self.navigationController popToRootViewControllerAnimated:YES];
                    });
                } withError:^(NSError *error){
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"请检查网络设置"];
                }];
            });
        }
        else
        {
            [self showHudInView:self.view showHint:@"两次输入的密码不一致"];
        }
    }
    else
    {
        [self showHudInView:self.view showHint:@"新密码不能为空"];
    }
}

//限制15字符
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 15)
    {
        textField.text = [textField.text substringToIndex:15];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
