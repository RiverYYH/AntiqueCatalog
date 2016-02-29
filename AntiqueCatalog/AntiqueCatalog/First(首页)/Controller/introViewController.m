//
//  introViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/28.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "introViewController.h"

@interface introViewController ()

@property (nonatomic,strong)UITextField *name;
@property (nonatomic,strong)UILabel *namecount;

@end

@implementation introViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"修改签名";
    [self.rightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:Blue_color forState:UIControlStateNormal];
    
    _name = [[UITextField alloc]initWithFrame:CGRectMake(16, 20+UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH - 55, 20)];
    _name.text = [[UserModel userUserInfor] objectForKey:@"intro"];
    [_name addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    _namecount = [Allview Withstring:[NSString stringWithFormat:@"%lu",30 - _name.text.length] Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Nav_title_font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _namecount.frame = CGRectMake(UI_SCREEN_WIDTH - 35, 20+UI_NAVIGATION_BAR_HEIGHT, 20, 20);
    
    
    UIImageView *line = [[UIImageView alloc]initWithFrame:CGRectMake(16, 40+UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH - 32, 1)];
    line.backgroundColor = Blue_color;
    
    [self.view addSubview:_namecount];
    [self.view addSubview:_name];
    [self.view addSubview:line];
    // Do any additional setup after loading the view.
}

- (void)rightButtonClick:(id)sender{
    NSString *nameStr = [_name.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    if ([nameStr isEqualToString:@""]) {
        return;
    }
    
    if ([nameStr isEqualToString:[[UserModel userUserInfor] objectForKey:@"intro"]]) {
        
        return;
    }
    
    
    [_name resignFirstResponder];
    
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:nameStr,@"intro", nil];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER_Modify withParams:param withSuccess:^(id responseObject) {
        
        if ([[responseObject objectForKey:@"status"]intValue]) {
            
            NSDictionary *dic = [UserModel userUserInfor];
            NSMutableDictionary *mutdic = [[NSMutableDictionary alloc]init];
            [mutdic setValue:[dic objectForKey:@"uname"] forKey:@"uname"];
            [mutdic setValue:[dic objectForKey:@"avatar"] forKey:@"avatar"];
            [mutdic setValue:_name.text forKey:@"intro"];
            [UserModel saveUserInformationWithdic:mutdic];
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"makeView2" object:nil];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"makeView" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
        
    } withError:^(NSError *error) {
        
    }];
}


-(void)textFieldDidChange:(UITextField *)textfield{
    
    
    
    if (textfield == _name) {
        if (textfield.text.length > 30) {
            textfield.text = [_name.text substringToIndex:30];
        }
    }
    NSInteger integer = textfield.text.length;
    
    _namecount.text = [NSString stringWithFormat:@"%ld",30 - integer];
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
