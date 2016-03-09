//
//  LabelsClassViewController.m
//  藏民网
//
//  Created by JingXiaoLiang on 15/5/10.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "LabelsClassViewController.h"
#import "UIViewController+HUD.h"

@interface LabelsClassViewController ()<UIAlertViewDelegate>
{
    NSMutableDictionary *_biaoqianDic;//存标签的总数组
    NSMutableArray *_dataArray;
//    NSMutableArray *_selectArray;
    NSMutableArray *Array;
    UIScrollView *scrollView;
    UIButton *button;
    UIButton *ZiDingYibutton;
    UILabel *ZiDingYiLable;
    UIButton *addButton;
    
    
    UIAlertView* alert;
    
    NSMutableArray *_ZiDingYiArray;
    UITextField *tf;
}

@end

@implementation LabelsClassViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil withselectArray:(NSMutableArray *)selectArray
{
    self = [super init];
    if (self) {
        // Custom initialization
        _selectArray = [[NSMutableArray alloc]init];
        _selectArray = selectArray;
    }
    return self;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.titleLabel.text = @"标签";
    
    [self.rightButton setTitle:@"确定" forState:UIControlStateNormal];
    
    
    _biaoqianDic = [[NSMutableDictionary alloc]init];
    _dataArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    Array = [[NSMutableArray alloc]init];
    _ZiDingYiArray = [[NSMutableArray alloc]init];
    
    
    addButton = [[UIButton alloc]init];
    [self GreatCommonLable];
//    [self loadNewData];
}

-(void)loadNewData
{
    [Api requestWithMethod:@"GET" withPath:API_URL_COMMEN_LABLE withParams:nil withSuccess:^(id responseObject) {
//        NSLog(@"%@",responseObject);
        if (ARRAY_NOT_EMPTY(_dataArray)) {
            [_dataArray removeAllObjects];
        }
        [_dataArray addObjectsFromArray:responseObject];
        for (NSDictionary *dic in _selectArray) {
            BOOL isHave = NO;
            for (NSDictionary *dict in responseObject) {
                if([[dict objectForKey:@"title"] isEqualToString:[dic objectForKey:@"title"]]) {
                    isHave = YES;
                }
            }
            if(!isHave) {
                [_dataArray addObject:dic];
            }
        }
        [self GreatCommonLable];
        
    } withError:^(NSError *error) {
        
        [self showHudInView:self.view showHint:@"请检查网络设置"];
        
    }];


}

-(void)GreatCommonLable
{
    
    scrollView = [[UIScrollView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME];
    scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, ((5 +5 -1)/3+1)*40+20+260);
    [self.view addSubview:scrollView];
//    
//    UILabel *CommonLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, UI_SCREEN_WIDTH, 20)];
//    CommonLable.text = @"    常用标签";
//    CommonLable.backgroundColor = ICON_COLOR;
//    CommonLable.textAlignment = NSTextAlignmentLeft;
//    CommonLable.font = [UIFont systemFontOfSize:15];
//    CommonLable.textColor = [UIColor whiteColor];
//    [scrollView addSubview:CommonLable];
    
    ZiDingYiLable = [[UILabel alloc]initWithFrame:CGRectMake(0, 10, UI_SCREEN_WIDTH, 20)];
    ZiDingYiLable.text = @"    自定义标签";
    ZiDingYiLable.backgroundColor = ICON_COLOR;
    ZiDingYiLable.textAlignment = NSTextAlignmentLeft;
    ZiDingYiLable.font = [UIFont systemFontOfSize:15];
    ZiDingYiLable.textColor = [UIColor whiteColor];
    [scrollView addSubview:ZiDingYiLable];
    
    [self CreatZiDingYiLable];
}
- (void)buttonClicked:(UIButton *)CommenButton
{
    
    if (CommenButton.tag == 100)
    {
       
    }
    else
    {
        if (CommenButton.isSelected)
        {
            for (int i = 0; i < Array.count; i++) {
                if (CommenButton.tag == [[Array objectAtIndex:i] tag]) {
                    
                    [CommenButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                    [Array removeObject:CommenButton];
                }
            }
            
            CommenButton.selected = NO;
            
            [_selectArray removeObject:[_dataArray objectAtIndex:CommenButton.tag-101]];
        }
        else
        {
            NSInteger biaoqianCount = [_selectArray count] + [_ZiDingYiArray count];
            if (biaoqianCount < 5)
            {
                CommenButton.selected = YES;
                
                [_selectArray addObject:[_dataArray objectAtIndex:CommenButton.tag-101]];
                
            }
            else
            {
                [self showHudInView:self.view showHint:@"最多选择5个兴趣"];
            }
        }
        //        NSLog(@"%@",_selectArray);
        
    }
}

-(void)CreatZiDingYiLable
{
    
    [self addButtonView];

}

-(void)addButtonView
{
    
    addButton.tag = 200;
    [addButton setImage:[UIImage imageNamed:@"jiaguanzhu"] forState:UIControlStateNormal];
    [addButton addTarget:self action:@selector(ZiDingYiButtonClicked:) forControlEvents:UIControlEventTouchDown];
    if (_selectArray.count == 0) {
        addButton.frame = CGRectMake(10 + _selectArray.count*100, ZiDingYiLable.frame.origin.y + ZiDingYiLable.frame.size.height + 10, 40, 40);
    }else if (_selectArray.count == 1){
        addButton.frame = CGRectMake(10 + _selectArray.count*100, ZiDingYiLable.frame.origin.y + ZiDingYiLable.frame.size.height + 10, 40, 40);
    }else if (_selectArray.count == 2){
        addButton.frame = CGRectMake(10 + _selectArray.count*100, ZiDingYiLable.frame.origin.y + ZiDingYiLable.frame.size.height + 10, 40, 40);
    }else if (_selectArray.count == 3){
        addButton.frame = CGRectMake(10 + 0*100, ZiDingYiLable.frame.origin.y + ZiDingYiLable.frame.size.height + 60, 40, 40);
    }else if (_selectArray.count == 4){
        addButton.frame = CGRectMake(10 + 1*100, ZiDingYiLable.frame.origin.y + ZiDingYiLable.frame.size.height +60, 40, 40);
    }else {
        addButton.frame = CGRectMake(10 + 2*100, ZiDingYiLable.frame.origin.y + ZiDingYiLable.frame.size.height +60, 40, 40);
    }
    [scrollView addSubview:addButton];
    
    
    NSInteger iconCount = [_selectArray count];
    CGPoint point_button[iconCount];
    NSInteger k = 0;
//    ZiDingYiButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    if (_selectArray.count > 0) {
        for (NSInteger i=0; i<(iconCount-1)/3+1; i++)
        {
            for (NSInteger j=0; j<3; j++)
            {
                if (k < iconCount)
                {
                    if (k == 0) {
                        [_ZiDingYiButton1 removeFromSuperview];
                        _ZiDingYiButton1 = nil;
                        
                        point_button[k] = CGPointMake(((UI_SCREEN_WIDTH-40)/3.0/2.0+10)+j*((UI_SCREEN_WIDTH-40)/3.0+10),ZiDingYiLable.frame.origin.y+ZiDingYiLable.frame.size.height+30+i*50);
                        
                        _ZiDingYiButton1 = [UIButton buttonWithType:UIButtonTypeCustom];
                        _ZiDingYiButton1.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH-40)/3.0, 40);
                        _ZiDingYiButton1.center = point_button[k];
                        _ZiDingYiButton1.tag = 201+k;
                        _ZiDingYiButton1.titleLabel.lineBreakMode = 0;
                        _ZiDingYiButton1.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        _ZiDingYiButton1.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                        [_ZiDingYiButton1.layer setMasksToBounds:YES];
                        [_ZiDingYiButton1.layer setCornerRadius:4.0];
                        [_ZiDingYiButton1 setTitle:[_selectArray objectAtIndex:k] forState:UIControlStateNormal];
                        
                        
                        [_ZiDingYiButton1 setTitleColor:ICON_COLOR forState:UIControlStateNormal];
                        
                        [_ZiDingYiButton1 setBackgroundColor:CONTENT_COLOR];
                        [_ZiDingYiButton1 addTarget:self action:@selector(ZiDingYiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        _ZiDingYiButton1.hidden = NO;
                        
                        [scrollView addSubview:_ZiDingYiButton1];
                        
                        
                    }
                    if (k == 1) {
                        [_ZiDingYiButton2 removeFromSuperview];
                        _ZiDingYiButton2 = nil;
                        point_button[k] = CGPointMake(((UI_SCREEN_WIDTH-40)/3.0/2.0+10)+j*((UI_SCREEN_WIDTH-40)/3.0+10),ZiDingYiLable.frame.origin.y+ZiDingYiLable.frame.size.height+30+i*50);
                        
                        _ZiDingYiButton2 = [UIButton buttonWithType:UIButtonTypeCustom];
                        _ZiDingYiButton2.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH-40)/3.0, 40);
                        _ZiDingYiButton2.center = point_button[k];
                        _ZiDingYiButton2.tag = 201+k;
                        _ZiDingYiButton2.titleLabel.lineBreakMode = 0;
                        _ZiDingYiButton2.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        _ZiDingYiButton2.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                        [_ZiDingYiButton2.layer setMasksToBounds:YES];
                        [_ZiDingYiButton2.layer setCornerRadius:4.0];
                        [_ZiDingYiButton2 setTitle:[_selectArray objectAtIndex:k] forState:UIControlStateNormal];
                        
                        
                        [_ZiDingYiButton2 setTitleColor:ICON_COLOR forState:UIControlStateNormal];
                        
                        [_ZiDingYiButton2 setBackgroundColor:CONTENT_COLOR];
                        [_ZiDingYiButton2 addTarget:self action:@selector(ZiDingYiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        _ZiDingYiButton2.hidden = NO;
                        
                        [scrollView addSubview:_ZiDingYiButton2];
                        
                        
                    }
                    if (k == 2) {
                        [_ZiDingYiButton3 removeFromSuperview];
                        _ZiDingYiButton3 = nil;
                        point_button[k] = CGPointMake(((UI_SCREEN_WIDTH-40)/3.0/2.0+10)+j*((UI_SCREEN_WIDTH-40)/3.0+10),ZiDingYiLable.frame.origin.y+ZiDingYiLable.frame.size.height+30+i*50);
                        
                        _ZiDingYiButton3 = [UIButton buttonWithType:UIButtonTypeCustom];
                        _ZiDingYiButton3.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH-40)/3.0, 40);
                        _ZiDingYiButton3.center = point_button[k];
                        _ZiDingYiButton3.tag = 201+k;
                        _ZiDingYiButton3.titleLabel.lineBreakMode = 0;
                        _ZiDingYiButton3.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        _ZiDingYiButton3.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                        [_ZiDingYiButton3.layer setMasksToBounds:YES];
                        [_ZiDingYiButton3.layer setCornerRadius:4.0];
                        [_ZiDingYiButton3 setTitle:[_selectArray objectAtIndex:k] forState:UIControlStateNormal];
                        
                        
                        [_ZiDingYiButton3 setTitleColor:ICON_COLOR forState:UIControlStateNormal];
                        
                        [_ZiDingYiButton3 setBackgroundColor:CONTENT_COLOR];
                        [_ZiDingYiButton3 addTarget:self action:@selector(ZiDingYiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        _ZiDingYiButton3.hidden = NO;
                        
                        [scrollView addSubview:_ZiDingYiButton3];
                        
                        
                    }
                    if (k == 3) {
                        [_ZiDingYiButton4 removeFromSuperview];
                        _ZiDingYiButton4 = nil;
                        point_button[k] = CGPointMake(((UI_SCREEN_WIDTH-40)/3.0/2.0+10)+j*((UI_SCREEN_WIDTH-40)/3.0+10),ZiDingYiLable.frame.origin.y+ZiDingYiLable.frame.size.height+30+i*50);
                        
                        _ZiDingYiButton4 = [UIButton buttonWithType:UIButtonTypeCustom];
                        _ZiDingYiButton4.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH-40)/3.0, 40);
                        _ZiDingYiButton4.center = point_button[k];
                        _ZiDingYiButton4.tag = 201+k;
                        _ZiDingYiButton4.titleLabel.lineBreakMode = 0;
                        _ZiDingYiButton4.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        _ZiDingYiButton4.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                        [_ZiDingYiButton4.layer setMasksToBounds:YES];
                        [_ZiDingYiButton4.layer setCornerRadius:4.0];
                        [_ZiDingYiButton4 setTitle:[_selectArray objectAtIndex:k] forState:UIControlStateNormal];
                        
                        
                        [_ZiDingYiButton4 setTitleColor:ICON_COLOR forState:UIControlStateNormal];
                        
                        [_ZiDingYiButton4 setBackgroundColor:CONTENT_COLOR];
                        [_ZiDingYiButton4 addTarget:self action:@selector(ZiDingYiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        _ZiDingYiButton4.hidden = NO;
                        
                        [scrollView addSubview:_ZiDingYiButton4];
                        
                        
                    }
                    if (k == 4) {
                        [_ZiDingYiButton5 removeFromSuperview];
                        _ZiDingYiButton5 = nil;
                        point_button[k] = CGPointMake(((UI_SCREEN_WIDTH-40)/3.0/2.0+10)+j*((UI_SCREEN_WIDTH-40)/3.0+10),ZiDingYiLable.frame.origin.y+ZiDingYiLable.frame.size.height+30+i*50);
                        
                        _ZiDingYiButton5 = [UIButton buttonWithType:UIButtonTypeCustom];
                        _ZiDingYiButton5.frame = CGRectMake(0, 0, (UI_SCREEN_WIDTH-40)/3.0, 40);
                        _ZiDingYiButton5.center = point_button[k];
                        _ZiDingYiButton5.tag = 201+k;
                        _ZiDingYiButton5.titleLabel.lineBreakMode = 0;
                        _ZiDingYiButton5.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
                        _ZiDingYiButton5.titleLabel.font = [UIFont boldSystemFontOfSize:16];
                        [_ZiDingYiButton5.layer setMasksToBounds:YES];
                        [_ZiDingYiButton5.layer setCornerRadius:4.0];
                        [_ZiDingYiButton5 setTitle:[_selectArray objectAtIndex:k] forState:UIControlStateNormal];
                        
                        
                        [_ZiDingYiButton5 setTitleColor:ICON_COLOR forState:UIControlStateNormal];
                        
                        [_ZiDingYiButton5 setBackgroundColor:CONTENT_COLOR];
                        [_ZiDingYiButton5 addTarget:self action:@selector(ZiDingYiButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
                        _ZiDingYiButton5.hidden = NO;
                        
                        [scrollView addSubview:_ZiDingYiButton5];
                        
                        
                    }
                    
                    k++;
                }
            }
        }

    }
    
    
}

-(void)ZiDingYiButtonClicked:(UIButton *)ZiDingYi
{
    if (ZiDingYi.tag == 200) {
        
        NSInteger biaoqianCount = [_selectArray count] + [_ZiDingYiArray count];
        if (biaoqianCount < 5)
        {
            alert = [[UIAlertView alloc] initWithTitle:@"自定义标签"
                                               message:@"请输入2-10个字符"
                                              delegate:self
                                     cancelButtonTitle:@"取消"
                                     otherButtonTitles:@"确定", nil];
            // 基本输入框，显示实际输入的内容
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alert show];
            
            tf = [alert textFieldAtIndex:0];
            
        }
        else
        {
            [self showHudInView:self.view showHint:@"最多选择5个兴趣"];
        }
        
        
    }else
    {
        
//        [ZiDingYi removeFromSuperview];
//        ZiDingYi.hidden = YES;
        _ZiDingYiButton1.hidden = YES;
        _ZiDingYiButton2.hidden = YES;
        _ZiDingYiButton3.hidden = YES;
        _ZiDingYiButton4.hidden = YES;
        _ZiDingYiButton5.hidden = YES;
        [_ZiDingYiButton1 removeFromSuperview];
        [_ZiDingYiButton2 removeFromSuperview];
        [_ZiDingYiButton3 removeFromSuperview];
        [_ZiDingYiButton4 removeFromSuperview];
        [_ZiDingYiButton5 removeFromSuperview];
        _ZiDingYiButton1 = nil;
        _ZiDingYiButton2 = nil;
        _ZiDingYiButton3 = nil;
        _ZiDingYiButton4 = nil;
        _ZiDingYiButton5 = nil;
        [_selectArray removeObjectAtIndex:ZiDingYi.tag - 201];
        [self CreatZiDingYiLable];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:
            
            break;
        case 1:
        {
//            NSLog(@"%@",tf.text);
//            NSLog(@"%ld",tf.text.length);
            if (tf.text.length < 2 || tf.text.length > 10) {
                
                alert = [[UIAlertView alloc] initWithTitle:@"自定义标签"
                                                   message:@"请输入2-10个字符"
                                                  delegate:self
                                         cancelButtonTitle:@"取消"
                                         otherButtonTitles:@"确定", nil];
                // 基本输入框，显示实际输入的内容
                alert.alertViewStyle = UIAlertViewStylePlainTextInput;
                [alert show];
                
                tf = [alert textFieldAtIndex:0];
                
            }else {
                BOOL isHave = NO;
                for (NSString *string in _selectArray) {
                    if([tf.text isEqualToString:string]) {
                        isHave = YES;
                    }
                }
                for (NSDictionary *dic in _dataArray) {
                    if([[dic objectForKey:@"title"] isEqualToString:tf.text]) {
                        isHave = YES;
                    }
                }
                
                if(isHave) {
                    [self showHudInView:self.view showHint:@"标签已存在"];
                } else {
                    [_selectArray addObject:tf.text];
                    [self CreatZiDingYiLable];
                }
            }
        }
            
            break;
            
        default:
            break;
    }
}

-(void)rightButtonClick:(id)sender
{
    NSInteger biaoqianCount = [_selectArray count] + [_ZiDingYiArray count];
    if (biaoqianCount < 0) {
        [self showHudInView:self.view showHint:@"你没有添加标签"];
    }else{
        
        _biaoqianDic = [NSMutableDictionary dictionaryWithObjectsAndKeys:_selectArray,@"_selectArray",nil];
        
        [[NSNotificationCenter defaultCenter]postNotificationName:@"BiaoQian" object:_biaoqianDic];
        [self dismissViewControllerAnimated:YES completion:^{}];
    }
    
    
}

-(void)leftButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:^{}];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
