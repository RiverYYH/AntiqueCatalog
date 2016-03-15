//
//  RegisterDetailViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/8.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#define lineRGB RGBA(209,209,209)
#define othertitle RGBA(153, 153, 153)

#import "RegisterDetailViewController.h"
//#import "RegisterCompleteViewController.h"
#import "AFHTTPRequestOperation.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
//#import "ChooseLikeViewController.h"
//#import "SeleteInterestViewController.h"
#import "GDataXMLNode.h"

@interface RegisterDetailViewController ()<UITextFieldDelegate>
{
    UIView *_backgroundView;
    UIView *_customView;
    UIView *_areaView;
    
    UITextField *_nameTextField;
    UITextField *_passwordTextField;
    UITextField *_invitationTextField;
    UIButton *_showPasswordBtn;
    
    UIButton *_cameraButton;
    UIImageView *_cameraImageView;
    UIButton *_likeButton;
    
    UIButton *_maleButton;
    UIButton *_femaleButton;
    
    UILabel *_areaLabel;
    UILabel *_likeLabel;
    
    NSString *_phone;
    NSString *_regCode;
    
    NSDictionary *_response;
    
    NSMutableArray *_selectedLikeArray;
    NSMutableString *_likeString;
    
    NSDictionary *_areaDictionary;
    NSArray *_areaKeyArray;
    NSString *_areaString1;
    UITextField *_textField;
    NSString *_areaString2;
    
    UIPickerView * _pickerView;
}
@end

@implementation RegisterDetailViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPhone:(NSString *)phone andRegCode:(NSString *)regCode andDic:(NSDictionary *)dic andType:(zhuceType)type
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _phone = phone;
        _regCode = regCode;
        _zhuceType = type;
        _dic = dic;
        //        NSLog(@"%@",_dic);
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didFinishLike:) name:@"LIKESELECTED" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"LIKESELECTED" object:nil];
}
//接受修改兴趣的广播
- (void)didFinishLike:(NSNotification *)notification
{
    [_likeString setString:@""];
//    [_selectedLikeArray addObjectsFromArray:[notification.userInfo objectForKey:@"selected"]];
//    for (int i=0; i < [_selectedLikeArray count]; i++)
//    {
//        [_likeString appendFormat:@"%@，",[[_selectedLikeArray objectAtIndex:i] objectForKey:@"title"]];
//    }
    NSArray *array = [notification.userInfo allKeys];
    for(int i=0; i<array.count; i++) {
        [_likeString appendFormat:@"%@,",[notification.userInfo objectForKey:[NSString stringWithFormat:@"%d",i]]];
    }
    if(array.count <= 3) {
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:14];
    } else {
        _likeButton.titleLabel.font = [UIFont systemFontOfSize:12];
    }
    [_likeButton setTitle:_likeString forState:UIControlStateNormal];
    _likeLabel.text = @"已选择";
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    bgImageView.image = [UIImage imageNamed:@"Login_bgImage"];
    [self.view addSubview:bgImageView];
    [self.titleImageView removeFromSuperview];
    
    self.titleLabel.text = @"注册";
    self.titleLabel.font = [UIFont systemFontOfSize:16];
    self.titleLabel.textColor = White_Color;
    self.titleImageView.backgroundColor = RGBA(43, 43, 43);
    [self.view addSubview:self.titleImageView];
    
    _areaString1 = @"";
    _areaString2 = @"";
    _likeString = [NSMutableString string];
    _response = [NSDictionary dictionary];
    _selectedLikeArray = [NSMutableArray array];
    _areaDictionary = [NSDictionary dictionary];
    _areaKeyArray = [NSArray array];
    
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKeyPath:@"registerSex"];
    
    _backgroundView = [[UIView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME];
    [self.view addSubview:_backgroundView];
    
    UIControl *control = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT)];
    [control addTarget:self action:@selector(controlClicked) forControlEvents:UIControlEventTouchUpInside];
    [_backgroundView addSubview:control];
    
    _cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _cameraButton.frame = CGRectMake(UI_SCREEN_WIDTH/2-30, 30, 60, 60);
    [_cameraButton setImage:[UIImage imageNamed:@"Login_headImage"] forState:UIControlStateNormal];
    _cameraButton.layer.cornerRadius = 30;
    _cameraButton.clipsToBounds = YES;
    [_cameraButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    _cameraButton.tag = 101;
    [_backgroundView addSubview:_cameraButton];
    
    _cameraImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Login_chuantouxiang"]];
    
    UILabel *photoLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-40, CGRectGetMaxY(_cameraButton.frame) + 10, 80, 30)];
    photoLabel.text = @"设置头像";
    photoLabel.font = [UIFont systemFontOfSize:14];
    photoLabel.textAlignment = NSTextAlignmentCenter;
    photoLabel.textColor = othertitle;
    [_backgroundView addSubview:photoLabel];
    
//    UIView *inputView = [[UIView alloc] initWithFrame:CGRectMake(10, 140, UI_SCREEN_WIDTH-20, 88)];
//    inputView.backgroundColor = [UIColor whiteColor];
//    inputView.userInteractionEnabled = YES;
//    inputView.layer.cornerRadius = 5;
//    inputView.clipsToBounds = YES;
//    [_backgroundView addSubview:inputView];
    
    _nameTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(photoLabel.frame) + 20, UI_SCREEN_WIDTH-20, 35)];
    _nameTextField.keyboardType = UIKeyboardTypeDefault;
    _nameTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭首字母大写
    _nameTextField.autocorrectionType = UITextAutocorrectionTypeNo;//关闭自动联想
    _nameTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _nameTextField.textAlignment = NSTextAlignmentCenter;
    _nameTextField.placeholder = @"请设置用户名";
    [_nameTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _nameTextField.font = [UIFont systemFontOfSize:15];
    _nameTextField.layer.cornerRadius = 17;
    [_nameTextField.layer setBorderWidth:0.5];
    [_nameTextField.layer setBorderColor:lineRGB.CGColor];
    [_backgroundView addSubview:_nameTextField];
    
    _passwordTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_nameTextField.frame) + 10, UI_SCREEN_WIDTH-20, 35)];
    //_passwordTextField.keyboardType = UIKeyboardTypeNamePhonePad;
    _passwordTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _passwordTextField.autocorrectionType = UITextAutocorrectionTypeNo;
    _passwordTextField.secureTextEntry = YES;
    _passwordTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _passwordTextField.textAlignment = NSTextAlignmentCenter;
    _passwordTextField.placeholder = @"请设置密码";
    [_passwordTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _passwordTextField.font = [UIFont systemFontOfSize:15];
    [_passwordTextField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    _passwordTextField.layer.cornerRadius = 17;
    [_passwordTextField.layer setBorderWidth:0.5];
    [_passwordTextField.layer setBorderColor:lineRGB.CGColor];
    [_backgroundView addSubview:_passwordTextField];
    
//    UIImageView *accountImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
//    accountImageView.image = [UIImage imageNamed:@"Login_zhanghao"];
//    [inputView addSubview:accountImageView];
    
//    UIImageView *passwordImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 54, 25, 25)];
//    passwordImageView.image = [UIImage imageNamed:@"Login_mima"];
//    [inputView addSubview:passwordImageView];
    
//    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 45, UI_SCREEN_WIDTH-20, 0.5)];
//    lineImageView.backgroundColor = [UIColor grayColor];
//    [inputView addSubview:lineImageView];
    
//    _showPasswordBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    _showPasswordBtn.frame = CGRectMake(UI_SCREEN_WIDTH-54, 60, 25, 15);
//    [_showPasswordBtn setImage:[UIImage imageNamed:@"Login_noshowpd"] forState:UIControlStateNormal];
//    [_showPasswordBtn addTarget:self action:@selector(showPassWordBtnClicked) forControlEvents:UIControlEventTouchUpInside];
//    [inputView addSubview:_showPasswordBtn];
    
//    UILabel *sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 165+45, 40, 44)];
//    sexLabel.text = @"性别";
//    sexLabel.font = [UIFont systemFontOfSize:16];
//    sexLabel.textAlignment = NSTextAlignmentCenter;
//    sexLabel.textColor = TITLE_COLOR;
//    [_backgroundView addSubview:sexLabel];
//    
//    _maleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _maleButton.frame = CGRectMake(60, CGRectGetMaxY(middleLineImageView.frame)+8.5, 70, 27);
//    _maleButton.layer.masksToBounds = YES;
//    _maleButton.layer.cornerRadius = 4.0;
//    [_maleButton setBackgroundImage:[UIImage imageNamed:@"Login_nan_selected"] forState:UIControlStateNormal];
//    [_maleButton addTarget:self action:@selector(maleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [_backgroundView addSubview:_maleButton];
//    
//    _femaleButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _femaleButton.frame = CGRectMake(160, CGRectGetMaxY(middleLineImageView.frame)+8.5, 70, 27);
//    _femaleButton.layer.masksToBounds = YES;
//    _femaleButton.layer.cornerRadius = 4.0;
//    [_femaleButton setBackgroundImage:[UIImage imageNamed:@"Login_nv"] forState:UIControlStateNormal];
//    [_femaleButton addTarget:self action:@selector(femaleButtonClicked) forControlEvents:UIControlEventTouchUpInside];
//    [_backgroundView addSubview:_femaleButton];
    
//    UIView *downBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 219+45, UI_SCREEN_WIDTH, 89)];
//    downBackView.backgroundColor = [UIColor whiteColor];
//    [_backgroundView addSubview:downBackView];
//    
//    UIButton *areaButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    areaButton.frame = CGRectMake(0, 219+45, UI_SCREEN_WIDTH, 44);
//    [areaButton setBackgroundColor:[UIColor whiteColor]];
//    [areaButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    areaButton.tag = 102;
//    [_backgroundView addSubview:areaButton];
    
//    _likeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _likeButton.frame = CGRectMake(10, 250, UI_SCREEN_WIDTH-20, 44);
//    _likeButton.layer.cornerRadius = 5;
//    _likeButton.clipsToBounds = YES;
//    [_likeButton setTitle:@"请选择兴趣" forState:UIControlStateNormal];
//    [_likeButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
//    [_likeButton setImage:[UIImage imageNamed:@"jiantou"] forState:UIControlStateNormal];
//    [_likeButton setBackgroundColor:[UIColor whiteColor]];
//    [_likeButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
//    [_likeButton setImageEdgeInsets:UIEdgeInsetsMake(0, UI_SCREEN_WIDTH-40, 0, 0)];
//    [_likeButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 0)];
//    _likeButton.titleLabel.font = [UIFont systemFontOfSize:15];
//    _likeButton.tag = 103;
//    [_backgroundView addSubview:_likeButton];
    
    
//    _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 219+45, 80, 44)];
//    _areaLabel.text = @"选择地区";
//    _areaLabel.font = [UIFont systemFontOfSize:16];
//    _areaLabel.textAlignment = NSTextAlignmentCenter;
//    _areaLabel.textColor = TITLE_COLOR;
//    [_backgroundView addSubview:_areaLabel];
//    
//    _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 264+45, 80, 44)];
//    _likeLabel.text = @"选择兴趣";
//    _likeLabel.font = [UIFont systemFontOfSize:16];
//    _likeLabel.textAlignment = NSTextAlignmentCenter;
//    _likeLabel.textColor = TITLE_COLOR;
//    [_backgroundView addSubview:_likeLabel];
//    
//    _areaLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-203, 219+45, 170, 44)];
//    _areaLabel.text = @"选择地区";
//    _areaLabel.font = [UIFont systemFontOfSize:15];
//    _areaLabel.textAlignment = NSTextAlignmentRight;
//    _areaLabel.textColor = CONTENT_COLOR;
//    [_backgroundView addSubview:_areaLabel];
//    
//    _likeLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-203, 264+45, 170, 44)];
//    _likeLabel.text = @"选择兴趣";
//    _likeLabel.font = [UIFont systemFontOfSize:15];
//    _likeLabel.textAlignment = NSTextAlignmentRight;
//    _likeLabel.textColor = CONTENT_COLOR;
//    [_backgroundView addSubview:_likeLabel];
//    
//    UIImageView *areaImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-23, 15.5, 8, 13)];
//    areaImageView.image = [UIImage imageNamed:@"jiantou"];
//    [areaButton addSubview:areaImageView];
//    
//    UIImageView *likeImageView = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-23, 15.5, 8, 13)];
//    likeImageView.image = [UIImage imageNamed:@"jiantou"];
//    [likeButton addSubview:likeImageView];
//    
//    UIImageView *downLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 263+45, UI_SCREEN_WIDTH-20, 0.5)];
//    downLineImageView.backgroundColor = LINE_COLOR;
//    [_backgroundView addSubview:downLineImageView];
    
//    //邀请人
//    UILabel *invitationLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 354, 60, 44)];
//    invitationLabel.text = @"邀请人";
//    invitationLabel.font = [UIFont systemFontOfSize:16];
//    invitationLabel.textAlignment = NSTextAlignmentCenter;
//    invitationLabel.textColor = TITLE_COLOR;
//    [_backgroundView addSubview:invitationLabel];
//    
//    _invitationTextField = [[UITextField alloc] initWithFrame:CGRectMake(80, 354, UI_SCREEN_WIDTH-90, 44)];
//    _invitationTextField.keyboardType = UIKeyboardTypeDefault;
//    _invitationTextField.autocapitalizationType = UITextAutocapitalizationTypeNone;//关闭首字母大写
//    _invitationTextField.autocorrectionType = UITextAutocorrectionTypeNo;//关闭自动联想
//    _invitationTextField.clearButtonMode = UITextFieldViewModeWhileEditing;;
//    _invitationTextField.placeholder = @"选填";
//    [_invitationTextField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
//    _invitationTextField.font = [UIFont systemFontOfSize:15];
//    [_backgroundView addSubview:_invitationTextField];
//    _invitationTextField.delegate = self;
//    
//    UIImageView *bottomLineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 353, UI_SCREEN_WIDTH-20, 0.5)];
//    bottomLineImageView.backgroundColor = LINE_COLOR;
//    [_backgroundView addSubview:bottomLineImageView];
//    
//    UIImageView *bottom1LineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 400, UI_SCREEN_WIDTH-20, 0.5)];
//    bottom1LineImageView.backgroundColor = LINE_COLOR;
//    [_backgroundView addSubview:bottom1LineImageView];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(10, 260, UI_SCREEN_WIDTH-20, 35);
    finishButton.layer.masksToBounds = YES;
    finishButton.layer.cornerRadius = 17.0;
    [finishButton setTitle:@"完成" forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [finishButton setBackgroundImage:[UIImage imageNamed:@"Login_login"] forState:UIControlStateNormal];
    [finishButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    finishButton.tag = 104;
    [_backgroundView addSubview:finishButton];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    CGFloat offset = self.view.frame.size.height - (_invitationTextField.frame.origin.y + _invitationTextField.frame.size.height + 216 + 170);
    if (offset <= 0) {
        [UIView animateWithDuration:0.3 animations:^{
            CGRect frame = self.view.frame;
            frame.origin.y = offset;
            self.view.frame = frame;
        }];
    }
    return YES;
}

-(BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [UIView animateWithDuration:0.3 animations:^{
        CGRect frame = self.view.frame;
        frame.origin.y = 0.0;
        self.view.frame = frame;
    }];
    
    return YES;
}

- (void)showPassWordBtnClicked
{
    if(_passwordTextField.secureTextEntry) {
        [_showPasswordBtn setImage:[UIImage imageNamed:@"Login_showpd"] forState:UIControlStateNormal];
        _passwordTextField.secureTextEntry = NO;
    } else {
        [_showPasswordBtn setImage:[UIImage imageNamed:@"Login_noshowpd"] forState:UIControlStateNormal];
        _passwordTextField.secureTextEntry = YES;
    }
}

- (void)controlClicked
{
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_invitationTextField resignFirstResponder];
}

- (void)maleButtonClicked
{
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_invitationTextField resignFirstResponder];
    
    [_maleButton setBackgroundImage:[UIImage imageNamed:@"Login_nan_selected"] forState:UIControlStateNormal];
    [_femaleButton setBackgroundImage:[UIImage imageNamed:@"Login_nv"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setValue:@"1" forKeyPath:@"registerSex"];
}

- (void)femaleButtonClicked
{
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_invitationTextField resignFirstResponder];
    
    [_maleButton setBackgroundImage:[UIImage imageNamed:@"Login_nan"] forState:UIControlStateNormal];
    [_femaleButton setBackgroundImage:[UIImage imageNamed:@"Login_nv_selected"] forState:UIControlStateNormal];
    [[NSUserDefaults standardUserDefaults] setValue:@"2" forKeyPath:@"registerSex"];
}

- (void)buttonClicked:(UIButton *)button
{
    [_nameTextField resignFirstResponder];
    [_passwordTextField resignFirstResponder];
    [_invitationTextField resignFirstResponder];
    
    switch (button.tag)
    {
        case 101:
        {
            if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
            {
                [LPActionSheetView showInView:self.view title:@"选择图片" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"相册"] tagNumber:1];
            }
            else
            {
                [LPActionSheetView showInView:self.view title:@"选择图片" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"相册"] tagNumber:1];
            }
        }
            break;
        case 102:
        {
            //地区
//            [LPActionSheetView showInView:self.view title:@"请选择国内/海外" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"国内",@"海外"] tagNumber:2];
            [self loadNewData];
        }
            break;
        case 103:
        {
//            ChooseLikeViewController *chooseLikeVC = [[ChooseLikeViewController alloc] init];
//            [self presentViewController:chooseLikeVC animated:YES completion:nil];
            //SeleteInterestViewController *seleteInterestVC = [[SeleteInterestViewController alloc] init];
            //seleteInterestVC.userDic = nil;
            //[self.navigationController pushViewController:seleteInterestVC animated:YES];
        }
            break;
        case 104:
        {
            if (STRING_NOT_EMPTY(_nameTextField.text) && STRING_NOT_EMPTY(_passwordTextField.text))
            {
                if ([_cameraImageView.image isEqual:[UIImage imageNamed:@"Login_chuantouxiang"]])
                {
                    [self showHudInView:self.view showHint:@"请上传用户头像"];
                }
                else
                {
                    if (!STRING_NOT_EMPTY(_likeString))
                    {
                        if (_passwordTextField.text.length >= 6)
                        {
                            NSLog(@"%@--%@",_areaString1,_areaString2);
                            //注意此处图片的宽高为服务器返回的数字类型,要转为NSString上传
                            NSMutableDictionary *params = [NSMutableDictionary dictionary];
                            NSString *urlString;
                            if (_zhuceType == Phone) {
                                urlString = API_UIL_REGISTER;
                                params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [[_response objectForKey:@"data"] objectForKey:@"picurl"],@"avatar_url",
                                          [[[_response objectForKey:@"data"] objectForKey:@"picwidth"] stringValue],@"avatar_width",
                                          [[[_response objectForKey:@"data"] objectForKey:@"picheight"] stringValue],@"avatar_height",
                                          _phone,@"phone",
                                          _regCode,@"regCode",
                                          _nameTextField.text,@"uname",
                                          _passwordTextField.text,@"password",
                                          [[NSUserDefaults standardUserDefaults] valueForKey:@"registerSex"],@"sex",
                                          _areaString1,@"city",
                                          _areaString2,@"input_city",
                                          _likeString,@"category",@"",@"invite",
                                          nil];
                                
                            }else if (_zhuceType == DiSanFang)
                            {
                                urlString = API_UIL_DISanFang_REGISTER;
                                params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                          [[_response objectForKey:@"data"] objectForKey:@"picurl"],@"avatar_url",
                                          [[[_response objectForKey:@"data"] objectForKey:@"picwidth"] stringValue],@"avatar_width",
                                          [[[_response objectForKey:@"data"] objectForKey:@"picheight"] stringValue],@"avatar_height",
                                          
                                          _nameTextField.text,@"uname",
                                          _passwordTextField.text,@"password",
                                          [[NSUserDefaults standardUserDefaults] valueForKey:@"registerSex"],@"sex",
                                          _areaString1,@"city",
                                          _areaString2,@"input_city",
                                          _likeString,@"category",@"", @"invite",
                                          [_dic objectForKey:@"type"],@"type",
                                          [_dic objectForKey:@"type_uid"],@"type_uid",
                                          [_dic objectForKey:@"access_token"],@"access_token",
                                          nil];
                                //                                NSLog(@"%@",params);
                            }
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                                [self showHudInView:self.view hint:@"注册中"];
                                [Api requestWithMethod:@"POST" withPath:urlString withParams:params withSuccess:^(id responseObject){
                                    NSLog(@"----%@",responseObject);
                                    if (_zhuceType == Phone) {
                                        if ([[responseObject objectForKey:@"status"] intValue] == 1){
                                            
                                            [UserModel saveUserPassportWithUname:_nameTextField.text andUid:[[responseObject objectForKey:@"token"] objectForKey:@"uid"] andToken:[[responseObject objectForKey:@"token"] objectForKey:@"oauth_token"] andTokenSecret:[[responseObject objectForKey:@"token"] objectForKey:@"oauth_token_secret"] andAvatar:[responseObject objectForKey:@"avatar_middle"]];
                                            [self hideHud];
                                            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"loaduserinfo" object:nil];
                                            [self.navigationController popViewControllerAnimated:YES];
                                            
                                        }else{
                                            
                                            [self hideHud];
                                            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                                        }
                                        
                                    }else if (_zhuceType == DiSanFang){
                                        if ([[responseObject objectForKey:@"status"] intValue] == 0 && [responseObject objectForKey:@"status"]
                                            !=nil)
                                        {
                                            [self hideHud];
                                            [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                                        }
                                        else
                                        {
                                            [UserModel saveUserLoginType:[_dic objectForKey:@"type"]];
                                            [UserModel saveUserPassportWithUname:_nameTextField.text andUid:[responseObject  objectForKey:@"uid"] andToken:[responseObject  objectForKey:@"oauth_token"] andTokenSecret:[responseObject  objectForKey:@"oauth_token_secret"] andAvatar:[responseObject objectForKey:@"avatar_middle"]];
                                            [self hideHud];
                                            [[NSNotificationCenter defaultCenter]postNotificationName:@"loaduserinfo" object:nil];
                                            [self.navigationController popToRootViewControllerAnimated:YES];

                                        }
                                        
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
                            [self showHudInView:self.view showHint:@"密码不能小于6个字符"];
                        }
                    }
                    else
                    {
                        [self showHudInView:self.view showHint:@"请选择兴趣"];
                    }
                }
            }
            else
            {
                [self showHudInView:self.view showHint:@"昵称/密码不能为空"];
            }
        }
            break;
        default:
            break;
    }
}
//获取地区信息

- (void)loadNewData
{
//    [self showHudInView:self.view hint:@"加载中"];
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [Api requestWithMethod:@"GET" withPath:API_URL_Area withParams:nil withSuccess:^(id responseObject){
//            NSLog(@"%@",responseObject);
//            _areaDictionary = responseObject;
//            dispatch_async(dispatch_get_main_queue(), ^{
//                [self prepareUIWithData:responseObject];
//                [self hideHud];
//            });
//        } withError:^(NSError *error){
//            [self hideHud];
//            [self showHudInView:self.view showHint:@"请检查网络设置"];
//        }];
//    });
    NSString *path = [[NSBundle mainBundle] pathForResource:@"region" ofType:@"xml"];
    NSString *xmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    GDataXMLDocument *doc = [[GDataXMLDocument alloc] initWithXMLString:xmlString encoding:NSUTF8StringEncoding error:nil];
    GDataXMLElement *root = [doc rootElement];
    NSArray *provinceArray = [root elementsForName:@"province"];
    NSMutableDictionary *proDict = [[NSMutableDictionary alloc] init];
    for(GDataXMLElement *pro in provinceArray) {
        NSMutableDictionary *proDic = [[NSMutableDictionary alloc] init];
        NSArray *proAtt = pro.attributes;
        GDataXMLElement *proIdString = proAtt[0];
        GDataXMLElement *proAtt1= proAtt[1];
        [proDic setObject:proIdString.stringValue forKey:@"id"];
        [proDic setObject:proAtt1.stringValue forKey:@"title"];
        NSArray *cityArray = [pro elementsForName:@"city"];
        if(cityArray.count) {
            NSMutableDictionary *cityDict = [[NSMutableDictionary alloc] init];
            for(GDataXMLElement *city in cityArray) {
                NSMutableDictionary *cityDic = [[NSMutableDictionary alloc] init];
                NSArray *cityAtt = city.attributes;
                GDataXMLElement *cityIdString = cityAtt[0];
                GDataXMLElement *cityAtt1 = cityAtt[1];
                [cityDic setObject:cityIdString.stringValue forKey:@"id"];
                [cityDic setObject:cityAtt1.stringValue forKey:@"title"];
                NSArray *areaArray = [city elementsForName:@"area"];
                if (areaArray.count) {
                    NSMutableDictionary *areaDict = [[NSMutableDictionary alloc] init];
                    for(GDataXMLElement *area in areaArray) {
                        NSMutableDictionary *areaDic = [[NSMutableDictionary alloc] init];
                        NSArray *areaAtt = area.attributes;
                        GDataXMLElement *areaIdString = areaAtt[0];
                        GDataXMLElement *areaAtt1 = areaAtt[1];
                        [areaDic setObject:areaIdString.stringValue forKey:@"id"];
                        [areaDic setObject:areaAtt1.stringValue forKey:@"title"];
                        [areaDic setObject:[NSNull null] forKey:@"child"];
                        [areaDict setObject:areaDic forKey:areaIdString.stringValue];
                    }
                    [cityDic setObject:areaDict forKey:@"child"];
                } else {
                    [cityDic setObject:[NSNull null] forKey:@"child"];
                }
                [cityDict setObject:cityDic forKey:cityIdString.stringValue];
            }
            [proDic setObject:cityDict forKey:@"child"];
        } else {
            [proDic setObject:[NSNull null] forKey:@"child"];
        }
        [proDict setObject:proDic forKey:proIdString.stringValue];
    }
    _areaDictionary = proDict;
    [self prepareUIWithData:proDict];
}
//展示地区信息
- (void)prepareUIWithData:(NSDictionary *)responseObject
{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT-246, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT);
    }];
    
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _customView.backgroundColor = [UIColor blackColor];
    _customView.alpha = 0.4;
    [self.view addSubview:_customView];
    
    UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-246, UI_SCREEN_WIDTH, 246)];
    areaView.backgroundColor = [UIColor whiteColor];
    [_customView addSubview:areaView];
    
    _areaKeyArray = [responseObject allKeys];
    _areaKeyArray = [_areaKeyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
        NSComparisonResult result = [obj1 compare:obj2];
        return result==NSOrderedDescending;
    }];
    
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-216, UI_SCREEN_WIDTH, 216)];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self.view addSubview:_pickerView];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(UI_SCREEN_WIDTH-50, 0, 50, 30);
    [customButton setTitle:@"确定" forState:UIControlStateNormal];
    [customButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(customButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [areaView addSubview:customButton];
}

- (void)customButtonClicked
{
    NSInteger selectedRow0 = [_pickerView selectedRowInComponent:0];
    NSInteger selectedRow1 = [_pickerView selectedRowInComponent:1];
    NSInteger selectedRow2 = [_pickerView selectedRowInComponent:2];
    NSString *oneString = [[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"id"];
    
    NSString *twoString = [NSString string];
    NSArray * arr1 = [NSArray array];
    if (![[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] isKindOfClass:[NSNull class]])
    {
        arr1 = [[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] allKeys];
        arr1 = [arr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
        twoString = [[[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] objectForKey:[arr1 objectAtIndex:selectedRow1]] objectForKey:@"id"];
    }
    else
    {
        twoString = @"";
    }
    
    NSString *threeString = [NSString string];
    NSArray * arr2 = [NSArray array];
    if (![[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] isKindOfClass:[NSNull class]])
    {
        if (![[[[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] objectForKey:[arr1 objectAtIndex:selectedRow1]] objectForKey:@"child"] isKindOfClass:[NSNull class]])
        {
            arr2 = [[[[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] objectForKey:[arr1 objectAtIndex:selectedRow1]] objectForKey:@"child"] allKeys];
            arr2 = [arr2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
                NSComparisonResult result = [obj1 compare:obj2];
                return result==NSOrderedDescending;
            }];
            threeString = [[[[[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] objectForKey:[arr1 objectAtIndex:selectedRow1]] objectForKey:@"child"] objectForKey:[arr2 objectAtIndex:selectedRow2]] objectForKey:@"id"];
        }
        else
        {
            threeString = @"";
        }
    }
    else
    {
        threeString = @"";
    }
    
    
    _areaString1 = [NSString stringWithFormat:@"%@,%@,%@",oneString,twoString,threeString];
    _areaString2 = @"";
    
    [_customView removeFromSuperview];
    [_pickerView removeFromSuperview];
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.frame = UI_MAIN_SCREEN_FRAME;
    }];
    _areaLabel.text = @"已选择";
}
- (void)prepareUIWithGuoWai
{
    [UIView animateWithDuration:0.3 animations:^{
        _backgroundView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT-300, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT);
    }];
    
    _areaView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _areaView.backgroundColor = [UIColor blackColor];
    _areaView.alpha = 0.4;
    [self.view addSubview:_areaView];
    
    UIView *areaView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-300, UI_SCREEN_WIDTH, 300)];
    areaView.backgroundColor = [UIColor whiteColor];
    [_areaView addSubview:areaView];
    
    _textField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH-70, 30)];
    _textField.layer.borderWidth = 1.0;
    _textField.layer.borderColor = CONTENT_COLOR.CGColor;
    _textField.placeholder = @"必填";
    [areaView addSubview:_textField];
    
    UIButton *customButton = [UIButton buttonWithType:UIButtonTypeCustom];
    customButton.frame = CGRectMake(UI_SCREEN_WIDTH-50, 10, 50, 30);
    [customButton setTitle:@"确定" forState:UIControlStateNormal];
    [customButton setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [customButton addTarget:self action:@selector(guowaiCustomButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [areaView addSubview:customButton];
    
    [_textField becomeFirstResponder];
}
- (void)guowaiCustomButtonClicked
{
    [_textField resignFirstResponder];
    
    if (!STRING_NOT_EMPTY(_textField.text))
    {
        [self showHudInView:self.view showHint:@"请输入地区"];
    }
    else
    {
        [_areaView removeFromSuperview];
        [UIView animateWithDuration:0.3 animations:^{
            _backgroundView.frame = UI_MAIN_SCREEN_FRAME;
        }];
        _areaLabel.text = @"已选择";
        _areaString2 = _textField.text;
        _areaString1 = @"";
    }
}
#pragma mark - UIPickerViewDataSource
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0)
    {
        return [_areaKeyArray count];
    }
    else if (component == 1)
    {
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSDictionary * Item = [_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow]];
        if (![[Item objectForKey:@"child"] isKindOfClass:[NSNull class]])
        {
            return [[[Item objectForKey:@"child"] allKeys] count];
        }
        else
        {
            return 0;
        }
    }
    else
    {
        NSInteger selectedRow0 = [pickerView selectedRowInComponent:0];
        NSInteger selectedRow1 = [pickerView selectedRowInComponent:1];
        NSArray * arr1 = [[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] allKeys];
        arr1 = [arr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
        NSDictionary * Item = [[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] objectForKey:[arr1 objectAtIndex:selectedRow1]];
        if (![[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] isKindOfClass:[NSNull class]])
        {
            if (![[Item objectForKey:@"child"] isKindOfClass:[NSNull class]])
            {
                return [[[Item objectForKey:@"child"] allKeys] count];
            }
            else
            {
                return 0;
            }
        }
        else
        {
            return 0;
        }
    }
}
- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (component == 0)
    {
        NSString * State = [[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:row]] objectForKey:@"title"];
        return State;
    }
    else if (component == 1)
    {
        NSInteger selectedRow = [pickerView selectedRowInComponent:0];
        NSDictionary * Item = [[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow]] objectForKey:@"child"];
        NSArray * arr1 = [Item allKeys];
        arr1 = [arr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
        NSString * State = [[Item objectForKey:[arr1 objectAtIndex:row]] objectForKey:@"title"];
        return State;
    }
    else
    {
        NSInteger selectedRow0 = [pickerView selectedRowInComponent:0];
        NSInteger selectedRow1 = [pickerView selectedRowInComponent:1];
        NSArray * arr1 = [[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] allKeys];
        arr1 = [arr1 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
        NSDictionary * Item = [[[[_areaDictionary objectForKey:[_areaKeyArray objectAtIndex:selectedRow0]] objectForKey:@"child"] objectForKey:[arr1 objectAtIndex:selectedRow1]] objectForKey:@"child"];
        NSArray * arr2 = [Item allKeys];
        arr2 = [arr2 sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2){
            NSComparisonResult result = [obj1 compare:obj2];
            return result==NSOrderedDescending;
        }];
        NSString * State = [[Item objectForKey:[arr2 objectAtIndex:row]] objectForKey:@"title"];
        return State;
    }
}
#pragma mark - UIPickerViewDelegate
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (component == 0)
    {
        [pickerView reloadComponent:1];
        [pickerView selectRow:0 inComponent:1 animated:YES];
        
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else if (component == 1)
    {
        [pickerView reloadComponent:2];
        [pickerView selectRow:0 inComponent:2 animated:YES];
    }
    else
    {
    }
}

#pragma mark - LPActionSheetViewDelegate
- (void)actionSheet:(LPActionSheetView *)actionSheetView clickedOnButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheetView.tag == 1)
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    [self takePhoto];
                }
                    break;
                case 1:
                {
                    [self selectPhoto];
                }
                    break;
                    
                default:
                    break;
            }
        }
        else
        {
            [self selectPhoto];
        }
    }
    else if (actionSheetView.tag == 2)
    {
        switch (buttonIndex)
        {
            case 0:
            {
                [self loadNewData];
            }
                break;
            case 1:
            {
                [self prepareUIWithGuoWai];
            }
                break;
                
            default:
                break;
        }
    }
}

- (void)takePhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypeCamera];
        
        BOOL canTakePhoto = NO;
        for (NSString *mediaType in availableMediaTypes)
        {
            if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
            {
                canTakePhoto = YES;
                break;
            }
        }
        
        if (canTakePhoto)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
            picker.allowsEditing = YES;
            
            picker.delegate = self;
            
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [self showHudInView:self.view showHint:@"设备不支持静态图片"];
        }
    }
    else
    {
        [self showHudInView:self.view showHint:@"设备不支持相机模式"];
    }
}

- (void)selectPhoto
{
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        
        BOOL selectPhoto = NO;
        for (NSString *mediaType in availableMediaTypes)
        {
            if ([mediaType isEqualToString:(NSString *)kUTTypeImage])
            {
                selectPhoto = YES;
                break;
            }
        }
        
        if (selectPhoto)
        {
            UIImagePickerController *picker = [[UIImagePickerController alloc] init];
            picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            picker.mediaTypes = [[NSArray alloc] initWithObjects:(NSString *)kUTTypeImage, nil];
            picker.allowsEditing = YES;
            picker.delegate = self;
            [self presentViewController:picker animated:YES completion:nil];
        }
        else
        {
            [self showHudInView:self.view showHint:@"设备不支持静态图片"];
        }
    }
    else
    {
        [self showHudInView:self.view showHint:@"设备不支持相机模式"];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    
    if ([type isEqualToString:(NSString *)kUTTypeImage])
    {
        UIImage *editeImage = [info objectForKey:UIImagePickerControllerEditedImage];
		
		NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"11",@"name", nil];
		NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:API_UIL_REGISTERUPLOADAVATAR parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
			NSData *imageData= UIImageJPEGRepresentation(editeImage, 0.5);
			[formData appendPartWithFileData:imageData name:@"0" fileName:[NSString stringWithFormat:@"image%d.jpg",0] mimeType:@"image/jpeg"];
		} error:nil];
		
        [self showHudInView:self.view hint:@"上传中..."];
		AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
		[operation start];
		[operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            NSLog(@"%@",responseObject);
            NSLog(@"%@",response);
			if ([[response objectForKey:@"status"] intValue] == 1)
			{
				_response = response;
                [self hideHud];
				[self showHudInView:self.view showHint:@"上传成功"];
                
                NSString *string = [[response objectForKey:@"data"] objectForKey:@"fullpicurl"];
                string = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                [_cameraButton sd_setImageWithURL:[NSURL URLWithString:string] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"Login_chuantouxiang"]];
                [_cameraImageView sd_setImageWithURL:[NSURL URLWithString:string] placeholderImage:[UIImage imageNamed:@"Login_chuantouxiang"]];
			}
			else if ([[response objectForKey:@"status"] intValue] == 0)
			{
                [self hideHud];
				[self showHudInView:self.view showHint:@"上传失败"];
			}
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			[self hideHud];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
		}];
    }
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

//限制15字符
- (void)textFieldDidChange:(UITextField *)textField
{
    if (textField.text.length > 15)
    {
        textField.text = [textField.text substringToIndex:15];
    }
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
