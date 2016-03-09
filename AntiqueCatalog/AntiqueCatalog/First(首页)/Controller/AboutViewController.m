//
//  AboutViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/13.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "AboutViewController.h"
#import "BrowserViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    
    self.titleLabel.text = @"关于我们";
    
    UIScrollView *scrollView = [[UIScrollView alloc]initWithFrame:UI_MAIN_SCREEN_FRAME];
	scrollView.showsHorizontalScrollIndicator = NO;
	scrollView.showsVerticalScrollIndicator = NO;
	[self.view addSubview:scrollView];
	
	UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 90, 90)];
    imageView.image = [UIImage imageNamed:@"Me_icon"];
	imageView.center = CGPointMake(UI_SCREEN_WIDTH/2, 20+49);
	[scrollView addSubview:imageView];
	
	UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imageView.frame)+12, UI_SCREEN_WIDTH, 12)];
	label1.textColor = LINE_COLOR;
	label1.backgroundColor = [UIColor clearColor];
    label1.text = [NSString stringWithFormat:@"iPhone %f版",versionNumber];
	label1.font = [UIFont systemFontOfSize:12.0];
	label1.textAlignment = NSTextAlignmentCenter;
	[scrollView addSubview:label1];
	
	UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(label1.frame)+30, 100, 16)];
	label2.backgroundColor = [UIColor clearColor];
	label2.textColor = TITLE_COLOR;
	label2.text = @"简介";
	label2.font = [UIFont systemFontOfSize:16.0];
	[scrollView addSubview:label2];
	
	UILabel *label3 = [[UILabel alloc]init];
	label3.backgroundColor = [UIColor clearColor];
	label3.textColor = CONTENT_COLOR;
	label3.text = @"到处是宝，是由中藏云商（北京）科技有限公司创办的中国艺术、技艺、设计、原创聚集地。到处是宝集分享传播、兴趣交友、线上线下为一体，融合大数据、云计算、O2O、云鉴定等技术，创建一个中国最专业、最全面的创意艺术类社会化传播平台。到处是宝给有志于在移动互联网的浪潮下，在创意艺术人文领域传播营销自我的个体或机构一个全面、强大、便捷的自媒体传播平台，让您的作品、宝贝、资讯传遍中国大江南北。";
	NSDictionary * dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15],NSFontAttributeName,nil];
	CGSize timeSize = [label3.text boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH-48, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
	label3.numberOfLines = 0;
	label3.frame =  CGRectMake(24, CGRectGetMaxY(label2.frame)+15, UI_SCREEN_WIDTH-48, timeSize.height);
	label3.font = [UIFont systemFontOfSize:15.0];
	[scrollView addSubview:label3];
	
	UILabel *label4 = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(label3.frame)+20, 100, 16)];
	label4.backgroundColor = [UIColor clearColor];
	label4.textColor = TITLE_COLOR;
	label4.text = @"关注我们";
	label4.font = [UIFont systemFontOfSize:16.0];
	[scrollView addSubview:label4];
	
	UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
	button1.frame = CGRectMake(24, CGRectGetMaxY(label4.frame)+15, UI_SCREEN_WIDTH-48, 44);
	[button1 setBackgroundImage:[UIImage imageNamed:@"Me_wangzhi"] forState:0];
    button1.adjustsImageWhenHighlighted = NO;
	button1.tag = 1;
	[button1 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:button1];
	
	UILabel *label5 = [[UILabel alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(button1.frame)+20, 100, 16)];
	label5.backgroundColor = [UIColor clearColor];
	label5.textColor = TITLE_COLOR;
	label5.text = @"联系我们";
	label5.font = [UIFont systemFontOfSize:16.0];
	[scrollView addSubview:label5];
	
	UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
	button2.frame = CGRectMake(24, CGRectGetMaxY(label5.frame)+15, UI_SCREEN_WIDTH-48, 44);
	[button2 setBackgroundImage:[UIImage imageNamed:@"Me_dianhua"] forState:0];
    button2.adjustsImageWhenHighlighted = NO;
	button2.tag = 2;
	[button2 addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
	[scrollView addSubview:button2];
	
	scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH, CGRectGetMaxY(button2.frame)+30);
	
}

- (void)buttonClicked:(UIButton *)button
{
    switch (button.tag)
    {
        case 1:
        {
            BrowserViewController *browserVC = [[BrowserViewController alloc] initWithUrlString:@"http://sns.cangm.com"];
            [self presentViewController:browserVC animated:YES completion:^{}];
        }
            break;
        case 2:
        {
            NSString *number = @"400-7280059";
            number = [number stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];//string->NSURL前转一次UTF8,以免有时出错
            NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",number]];
            UIWebView *phoneCallWebView = [[UIWebView alloc] init];
            [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];
            [self.view addSubview:phoneCallWebView];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
