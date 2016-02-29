//
//  passwordViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/28.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "passwordViewController.h"

@interface passwordViewController ()

@property (nonatomic,strong)UITextField *oldField;
@property (nonatomic,strong)UITextField *newfield;


@end

@implementation passwordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"修改密码";
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:Blue_color forState:UIControlStateNormal];
    
    [self CreatUI];
    // Do any additional setup after loading the view.
}

- (void)CreatUI{
    
    _oldField = [[UITextField alloc] initWithFrame:CGRectMake(16, 20 + UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH-32, 30)];
    _oldField.keyboardType = UIKeyboardTypeDefault;
    _oldField.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _oldField.autocorrectionType = UITextAutocorrectionTypeNo;
    _oldField.secureTextEntry = YES;
    _oldField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _oldField.placeholder = @"请输入原密码";
    [_oldField setValue:Deputy_Colour forKeyPath:@"_placeholderLabel.textColor"];
    _oldField.textAlignment = NSTextAlignmentLeft;
    _oldField.font = [UIFont systemFontOfSize:15];
    [_oldField addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_oldField];
    
    UIImageView *lineImageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 50+ UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH-32, 1)];
    lineImageView.backgroundColor = Blue_color;
    [self.view addSubview:lineImageView];
    
    
    
    _newfield = [[UITextField alloc] initWithFrame:CGRectMake(16, 70+ UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH-32, 30)];
    _newfield.keyboardType = UIKeyboardTypeDefault;
    _newfield.autocapitalizationType = UITextAutocapitalizationTypeNone;
    _newfield.autocorrectionType = UITextAutocorrectionTypeNo;
    _newfield.secureTextEntry = YES;
    _newfield.clearButtonMode = UITextFieldViewModeWhileEditing;
    _newfield.placeholder = @"请输入新密码(6~15个字符)";
    [_newfield setValue:Deputy_Colour forKeyPath:@"_placeholderLabel.textColor"];
    _newfield.textAlignment = NSTextAlignmentLeft;
    _newfield.font = [UIFont systemFontOfSize:15];
    [_newfield addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:_newfield];
    
    UIImageView *lineImageView1 = [[UIImageView alloc] initWithFrame:CGRectMake(16, 100+ UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH-32, 1)];
    lineImageView1.backgroundColor = Blue_color;
    [self.view addSubview:lineImageView1];
    
    
}

- (void)rightButtonClick:(id)sender{
    
    [_oldField resignFirstResponder];
    [_newfield resignFirstResponder];
    
    if(_newfield.text.length < 6) {
        return;
    }
    
    if (STRING_NOT_EMPTY(_oldField.text) && STRING_NOT_EMPTY(_newfield.text))
    {
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:_oldField.text,@"old_password",_newfield.text,@"password", nil];
        
        [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER_Modify withParams:params withSuccess:^(id responseObject) {
            
            if ([[responseObject objectForKey:@"status"]intValue]) {
                
                [self.navigationController popViewControllerAnimated:YES];
            }
            
        } withError:^(NSError *error) {
            
        }];

        
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
