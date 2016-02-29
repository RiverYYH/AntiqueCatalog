//
//  UserinfoViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/28.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "UserinfoViewController.h"
#import "nameViewController.h"
#import "introViewController.h"
#import "passwordViewController.h"

@interface UserinfoViewController ()

@property (nonatomic,strong)UIView *viewimage;
@property (nonatomic,strong)UILabel *headimage;
@property (nonatomic,strong)UIImageView *image;

@property (nonatomic,strong)UIView *nameview;
@property (nonatomic,strong)UILabel *name;
@property (nonatomic,strong)UILabel *nametitle;

@property (nonatomic,strong)UIView  *introview;
@property (nonatomic,strong)UILabel  *intro;
@property (nonatomic,strong)UILabel  *introtitle;

@property (nonatomic,strong)UILabel  *password;

@end

@implementation UserinfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeView1:) name:@"makeView1" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(makeView2:) name:@"makeView2" object:nil];
    
    self.titleLabel.text = @"编辑资料";
    
    [self CreatUI];
    // Do any additional setup after loading the view.
}
- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"makeView1" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"makeView2" object:nil];
}

- (void)makeView1:(NSNotificationCenter *)obj{
    
    _nametitle.text = [[UserModel userUserInfor] objectForKey:@"uname"];
    
}
-(void)makeView2:(NSNotificationCenter *)obj{
    _introtitle.text = [[UserModel userUserInfor] objectForKey:@"intro"];
}

- (void)CreatUI{
    
    self.view.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _viewimage = [[UIView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT + 16, UI_SCREEN_WIDTH, 80)];
    _viewimage.backgroundColor = White_Color;
    _viewimage.userInteractionEnabled = YES;
    _viewimage.tag = 0;
    _headimage = [[UILabel alloc]initWithFrame:CGRectMake(16, 0,100, 80)];
    _headimage.text = @"头像";
    _headimage.textColor = Essential_Colour;
    _headimage.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
    _image = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 54, 16, 48, 48)];
    _image.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    if (STRING_NOT_EMPTY([[UserModel userUserInfor] objectForKey:@"avatar"])) {
        [_image sd_setImageWithURL:[NSURL URLWithString:[[UserModel userUserInfor] objectForKey:@"avatar"]]];
    }
    _image.layer.masksToBounds = YES;
    _image.layer.cornerRadius = 24;
    [self.view addSubview:_viewimage];
    [_viewimage addSubview:_headimage];
    [_viewimage addSubview:_image];
    
    
    
    _nameview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_viewimage.frame)+1, UI_SCREEN_WIDTH, 60)];
    _nameview.backgroundColor = White_Color;
    _nameview.userInteractionEnabled = YES;
    _nameview.tag = 1;
    
    _name = [[UILabel alloc]initWithFrame:CGRectMake(16, 0,100, 60)];
    _name.text = @"昵称";
    _name.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
    _name.textColor = Essential_Colour;
    
    _nametitle = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 216, 0,200, 60)];
    if (STRING_NOT_EMPTY([[UserModel userUserInfor] objectForKey:@"uname"])) {
        _nametitle.text = [[UserModel userUserInfor] objectForKey:@"uname"];
    }
    _nametitle.textAlignment = NSTextAlignmentRight;
    _nametitle.font = [UIFont systemFontOfSize:Nav_title_font];
    _nametitle.textColor = Deputy_Colour;
    [self.view addSubview:_nameview];
    [_nameview addSubview:_name];
    [_nameview addSubview:_nametitle];
    
    
    
    _introview = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_nameview.frame)+1, UI_SCREEN_WIDTH, 60)];
    _introview.backgroundColor = White_Color;
    _introview.userInteractionEnabled = YES;
    _introview.tag = 2;
    
    _intro = [[UILabel alloc]initWithFrame:CGRectMake(16, 0,100, 60)];
    _intro.text = @"个性签名";
    _intro.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
    _intro.textColor = Essential_Colour;
    
    _introtitle = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 216, 0,200, 60)];
    if (STRING_NOT_EMPTY([[UserModel userUserInfor] objectForKey:@"intro"])) {
        _introtitle.text = [[UserModel userUserInfor] objectForKey:@"intro"];
    }else{
        _introtitle.text = @"未填写";
    }
    _introtitle.textAlignment = NSTextAlignmentRight;
    _introtitle.font = [UIFont systemFontOfSize:Nav_title_font];
    _introtitle.textColor = Deputy_Colour;
    [self.view addSubview:_introview];
    [_introview addSubview:_intro];
    [_introview addSubview:_introtitle];
    
    
    _password = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_introview.frame)+16,UI_SCREEN_WIDTH, 60)];
    _password.userInteractionEnabled = YES;
    _password.tag = 3;
    _password.text = @"    修改密码";
    _password.font = [UIFont systemFontOfSize:Catalog_Cell_Name_Font];
    _password.backgroundColor = White_Color;
    _password.textColor = Essential_Colour;
    [self.view addSubview:_password];
    

    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_viewimage addGestureRecognizer:tap];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_nameview addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_introview addGestureRecognizer:tap2];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap:)];
    tap.numberOfTouchesRequired = 1;
    tap.numberOfTapsRequired = 1;
    [_password addGestureRecognizer:tap3];
}

- (void)handleTap:(UITapGestureRecognizer *)tap{
    switch (tap.view.tag) {
        case 0:
        {
            
        }
            break;
        case 1:
        {
            nameViewController *nameVC = [[nameViewController alloc]init];
            [self.navigationController pushViewController:nameVC animated:YES];
        }
            break;
        case 2:
        {
            introViewController *introVC = [[introViewController alloc]init];
            [self.navigationController pushViewController:introVC animated:YES];
        }
            break;
        case 3:
        {
            passwordViewController *passwordVC = [[passwordViewController alloc]init];
            [self.navigationController pushViewController:passwordVC animated:YES];
        }
            break;
            
        default:
            break;
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
