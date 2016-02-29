//
//  BaseViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/1.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "BaseViewController.h"


@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    
    self.navigationController.navigationBar.hidden = YES;
    
    self.view.backgroundColor = [UIColor colorWithConvertString:@"#f2f2f2"];
    
    _titleImageView = [[UIImageView alloc] init];
    _titleImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 44);
    _titleImageView.backgroundColor = White_Color;
    _titleImageView.userInteractionEnabled = YES;
    [self.view addSubview:_titleImageView];
    
    _imageViewIndex = [[UIImageView alloc]init];
    _imageViewIndex.backgroundColor = White_Color;
    _imageViewIndex.frame = CGRectMake(UI_SCREEN_WIDTH/2-50, 30, 100, 24);
    _imageViewIndex.hidden = YES;
    [self.view addSubview:_imageViewIndex];
    
    _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(50, 0, [UIScreen mainScreen].bounds.size.width-100, 44)];
    _titleLabel.textColor = Black_Color;
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.font = [UIFont systemFontOfSize:Nav_title_font];
    [_titleImageView addSubview:_titleLabel];
    
    _leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _leftButton.frame = CGRectMake(0, 0, 44, 44);
    _leftButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _leftButton.adjustsImageWhenHighlighted = NO;
    [_leftButton setTitleColor:White_Color forState:UIControlStateNormal];
    [_leftButton setImage:[UIImage imageNamed:@"icon_back"] forState:UIControlStateNormal];
    [_leftButton setImageEdgeInsets:UIEdgeInsetsMake(-3,10,-5,-10)];
    [_leftButton addTarget:self action:@selector(leftButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImageView addSubview:_leftButton];
    
    _rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _rightButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-40, 0, 44, 44);
    _rightButton.titleLabel.font = [UIFont systemFontOfSize:16];
    _rightButton.adjustsImageWhenHighlighted = NO;
    [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [_rightButton addTarget:self action:@selector(rightButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_titleImageView addSubview:_rightButton];
    
    UIImageView *lineView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 43.5, [UIScreen mainScreen].bounds.size.width, 0.5)];
    lineView.backgroundColor = [UIColor colorWithConvertString:@"#e4e4e4"];
    [_titleImageView addSubview:lineView];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        _titleImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 64);
        _titleLabel.frame = CGRectMake(50, 20, [UIScreen mainScreen].bounds.size.width-100, 44);
        _leftButton.frame = CGRectMake(-8, 20, 44, 44);
        _rightButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-50, 20, 44, 44);
        lineView.frame = CGRectMake(0, 63.5, [UIScreen mainScreen].bounds.size.width, 0.5);
    }
}

//默认方法用来弹栈,如果有其他需求直接在子类中重写即可
-(void)leftButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)rightButtonClick:(id)sender
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
