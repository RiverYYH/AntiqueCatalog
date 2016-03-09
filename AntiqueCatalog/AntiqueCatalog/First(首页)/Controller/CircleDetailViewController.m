//
//  CircleDetailViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/12/8.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "CircleDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"
#import "PostCommentViewController.h"
#import "ZanListViewController.h"
//#import "CircleViewController.h"
#import "MJPhotoBrowser.h"
#import "MJPhoto.h"
//#import "HTMLParser.h"
#import "MJAutoGifFooter.h"
#import "MJDIYGifHeader.h"
#import "UIViewController+HUD.h"


@interface CircleDetailViewController ()
{
    NSString *_postID;
    NSDictionary *_dataDictionary;
    UITableView *_tableView;
    float _upHeight;
    UIView *_upView;
    
    UIButton *_shoucangButton;
    UIButton *_zanButton;
    
    NSMutableArray *_zanArray;
    NSMutableArray *_commentArray;
    
    BOOL _isMore;
    
    UIImageView *_zhidingImageView;
    UIImageView *_jinghuaImageView;
    //点击进入对应的圈子
    NSMutableDictionary *_quanziDic;
    UILabel *_label;
    UITapGestureRecognizer *_tap;
    NSMutableArray *_imageUrlArray;
}
@end

@implementation CircleDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andID:(NSString *)postID
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _postID = postID;
        _upHeight = 1;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.rightButton setImage:[UIImage imageNamed:@"base_weibogengduo"] forState:UIControlStateNormal];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [CustomTabBarViewController sharedInstance].imageView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 49);
//    } completion:^(BOOL finished){
//        [CustomTabBarViewController sharedInstance].imageView.hidden = YES;
//    }];
    
    UIButton *zhuanfaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    zhuanfaButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 0, 44, 44);
    zhuanfaButton.adjustsImageWhenHighlighted = NO;
    zhuanfaButton.tag = 101;
    [zhuanfaButton setImage:[UIImage imageNamed:@"base_weibozhuanfa"] forState:UIControlStateNormal];
    [zhuanfaButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleImageView addSubview:zhuanfaButton];
    
    _shoucangButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _shoucangButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, 0, 44, 44);
    _shoucangButton.adjustsImageWhenHighlighted = NO;
    _shoucangButton.tag = 102;
    [_shoucangButton setImage:[UIImage imageNamed:@"base_weiboshoucang"] forState:UIControlStateNormal];
    [_shoucangButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleImageView addSubview:_shoucangButton];
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0f)
    {
        zhuanfaButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-150, 20, 44, 44);
        _shoucangButton.frame = CGRectMake([UIScreen mainScreen].bounds.size.width-100, 20, 44, 44);
    }
    
    _zanButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _zanButton.frame = CGRectMake(0, UI_SCREEN_HEIGHT-49, UI_SCREEN_WIDTH/2, 49);
    _zanButton.adjustsImageWhenHighlighted = NO;
    _zanButton.tag = 103;
    [_zanButton setImage:[UIImage imageNamed:@"WeiBoDetail_zan"] forState:UIControlStateNormal];
    [_zanButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_zanButton];
    
    UIButton *pinglunButton = [UIButton buttonWithType:UIButtonTypeCustom];
    pinglunButton.frame = CGRectMake(UI_SCREEN_WIDTH/2, UI_SCREEN_HEIGHT-49, UI_SCREEN_WIDTH/2, 49);
    pinglunButton.adjustsImageWhenHighlighted = NO;
    pinglunButton.tag = 104;
    [pinglunButton setImage:[UIImage imageNamed:@"WeiBoDetail_pinglun"] forState:UIControlStateNormal];
    [pinglunButton addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:pinglunButton];
    
    _quanziDic = [[NSMutableDictionary alloc] init];
    
    _zanArray = [NSMutableArray array];
    _commentArray = [NSMutableArray array];
    _imageUrlArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:UI_NO_TAB_FRAME style:UITableViewStyleGrouped];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self loadNewData];
    
    _isMore = NO;
    
    _tableView.header = [MJDIYGifHeader headerWithRefreshingBlock:^{
        _isMore = NO;
        [self loadNewCommentData];
    }];
    _tableView.footer = [MJAutoGifFooter footerWithRefreshingBlock:^{
        _isMore = YES;
        [self loadNewCommentData];
    }];
}

- (void)rightButtonClick:(id)sender
{
//    if (![[_dataDictionary objectForKey:@"follow"] intValue])
//    {
//        [self showHudInView:self.view showHint:@"请先加入圈子"];
//        return;
//    }
    BOOL _isMe = [[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uid"] isEqualToString:[[UserModel userPassport] objectForKey:@"uid"]];
    [LPActivityView showInView:self.view delegate:self cancelButtonTitle:@"取消" shareButtonImagesNameArray:@[@"Activity_qq",@"Activity_weixin",@"Activity_pengyouquan",@"Activity_sina",@"Activity_kongjian"] downButtonImagesNameArray:@[_isMe?@"Activity_shanchu":@"Activity_jubao"] tagNumber:1];
}

- (void)buttonClick:(UIButton *)button
{
//    if (![[_dataDictionary objectForKey:@"follow"] intValue])
//    {
//        [self showHudInView:self.view showHint:@"请先加入圈子"];
//        return;
//    }
    switch (button.tag)
    {
        case 101:
        {
            PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:_postID andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : 分享长文",[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostType:PostTypeForwardCircle andPostShowTitle:[_dataDictionary objectForKey:@"title"] andPostShowImage:[_dataDictionary objectForKey:@"post_first_image"] andPostShowcontent:[_dataDictionary objectForKey:@"content"]];
            [self presentViewController:postCommentVC animated:YES completion:nil];
        }
            break;
        case 102:
        {
            NSString *path = [[_dataDictionary objectForKey:@"is_favorite"] intValue]?API_URL_Weiba_unfavorite:API_URL_Weiba_favorite;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[_dataDictionary objectForKey:@"post_id"],@"post_id",[_dataDictionary objectForKey:@"weiba_id"],@"weiba_id",[_dataDictionary objectForKey:@"post_uid"],@"post_uid", nil];
            [self showHudInView:self.view hint:@"操作中"];
            [Api requestWithMethod:@"get" withPath:path withParams:params withSuccess:^(id responseObject) {
                //NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"status"] intValue])
                {
                    [self hideHud];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:_dataDictionary];
                    [dic setObject:[[dic objectForKey:@"is_favorite"] intValue]?@"0":@"1" forKey:@"is_favorite"];
                    _dataDictionary = dic;
                    [_shoucangButton setImage:[UIImage imageNamed:[[_dataDictionary objectForKey:@"is_favorite"] intValue]?@"base_weiboyishoucang":@"base_weiboshoucang"] forState:UIControlStateNormal];
                }
                else
                {
                    [self hideHud];
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
            } withError:^(NSError *error) {
                [self hideHud];
                [self showHudInView:self.view showHint:@"请检查网络设置"];
            }];
        }
            break;
        case 103:
        {
            NSString *path = [[_dataDictionary objectForKey:@"is_digg"] intValue]?API_URL_Weiba_unzan:API_URL_Weiba_zan;
            NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[_dataDictionary objectForKey:@"post_id"],@"post_id", nil];
            [self showHudInView:self.view hint:@"操作中"];
            [Api requestWithMethod:@"get" withPath:path withParams:params withSuccess:^(id responseObject) {
                //NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"status"] intValue])
                {
                    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postID,@"id", nil];
                    [Api requestWithMethod:@"get" withPath:API_URL_Weiba_CircleDetail withParams:param withSuccess:^(id responseObject1) {
                        [_zanButton setImage:[UIImage imageNamed:[[responseObject1 objectForKey:@"is_digg"] intValue]?@"WeiBoDetail_yizan":@"WeiBoDetail_zan"] forState:UIControlStateNormal];
                        _dataDictionary = responseObject1;
                        if ([_zanArray count])
                        {
                            [_zanArray removeAllObjects];
                        }
                        [_zanArray addObjectsFromArray:[responseObject1 objectForKey:@"digg_info"]];
                        [_tableView reloadData];
                    } withError:^(NSError *error) {
                        [self showHudInView:self.view showHint:@"请检查网络设置"];
                    }];
                }
                else
                {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
                [self hideHud];
                [_tableView reloadData];
            } withError:^(NSError *error) {
                [self hideHud];
                [self showHudInView:self.view showHint:@"请检查网络设置"];
            }];
        }
            break;
        case 104:
        {
            CommentView *commView = [[CommentView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
            commView.delegate = self;
            [self.tabBarController.view addSubview:commView];
            [UIView animateWithDuration:0.3 animations:^{
                commView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
            }];
        }
            break;
        default:
            break;
    }
}

- (void)loadNewData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postID,@"id", nil];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Api requestWithMethod:@"GET" withPath:API_URL_Weiba_CircleDetail withParams:params withSuccess:^(id responseObject){
            //NSLog(@"%@",responseObject);
            if ([responseObject objectForKey:@"status"]) {
                if(![[responseObject objectForKey:@"status"] intValue]) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    [self performSelector:@selector(leftButtonClick:) withObject:self afterDelay:2.0];
                }
            } else {
                _dataDictionary = responseObject;
                [_zanButton setImage:[UIImage imageNamed:[[responseObject objectForKey:@"is_digg"] intValue]?@"WeiBoDetail_yizan":@"WeiBoDetail_zan"] forState:UIControlStateNormal];
                [_shoucangButton setImage:[UIImage imageNamed:[[responseObject objectForKey:@"is_favorite"] intValue]?@"base_weiboyishoucang":@"base_weiboshoucang"] forState:UIControlStateNormal];
                [_zanArray addObjectsFromArray:[responseObject objectForKey:@"digg_info"]];
                [_commentArray addObjectsFromArray:[responseObject objectForKey:@"comment_info"]];
                [_quanziDic setObject:[responseObject objectForKey:@"weiba"] forKey:@"weiba"];
                [_quanziDic setObject:[responseObject objectForKey:@"weiba_id"] forKey:@"weiba_id"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"LIULANLIANGCHANGE" object:self userInfo:nil];
                dispatch_async(dispatch_get_main_queue(), ^{
                    NSLog(@"更新界面");
                    [_tableView reloadData];
                    [self creatUpView];
                });
            }
            
        } withError:^(NSError *error){
            NSLog(@"登录出错");
        }];
    });
}

- (void)loadNewCommentData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_isMore)
    {
        if (ARRAY_NOT_EMPTY(_commentArray))
        {
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_dataDictionary objectForKey:@"feed_id"],@"feed_id",[[_commentArray lastObject] objectForKey:@"comment_id"],@"max_id",@"10",@"count",nil];
        }
        else
        {
            [self stopRefreshing];
            return;
        }
    }
    else
    {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[_dataDictionary objectForKey:@"feed_id"],@"feed_id",@"",@"max_id",@"10",@"count",nil];
    }
    
    [self showHudInView:self.view hint:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Api requestWithMethod:@"GET" withPath:API_URL_Weiba_CommentList withParams:params withSuccess:^(id responseObject){
            //NSLog(@"%@",responseObject);
            if (!_isMore)
            {
                if ([_commentArray count])
                {
                    [_commentArray removeAllObjects];
                }
                [_commentArray addObjectsFromArray:responseObject];
            }
            else
            {
                if (ARRAY_NOT_EMPTY(responseObject))
                {
                    [_commentArray addObjectsFromArray:responseObject];
                }
                else
                {
                    [self stopRefreshing];
                    _isMore = NO;
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"没有更多了"];
                    return;
                }
            }
            [self stopRefreshing];
            _isMore = NO;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                [self hideHud];
            });
        } withError:^(NSError *error){
            [self stopRefreshing];
            _isMore = NO;
            [self hideHud];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    });
}

#pragma mark - MJRefreshBaseViewDelegate
-(void)stopRefreshing
{
	[_tableView.header endRefreshing];
	[_tableView.footer endRefreshing];
}
- (void)dealloc
{
    
}

- (void)creatUpView
{
    _upView = [[UIView alloc] initWithFrame:CGRectZero];
    _upView.userInteractionEnabled = YES;
//    NSString *weibaString = [_quanziDic objectForKey:@"weiba"];
//    NSLog(@"%@",weibaString);
    
    _label = [[UILabel alloc] initWithFrame:CGRectMake(64, 40, 30, 20)];
    _label.font = [UIFont systemFontOfSize:14];
    _label.textAlignment = NSTextAlignmentLeft;
    _label.textColor = CONTENT_COLOR;
    [_upView addSubview:_label];
    
    UIButton *quanziBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    quanziBtn.frame = CGRectMake(CGRectGetMaxX(_label.frame), 40, UI_SCREEN_WIDTH-94-40, 20);
    [quanziBtn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    quanziBtn.titleLabel.font = [UIFont systemFontOfSize:14];
    quanziBtn.tag = 105;
    [quanziBtn addTarget:self action:@selector(quanzibuttonClick) forControlEvents:UIControlEventTouchUpInside];
    [_upView addSubview:quanziBtn];
    
    if(![[_quanziDic objectForKey:@"weiba"] isKindOfClass:[NSNull class]]) {
        _label.text = @"来自";
        [quanziBtn setTitle:[_quanziDic objectForKey:@"weiba"] forState:UIControlStateNormal];
        quanziBtn.hidden = NO;
        NSString *str =[_quanziDic objectForKey:@"weiba"];
        CGSize size = [str boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size;
        quanziBtn.frame = CGRectMake(CGRectGetMaxX(_label.frame), 40, size.width, 20);
    } else {
        _label.text = @"此圈子已删除";
        quanziBtn.hidden = YES;
    }
    
    //头像
    UIImageView *userFaceImageView = [[UIImageView alloc]initWithFrame:CGRectMake(12, 15, 40, 40)];
    userFaceImageView.layer.masksToBounds = YES;
    userFaceImageView.layer.cornerRadius = 20;
    userFaceImageView.userInteractionEnabled = YES;
    [userFaceImageView sd_setImageWithURL:[NSURL URLWithString:[[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"avatar"] objectForKey:@"avatar_middle"]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    [_upView addSubview:userFaceImageView];
    
    UITapGestureRecognizer *faceTgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(faceClick)];
    [userFaceImageView addGestureRecognizer:faceTgr];
    
    //名字
    UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, 15, 250, 15)];
    nameLabel.textColor = WEIBO_TITLE_COLOR;
    nameLabel.font = [UIFont systemFontOfSize:15.0];
    nameLabel.text = [[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"];
    [_upView addSubview:nameLabel];
    
    //楼主
    UIImageView *louzhuImageView = [[UIImageView alloc]initWithFrame:CGRectZero];
    louzhuImageView.image = [UIImage imageNamed:@"WeiBoDetail_louzhu"];
    [_upView addSubview:louzhuImageView];
    
    //掌柜
//    UILabel *infoLabel = [[UILabel alloc]initWithFrame:CGRectMake(64, 40, UI_SCREEN_WIDTH-76, 15)];
//    infoLabel.textColor = CONTENT_COLOR;
//    infoLabel.font = [UIFont systemFontOfSize:12.0];
//    infoLabel.text = [_dataDictionary objectForKey:@"from"];
//    [_upView addSubview:infoLabel];
    
    //***************等级小图标
    NSDictionary * dic= [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:15.0],NSFontAttributeName,nil];
    CGSize titleSize;
    if(STRING_NOT_EMPTY(nameLabel.text)){
       titleSize = [nameLabel.text boundingRectWithSize:CGSizeMake(250, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    }
	NSArray *userArr = [[_dataDictionary objectForKey:@"user_info"] objectForKey:@"user_group"];
	if ([userArr isKindOfClass:[NSArray class]] && [userArr count])
    {
		for (int i = 0; i < [userArr count]; i ++)
        {
			UIImageView *userView = [[UIImageView alloc] initWithFrame:CGRectMake(64+titleSize.width+10+20*i, 15, 15, 15)];
			[userView sd_setImageWithURL:[NSURL URLWithString:[[userArr objectAtIndex:i] objectForKey:@"user_group_icon_url"]]];
			[_upView addSubview:userView];
		}
        
        //楼主
        louzhuImageView.frame = CGRectMake(64+titleSize.width+10+20*[userArr count], 15, 32, 15);
	}
    else
    {
        //楼主
        louzhuImageView.frame = CGRectMake(64+titleSize.width+10, 15, 32, 15);
    }
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(10, 60, UI_SCREEN_WIDTH-24, 0.5)];
    [(UIScrollView *)[[webView subviews] objectAtIndex:0] setBounces:NO];//禁用拖拽时的反弹效果
    webView.delegate = self;
    webView.userInteractionEnabled = YES;
    _tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClicked:)];
    _tap.delegate = self;
    [webView addGestureRecognizer:_tap];
    
    [_upView addSubview:webView];
    
    _webView = webView;
    
    NSString *content = [_dataDictionary objectForKey:@"content"];
	if (content.length>2)
    {
		NSString *str2 = [content substringWithRange:NSMakeRange(0, 3)];
		if ([str2 isEqualToString:@"<p>"])
        {
			content = [content substringFromIndex:3];
		}
	}
    
	NSString * str1 = [NSString stringWithFormat:@"<div style=\"margin-left:0px; font-size:19px;font-weight:bold;color:#010101;text-align:center;\">%@</div>",[_dataDictionary objectForKey:@"title"]];
    
    content = [content stringByReplacingOccurrencesOfString:@"140px" withString:@"0px"];
    
    NSString *str = [NSString stringWithFormat:@"%@<div style=\"word-wrap:break-word; width:%@px;\"><font style=\"font-size:16px;color:#262626;\">%@</font></div>",str1,[NSString stringWithFormat:@"%f",UI_SCREEN_WIDTH-24],content];
    [webView loadHTMLString:str baseURL:nil];
    
    //**************置顶 + 精华
    [_zhidingImageView removeFromSuperview];
    [_jinghuaImageView removeFromSuperview];
    
    if ([[_dataDictionary objectForKey:@"top"] intValue])
    {
        _zhidingImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-50, 12, 30, 15)];
        _zhidingImageView.image = [UIImage imageNamed:@"biaoqian_zhiding"];
        [_upView addSubview:_zhidingImageView];
        
        if ([[_dataDictionary objectForKey:@"digest"] intValue])
        {
            _jinghuaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-50, 32, 30, 15)];
            _jinghuaImageView.image = [UIImage imageNamed:@"biaoqian_jinghua"];
            [_upView addSubview:_jinghuaImageView];
        }
    }
    else
    {
        if ([[_dataDictionary objectForKey:@"digest"] intValue])
        {
            _jinghuaImageView = [[UIImageView alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-50, 12, 30, 15)];
            _jinghuaImageView.image = [UIImage imageNamed:@"biaoqian_jinghua"];
            [_upView addSubview:_jinghuaImageView];
        }
    }
}

- (void)quanzibuttonClick
{
//    if(![[_quanziDic objectForKey:@"weiba"] isKindOfClass:[NSNull class]]) {
//        CircleViewController *circleVC = [[CircleViewController alloc] initWithNibName:nil bundle:nil andWeibaName:[_quanziDic objectForKey:@"weiba"] andWeibaID:[_quanziDic objectForKey:@"weiba_id"]];
//        [self.navigationController pushViewController:circleVC animated:YES];
//    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    CGPoint pt = [gestureRecognizer locationInView:_webView];
    NSString *imgUrl = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).src", pt.x, pt.y];
    NSString *url = [_webView stringByEvaluatingJavaScriptFromString:imgUrl];
    NSLog(@"%@", url);
    if(STRING_NOT_EMPTY(url)) {
        return YES;
    } else {
        return NO;
    }
//    if(otherGestureRecognizer == _tap) {
//        
//        return NO;
//    } else {
//        return YES;
//    }
}

- (void)tapClicked:(UITapGestureRecognizer *)tap
{
    CGPoint pt = [tap locationInView:_webView];
    NSString *imgUrl = [NSString stringWithFormat:@"document.elementFromPoint(%f,%f).src", pt.x, pt.y];
    NSString *url = [_webView stringByEvaluatingJavaScriptFromString:imgUrl];
    NSLog(@"%@", url);
    if (STRING_NOT_EMPTY(url)) {
        NSMutableArray *imageArray = [NSMutableArray array];
        NSInteger num = 0;
        //1000为自定义的上限值，本应该是用方法获取其图片的具体值，这里暂时用1000顶值代替，
        for(int i=0; i<1000; i++) {
            NSString *js = [NSString stringWithFormat:@"document.getElementsByTagName('img')[%d].src", i];
            NSString *imgUrl = [_webView stringByEvaluatingJavaScriptFromString:js];
            if([imgUrl isEqualToString:@""]) {
                break;
            } else {
                if([imgUrl isEqualToString:url]) {
                    num = i;
                }
                MJPhoto *photo = [[MJPhoto alloc] init];
                photo.url = [NSURL URLWithString:imgUrl];
                [imageArray addObject:photo];
            }
        }
        MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
        browser.currentPhotoIndex = num; // 弹出相册时显示的第一张图片是？
        browser.photos = imageArray; // 设置所有的图片
        [browser show];
    }
    
}

- (void)faceClick
{
//    NewUserInformationViewController *userInformationVC = [[NewUserInformationViewController alloc] init];
//    userInformationVC.uname = [[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"];
//    [self.navigationController pushViewController:userInformationVC animated:YES];
}

#pragma mark - UIWebViewDelegate
/**将要开始加载调用,这里应该返回YES以进行加载,通过导航类型参数UIWebViewNavigationType可以得到请求发起的原因
 UIWebViewNavigationTypeLinkClicked -- 点击链接
 UIWebViewNavigationTypeFormSubmitted -- 提交表单
 UIWebViewNavigationTypeBackForward -- 前进后退
 UIWebViewNavigationTypeReload, -- 重新加载
 UIWebViewNavigationTypeFormResubmitted -- 重新提交表单
 UIWebViewNavigationTypeOther -- 其他
 */
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    return YES;
}
//开始加载调用
- (void)webViewDidStartLoad:(UIWebView *)webView
{
    NSLog(@"开始加载");
    [self showHudInView:self.view hint:@"加载中"];
}
//完成加载调用
//- (void)webViewDidFinishLoad:(UIWebView *)webView
//{
//    NSLog(@"完成加载");
//    
//    NSString *botySise=[[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",100];
//	
//    [webView stringByEvaluatingJavaScriptFromString:
//     @"var script = document.createElement('script');"
//     "script.type = 'text/javascript';"
//     "script.text = \"function ResizeImages() { "
//     "var myimg,oldwidth,newheight;"
//     "var maxwidth=296;" //缩放系数
//     "for(i=0;i <document.images.length;i++){"
//     "myimg = document.images[i];"
//     "myimg.setAttribute('style','max-width:296px;height:auto')"
//     "}"
//     "}\";"
//     "document.getElementsByTagName('head')[0].appendChild(script);"];
//    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.backgroundColor='#F6F5F3';"];//设置背景颜色
//	[webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=0.9"];
//    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
//	[webView stringByEvaluatingJavaScriptFromString:botySise];
//    
//    NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
//    NSLog(@"%@",height);
//    _upHeight = [height floatValue];
//    webView.frame = CGRectMake(12, 60, 296, _upHeight);
//    
//    _upView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 60+_webView.frame.size.height);
//    _tableView.tableHeaderView = nil;
//    _tableView.tableHeaderView = _upView;
//    [_tableView reloadData];
//}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSLog(@"完成加载");
	[self hideHud];
	
    NSString *botySise=[[NSString alloc] initWithFormat:@"document.getElementsByTagName('body')[0].style.webkitTextSizeAdjust= '%d%%'",100];
	
    [webView stringByEvaluatingJavaScriptFromString:
	 [NSString stringWithFormat:@"var script = document.createElement('script');"
	  "script.type = 'text/javascript';"
	  "script.text = \"function ResizeImages() { "
	  "var myimg,oldwidth,newheight;"
	  "var maxwidth=%f;" //缩放系数
	  "for(i=0;i <document.images.length;i++){"
	  "myimg = document.images[i];"
	  "myimg.setAttribute('style','max-width:%fpx;height:auto')"
	  "}"
	  "}\";"
	  "document.getElementsByTagName('head')[0].appendChild(script);",UI_SCREEN_WIDTH-34,UI_SCREEN_WIDTH-34]];
    [webView stringByEvaluatingJavaScriptFromString:@"document.body.style.backgroundColor='#F6F5F3';"];//设置背景颜色
	[webView stringByEvaluatingJavaScriptFromString:@"document.body.style.zoom=1.0"];
    [webView stringByEvaluatingJavaScriptFromString:@"ResizeImages();"];
	[webView stringByEvaluatingJavaScriptFromString:botySise];
	
	
    NSString *height = [webView stringByEvaluatingJavaScriptFromString:@"document.body.offsetHeight;"];
    NSLog(@"%@",height);
    _upHeight = [height floatValue];
    _webView.frame = CGRectMake(5, 60, UI_SCREEN_WIDTH-10, _upHeight+30);
	
    //	_webView.backgroundColor = [UIColor redColor];
    //	_upView.backgroundColor = [UIColor yellowColor];
    _upView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, 60+_webView.frame.size.height);
    _tableView.tableHeaderView = nil;
    _tableView.tableHeaderView = _upView;
    [_tableView reloadData];
}
//加载失败调用
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"加载失败");
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_commentArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"commentCell";
    CommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == NULL)
    {
        cell = [[CommentTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell updateCellWithData:[_commentArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [CommentTableViewCell heightForCellWithData:[_commentArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 80)];
    
    UILabel *xihuanLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 0, 38, 20)];
    xihuanLabel.text = @"喜欢";
    xihuanLabel.textColor = CONTENT_COLOR;
    xihuanLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:xihuanLabel];
    
    UILabel *huifuLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 60, 38, 20)];
    huifuLabel.text = @"回复";
    huifuLabel.textColor = CONTENT_COLOR;
    huifuLabel.font = [UIFont systemFontOfSize:15];
    [headerView addSubview:huifuLabel];
    
    UIView *line1 = [[UIView alloc]initWithFrame:CGRectMake(50, 10, UI_SCREEN_WIDTH-50, 0.5)];
    line1.backgroundColor = LINE_COLOR;
    [headerView addSubview:line1];
    
    UIView *line2 = [[UIView alloc]initWithFrame:CGRectMake(50, 70, UI_SCREEN_WIDTH-50, 0.5)];
    line2.backgroundColor = LINE_COLOR;
    [headerView addSubview:line2];
    
    if ([_zanArray count] <= 8)
    {
        for (int i=0; i<[_zanArray count]; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(12+(30+3)*i, 25, 30, 30);
            button.tag = 101+i;
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:15];
            button.adjustsImageWhenHighlighted = NO;
            [button sd_setImageWithURL:[NSURL URLWithString:[[_zanArray objectAtIndex:i] objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
            [button addTarget:self action:@selector(zanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
        }
    }
    else
    {
        for (int i=0; i<8; i++)
        {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.frame = CGRectMake(12+(30+3)*i, 25, 30, 30);
            button.tag = 101+i;
            [button.layer setMasksToBounds:YES];
            [button.layer setCornerRadius:15];
            button.adjustsImageWhenHighlighted = NO;
            [button sd_setImageWithURL:[NSURL URLWithString:[[_zanArray objectAtIndex:i] objectForKey:@"avatar"]] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
            [button addTarget:self action:@selector(zanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [headerView addSubview:button];
        }
    }
    
    UIButton *countButton = [UIButton buttonWithType:UIButtonTypeCustom];
    countButton.frame = CGRectMake(UI_SCREEN_WIDTH-14-30, 25, 30, 30);
    countButton.tag = 109;
    [countButton.layer setMasksToBounds:YES];
    [countButton.layer setCornerRadius:15];
    countButton.adjustsImageWhenHighlighted = NO;
    [countButton setTitle:[_dataDictionary objectForKey:@"praise"] forState:UIControlStateNormal];
    countButton.titleLabel.font = [UIFont systemFontOfSize:12];
    [countButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [countButton setBackgroundColor:CONTENT_COLOR];
    [countButton addTarget:self action:@selector(zanButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [headerView addSubview:countButton];
    
    return headerView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CommentView *commView = [[CommentView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    commView.delegate = self;
    commView.inputTextView.text = [NSString stringWithFormat:@"@%@ ",[[[_commentArray objectAtIndex:indexPath.row] objectForKey:@"user_info"] objectForKey:@"uname"]];
    [self.tabBarController.view addSubview:commView];
    [UIView animateWithDuration:0.3 animations:^{
        commView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
    }];
}

- (void)zanButtonClicked:(UIButton *)button
{
    if (button.tag == 109)
    {
        ZanListViewController *zanListVC = [[ZanListViewController alloc] initWithNibName:nil bundle:nil andFeedID:_postID andType:ZanTypeCircle];
        [self.navigationController pushViewController:zanListVC animated:YES];
    }
    else
    {
        //分别进入各自主页
//        NewUserInformationViewController *userInformationVC = [[NewUserInformationViewController alloc] init];
//        userInformationVC.uname = [[_zanArray objectAtIndex:button.tag-101] objectForKey:@"uname"];
//        [self.navigationController pushViewController:userInformationVC animated:YES];
    }
}

#pragma mark - CommentDelegate
-(void)sendTextForComment:(NSString *)commStr
{
	NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:commStr,@"content",@"3",@"from",_postID,@"post_id", nil];
    [self showHudInView:self.view hint:@"评论中..."];
	[Api requestWithMethod:@"get" withPath:API_URL_COMMENT_weiba withParams:param withSuccess:^(id responseObject) {
		if ([[responseObject objectForKey:@"status"] intValue]==1)
        {
            [self hideHud];
            [self loadNewCommentData];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"commentWeiBaSucceed" object:self userInfo:nil];
            [self showHudInView:self.view showHint:@"评论成功"];
		}
        else
        {
			[self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
		}
        [self hideHud];
        [_tableView reloadData];
	} withError:^(NSError *error) {
        [self hideHud];
        [self showHudInView:self.view showHint:@"请检查网络设置"];
	}];
}

#pragma mark - LPActivityViewDelegate
- (void)activity:(LPActivityView *)activityView clickedOnButtonIndex:(NSInteger)index
{
    switch (index)
    {
        case 0:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[_dataDictionary objectForKey:@"title"]
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"来自到处是宝%@的分享",[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_XiangQing,[_dataDictionary objectForKey:@"feed_id"]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            //            NSLog(@"%@",[_dataDictionary objectForKey:@"title"]);
            
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
        case 1:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[_dataDictionary objectForKey:@"title"]
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"来自到处是宝%@的分享",[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_XiangQing,[_dataDictionary objectForKey:@"feed_id"]]
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
        case 2:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[_dataDictionary objectForKey:@"title"]
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"来自到处是宝%@的分享",[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_XiangQing,[_dataDictionary objectForKey:@"feed_id"]]
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
        case 3:
        {
            //构造分享内容
            
            NSString *content = [_dataDictionary objectForKey:@"title"];
            if(content.length > 100) {
                content = [[_dataDictionary objectForKey:@"title"] substringToIndex:100];
            }
            id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@%@",content,API_URL_XiangQing,[_dataDictionary objectForKey:@"feed_id"]]
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"来自到处是宝%@的分享",[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_XiangQing,[_dataDictionary objectForKey:@"feed_id"]]
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
        case 4:
        {
            //构造分享内容
            id<ISSContent> publishContent = [ShareSDK content:[_dataDictionary objectForKey:@"title"]
                                               defaultContent:DEFAULTCONTENT
                                                        image:[ShareSDK imageWithPath:APPICON]
                                                        title:[NSString stringWithFormat:@"来自到处是宝%@的分享",[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]]
                                                          url:[NSString stringWithFormat:@"%@%@",API_URL_XiangQing,[_dataDictionary objectForKey:@"feed_id"]]
                                                  description:nil
                                                    mediaType:SSPublishContentMediaTypeNews];
            
            [ShareSDK shareContent:publishContent
                              type:ShareTypeQQSpace
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
        case 100:
        {
            if ([[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uid"] isEqualToString:[[UserModel userPassport] objectForKey:@"uid"]])
            {
                [LPActionSheetView showInView:self.view title:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil tagNumber:1];
            }
            else
            {
                [LPActionSheetView showInView:self.view title:@"确定要举报吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil tagNumber:2];
            }
        }
            break;
            
        default:
            break;
    }

}
#pragma mark - LPActionSheetViewDelegate
- (void)actionSheetClickedOnDestructiveButton:(LPActionSheetView *)actionSheetView
{
    if (actionSheetView.tag == 1)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postID,@"post_id",nil];
        [self showHudInView:self.view hint:@"删除中"];
        [Api requestWithMethod:@"GET" withPath:API_URL_DEL_weiba withParams:params withSuccess:^(id responseObject){
            //NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"status"] intValue])
            {
                [self hideHud];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiBaDel" object:self userInfo:nil];
                [self.navigationController popViewControllerAnimated:YES];
            }
            else
            {
                [self hideHud];
                [self showHudInView:self.view showHint:@"删除失败"];
            }
        } withError:^(NSError *error){
            [self hideHud];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    }
    else if (actionSheetView.tag == 2)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_postID,@"post_id",@"3",@"from",@"举报",@"reason",nil];
        [self showHudInView:self.view hint:@"举报中"];
        [Api requestWithMethod:@"GET" withPath:API_URL_DENOUNCE_weiba withParams:params withSuccess:^(id responseObject){
            //NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"status"] intValue])
            {
                [self hideHud];
                [self showHudInView:self.view showHint:@"举报成功"];
            }
            else
            {
                [self hideHud];
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        } withError:^(NSError *error){
            [self hideHud];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
