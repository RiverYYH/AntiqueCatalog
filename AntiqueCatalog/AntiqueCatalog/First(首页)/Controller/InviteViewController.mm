//
//  InviteViewController.m
//  AntiqueCatalog
//
//  Created by CssWeb on 16/3/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "InviteViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "Api.h"
#import "QREncoder.h"
@interface InviteViewController ()

@end

@implementation InviteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"邀请好友";
    
    [self CreatUI];
    
    /*
    NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[[NSUserDefaults standardUserDefaults] objectForKey:@"LastUserModelPassport"],@"uname", nil];
    [self showHudInView:self.view hint:@"二维码生成中"];
    [Api requestWithMethod:@"get" withPath:API_URL_USER withParams:param withSuccess:^(id responseObject) {
        //_dataDictionary = responseObject;
        [self initImage:responseObject];
        [self hideHud];
    } withError:^(NSError *error) {
        [self hideHud];
        [self showHudInView:self.view showHint:@"请检查网络设置"];
    }];
    */
}

-(void)CreatUI{
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    float downViewheight = UI_SCREEN_HEIGHT * 0.3;
    float downViewY = UI_SCREEN_HEIGHT - downViewheight;
    UIView * view=  [[UIView alloc]initWithFrame:CGRectMake(0, downViewY, UI_SCREEN_WIDTH, downViewheight)];
    view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:view];
    
    
    UILabel * downTitleLabel  = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 25)];
    downTitleLabel.text = @"其他方式邀请";
    downTitleLabel.textColor = [UIColor colorWithConvertString:@"#666666"];
    downTitleLabel.textAlignment = NSTextAlignmentCenter;
    [view addSubview:downTitleLabel];
    
    NSArray *array = [NSArray arrayWithObjects:@"Activity_pengyouquan", @"Activity_weixin", @"Activity_sina", @"Activity_qq", nil];
    float littleButtonWidth = UI_SCREEN_WIDTH * 0.156;
    float avrWidth = UI_SCREEN_WIDTH / 5;
    for(int i=0; i<4; i++) {
        UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
        btn.frame = CGRectMake(avrWidth * (i + 1) - littleButtonWidth/2, 50, littleButtonWidth, littleButtonWidth * 1.4);
        [btn setBackgroundImage:[UIImage imageNamed:[array objectAtIndex:i]] forState:UIControlStateNormal];
        btn.tag = 100+i;
        [btn addTarget:self action:@selector(btnClicked:) forControlEvents:UIControlEventTouchUpInside];
        [view addSubview:btn];
    }
}


-(void)initImage:(NSDictionary *)dict
{
    UIView *bgView = [[UIView alloc]initWithFrame:CGRectMake(20, 12+UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH-40, 300)];
    bgView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:bgView];
    
//    UIImageView *bgImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 379-UI_SCREEN_WIDTH, UI_SCREEN_WIDTH-24, UI_SCREEN_WIDTH-24)];
//    bgImageView.image = [UIImage imageNamed:@"Me_erweima_detail"];
//    [bgView addSubview:bgImageView];
    
    UIImageView *faceView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 10, 40, 40)];
    faceView.layer.masksToBounds = YES;
    faceView.layer.cornerRadius = 20;
    [faceView sd_setImageWithURL:[NSURL URLWithString:[dict objectForKey:@"avatar"]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    //[bgView addSubview:faceView];
    
//    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, 10, 200, 16.0)];
//    nameLabel.backgroundColor = [UIColor clearColor];
//    nameLabel.font = [UIFont systemFontOfSize:16.0];
//    nameLabel.textColor = TITLE_COLOR;
//    nameLabel.text = [dict objectForKey:@"uname"];
//    [bgView addSubview:nameLabel];
//    
//    UILabel *introLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, 35, 200, 15.0)];
//    introLabel.backgroundColor = [UIColor clearColor];
//    introLabel.font = [UIFont systemFontOfSize:15.0];
//    introLabel.textColor = CONTENT_COLOR;
//    introLabel.text = [NSString stringWithFormat:@"简介：%@",[dict objectForKey:@"intro"]];
//    [bgView addSubview:introLabel];
    
//    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 60.0, UI_SCREEN_WIDTH-24, 0.5)];
//    lineView.backgroundColor = LINERGBA;
//    [bgView addSubview:lineView];
    
    float erweimabian = UI_SCREEN_WIDTH-94;
    
    NSString * urlString = [NSString stringWithFormat:@"%@index.php?app=w3g&mod=App&act=app&uid=%@",HEADURL,[dict objectForKey:@"uid"]];
    DataMatrix* qrMatrix = [QREncoder encodeWithECLevel:QR_ECLEVEL_AUTO version:QR_VERSION_AUTO string:urlString];
    UIImage* qrcodeImage = [QREncoder renderDataMatrix:qrMatrix imageDimension:erweimabian]; //imageDimension--图片尺寸
    //UIImage *faceImage = [UIImage imageNamed:@"藏民网"];
    UIImage *faceImage = faceView.image;
    UIImage *resultImage = [self addImage:faceImage toImage:qrcodeImage];
    
    UIImageView* qrcodeImageView = [[UIImageView alloc] initWithFrame:CGRectMake((bgView.bounds.size.width - erweimabian)/2, bgView.bounds.size.height - erweimabian, erweimabian, erweimabian)]; //二维码的尺寸
    qrcodeImageView.image = resultImage;
    [bgView addSubview:qrcodeImageView];
    
    //将文件存储在沙盒中
    NSString *filePath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"erweima_%@@2x.png",[[UserModel userPassport] objectForKey:@"uid"]]];
    [UIImagePNGRepresentation(resultImage) writeToFile:filePath atomically:YES]; //直接写入Documents中,并不断替换
    
//    UILabel *jianjieLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(bgView.frame)+20, UI_SCREEN_WIDTH, 15.0)];
//    jianjieLabel.backgroundColor = [UIColor clearColor];
//    jianjieLabel.font = [UIFont systemFontOfSize:15.0];
//    jianjieLabel.textAlignment = NSTextAlignmentCenter;
//    jianjieLabel.textColor = CONTENT_COLOR;
//    jianjieLabel.text = @"扫一扫，和我成为好友吧。";
//    [self.view addSubview:jianjieLabel];
}
//合并图片
-(UIImage *)addImage:(UIImage *)image1 toImage:(UIImage *)image2
{
    UIGraphicsBeginImageContext(image2.size);
    
    //Draw image2
    [image2 drawInRect:CGRectMake(0, 0, image2.size.width, image2.size.height)];
    
    //Draw image1
    [image1 drawInRect:CGRectMake(image2.size.width/2-image2.size.width/10, image2.size.height/2-image2.size.height/10, image2.size.width/5, image2.size.height/5)];
    
    UIImage *resultImage=UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultImage;
}


- (void)btnClicked:(UIButton *)btn
{
    switch (btn.tag) {
        case 100:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"推荐我发现的神器级APP！它能“发现属于你的艺术”，#到处是宝#官方APP"
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"“%@”邀请你加入—到处是宝",[UserModel userUname]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_INVITATION,[UserModel userUname]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeWeixiTimeline
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }];
        }
            break;
        case 101:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"推荐我发现的神器级APP！它能“发现属于你的艺术”，#到处是宝#官方APP"
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"“%@”邀请你加入—到处是宝",[UserModel userUname]]
                                                          url:[NSString stringWithFormat:@"%@%@", API_URL_INVITATION,[UserModel userUname]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeWeixiSession
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }];
        }
            break;
        case 102:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"推荐我发现的神器级APP！它能“发现属于你的艺术”，#到处是宝#官方APP（“虎头”@到处是宝）下载：%@%@",API_URL_INVITATION,[UserModel userUname]]
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"“%@”邀请你加入—到处是宝",[UserModel userUname]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_INVITATION,[UserModel userUname]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeSinaWeibo
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    NSLog(@"分享成功");
                                    [self showHudInView:self.view showHint:@"分享成功"];
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }];
        }
            break;
        case 103:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:@"推荐我发现的神器级APP！它能“发现属于你的艺术”，#到处是宝#官方APP"
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"“%@”邀请你加入—到处是宝",[UserModel userUname]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_INVITATION,[UserModel userUname]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeQQ
                       authOptions:nil
                      shareOptions:nil
                     statusBarTips:YES
                            result:^(ShareType type, SSResponseState state, id<ISSPlatformShareInfo> statusInfo, id<ICMErrorInfo> error, BOOL end) {
                                if (state == SSResponseStateSuccess)
                                {
                                    //                                    NSLog(@"分享成功");
                                }
                                else if (state == SSResponseStateFail)
                                {
                                    NSLog(@"分享失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:[error errorDescription] delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                                    [alertView show];
                                }
                            }];
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
