//
//  FeedbackViewController.m
//  AntiqueCatalog
//
//  Created by cssweb on 16/3/10.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CustomTextView.h"

@interface FeedbackViewController ()<CustomTextViewDelegate>{
    CustomTextView *commentV;
    UILabel * numberLabel;

}

@end

@implementation FeedbackViewController
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
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"意见反馈";
    [self.rightButton setTitle:@"提交" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    commentV=[[CustomTextView alloc]initWithFrame:CGRectMake(10, 64, SCREEN_WIDTH - 2*10, 40)];
    commentV.delegate = self;
    [self.view addSubview:commentV];
    numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(commentV.frame.origin.x + commentV.frame.size.width - 40, commentV.frame.size.height + commentV.frame.origin.y + 2, 40, 40)];
    numberLabel.font = [UIFont systemFontOfSize:14.0f];
    numberLabel.textAlignment = NSTextAlignmentRight;
    numberLabel.text = @"300";
    numberLabel.textColor = [UIColor lightGrayColor];
    [self.view addSubview:numberLabel];
    
}

-(void)rightButtonClick:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
    
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

#pragma  mark CustomTextViewDelegate
-(void)getNumberTextView:(NSString *)textViewStr withViewRect:(CGRect)viewFrame{
    NSInteger length = textViewStr.length;
    numberLabel.frame = CGRectMake(viewFrame.origin.x + viewFrame.size.width - 40, viewFrame.size.height + viewFrame.origin.y+ 2, 40, 40);
    NSInteger count = 300 - length;
    numberLabel.text = [NSString stringWithFormat:@"%ld",(long)count];
    
}

@end
