//
//  OtherRegViewController.m
//  藏民网
//
//  Created by 刘鹏 on 15/1/22.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "OtherRegViewController.h"
#import "UserModel.h"
#import <ShareSDK/ShareSDK.h>
#import "RegisterCompleteViewController.h"

@interface OtherRegViewController ()
{
    NSDictionary *_param;
    UITextField *_oldField;
    UITextField *_newField;
}
@end

@implementation OtherRegViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andParam:(NSDictionary *)param
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _param = param;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"请完善资料";
    [self.rightButton setTitle:@"完成" forState:UIControlStateNormal];
    
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT+12, UI_SCREEN_WIDTH, 100)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
    for (int i = 0; i < 3; i ++)
    {
        UIView *line = [[UIView alloc]init];
        line.backgroundColor = LINE_COLOR;
        if (i == 1)
        {
            line.frame = CGRectMake(12, 50, 296, 0.5);
        }
        else if(i == 0)
        {
            line.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 0.5);
        }
        else
        {
            line.frame = CGRectMake(0, 99.5, UI_SCREEN_WIDTH, 0.5);
        }
        [bgView addSubview:line];
    }
    
    for (int i = 0; i < 2; i ++)
    {
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(24, 17+(50*i), 70, 16)];
        label.font = [UIFont systemFontOfSize:16.0];
        label.textColor = TITLE_COLOR;
        if (i == 0)
        {
            label.text = @"昵  称:";
        }
        else
        {
            label.text = @"新密码:";
        }
        [bgView addSubview:label];
    }
    
    _oldField = [[UITextField alloc]initWithFrame:CGRectMake(100, 10, 220, 30)];
    _oldField.placeholder = @"必填";
    _oldField.font = [UIFont systemFontOfSize:16.0];
    _oldField.textColor = CONTENT_COLOR;
    _oldField.delegate = self;
    _oldField.keyboardType = UIKeyboardTypeNamePhonePad;
    [_oldField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    [bgView addSubview:_oldField];
    
    _newField = [[UITextField alloc]initWithFrame:CGRectMake(100, 60, 220, 30)];
    _newField.placeholder = @"必填";
    _newField.font = [UIFont systemFontOfSize:16.0];
    _newField.textColor = CONTENT_COLOR;
    _newField.delegate = self;
    _newField.secureTextEntry = YES;
    //_newField.keyboardType = UIKeyboardTypeNamePhonePad;
    [_newField setValue:CONTENT_COLOR forKeyPath:@"_placeholderLabel.textColor"];
    _newField.font = [UIFont systemFontOfSize:16.0];
    [bgView addSubview:_newField];
}

-(void)rightButtonClick:(id)sender
{
    [_oldField resignFirstResponder];
    [_newField resignFirstResponder];

    NSString *oldStr = [_oldField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    NSString *newStr = [_newField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:_param];
    [param setObject:oldStr forKey:@"uname"];
    [param setObject:newStr forKey:@"password"];
    
    
    if (STRING_NOT_EMPTY(_oldField.text) && STRING_NOT_EMPTY(_newField.text))
    {
        [Api requestWithMethod:@"get" withPath:API_URL_Other_REG withParams:param withSuccess:^(id responseObject) {
//            NSLog(@"param2= %@====%@",param,responseObject);
            if ([[responseObject objectForKey:@"uid"] intValue])
            {
                [UserModel saveUserPassportWithUname:_oldField.text andUid:[responseObject objectForKey:@"uid"] andToken:[responseObject objectForKey:@"oauth_token"] andTokenSecret:[responseObject objectForKey:@"oauth_token_secret"] andAvatar:[responseObject objectForKey:@"avatar_middle"]];
                [self hideHud];
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                
                RegisterCompleteViewController *registerCompleteVC = [[RegisterCompleteViewController alloc] init];
                [self.navigationController pushViewController:registerCompleteVC animated:YES];
            }
            else
            {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        }withError:^(NSError *error) {
            [self hideHud];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    }
    else
    {
        [self showHudInView:self.view showHint:@"昵称/密码不能为空"];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end