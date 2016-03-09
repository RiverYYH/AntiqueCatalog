//
//  TopicDetailViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/12/29.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "UIImageView+WebCache.h"
#import "PostWeiBoViewController.h"
//#import "PengYouQuanDetailViewController.h"
#import "CommentView.h"
#import "BrowserViewController.h"
#import "CircleDetailViewController.h"
#import "KnowledgeDetailViewController.h"
#import "PicturesWallViewController.h"
#import "TopicSettingViewController.h"
//#import "FansListViewController.h"
//#import "PictureWallCollectionViewController.h"
#import "PostCommentViewController.h"
//#import "LongWeiboDetailViewController.h"
//#import "LabelPlazaViewDetailController.h"

#import "MJPhoto.h"
#import "MJPhotoBrowser.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MJDIYGifHeader.h"
#import "MJAutoGifFooter.h"
#import "UIViewController+HUD.h"
#import "DHHshowLoading.h"

@interface TopicDetailViewController ()<CommentDelegate>
{
    NSDictionary *_dataDictionary;
    
    UITableView *_tableView;
    NSMutableArray *_dataArray;
    NSString *_topicName;
    
    
    BOOL _isMore;
    BOOL _isDown;//判断是否是向下滑动，改变返回按钮的样式
    
    NSInteger _index;//记录点击的是第几个cell进入了详情,以便利用通知直接修改对应内容
    NSInteger _index1;//记录是对第几个cell进行快速评论
    BOOL _isForward;//记录是从正常地方还是转发的地方进了详情
    BOOL _isShareTopic;//分享到站外的是整个专辑还是专辑下得某个微博
    
    NSMutableDictionary *_params;
    UIView *_barView;
    UIButton *_subscribeBtn;
    UIButton *_postTopicBtn;
    UIButton *_shareBtn;
    BOOL _ishost;//判断是否是创建者
    BOOL _isAttention;//判断是否已关注
    BOOL _isCreatUI;//判断是否创建视图
    
    MPMoviePlayerViewController *_playController;
}
@end

@implementation TopicDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil WithTopicName:(NSString *)topicName
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _topicName = topicName;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(postWeiBoSucceed:) name:@"PostWeiBoSucceed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiBoDetailZan:) name:@"WeiBoDetailZan" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(commentWeiBoSucceed:) name:@"commentWeiBoSucceed" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(weiBoDel:) name:@"WeiBoDel" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topicSetting:) name:@"TOPICSETTINGSUCCED" object:nil];
    }
    return self;
}

- (void)postWeiBoSucceed:(NSNotification *)notification
{
    if(_isNewTopic) {
        return;
    } else {
        [self loadNewData];
    }
}
- (void)topicSetting:(NSNotification *)notifition
{
    [self loadNewData];
}
- (void)weiBoDetailZan:(NSNotification *)notification
{
    if (_isForward)
    {
        [self loadNewData];
    }
    else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
        [dic setObject:[[dic objectForKey:@"is_digg"] intValue]?[NSString stringWithFormat:@"%d",[[dic objectForKey:@"digg_count"] intValue]-1]:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"digg_count"] intValue]+1] forKey:@"digg_count"];
        [dic setObject:[[dic objectForKey:@"is_digg"] intValue]?@"0":@"1" forKey:@"is_digg"];
        [_dataArray replaceObjectAtIndex:_index withObject:dic];
        [_tableView reloadData];
    }
}

- (void)commentWeiBoSucceed:(NSNotification *)notification
{
    if (_isForward)
    {
        [self loadNewData];
    }
    else
    {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
        [dic setObject:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"comment_count"] intValue]+1] forKey:@"comment_count"];
        [_dataArray replaceObjectAtIndex:_index withObject:dic];
        [_tableView reloadData];
    }
}

- (void)weiBoDel:(NSNotification *)notification
{
    [self loadNewData];
}
- (void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"readCountChanged" object:nil userInfo:nil];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [CustomTabBarViewController sharedInstance].imageView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 49);
//    } completion:^(BOOL finished){
//        [CustomTabBarViewController sharedInstance].imageView.hidden = YES;
//    }];
    
    self.lineView.hidden = YES;
    self.titleLabel.text = [NSString stringWithFormat:@"#%@#",_topicName];
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.frame = CGRectMake(50, 20, UI_SCREEN_WIDTH-70, 44);
    [self.leftButton setImage:[UIImage imageNamed:@"Find_topic_detail_back"] forState:UIControlStateNormal];
    self.titleImageView.backgroundColor = [UIColor clearColor];
    
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT) style:UITableViewStylePlain];
//    _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
//    _tableView.separatorColor = LINE_COLOR;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view insertSubview:_tableView atIndex:0];
    
    //遮盖最上面的20
    UIView *wardView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 20)];
    wardView.backgroundColor = [UIColor whiteColor];
    [self.view insertSubview:wardView atIndex:1];
    
    _tableView.header = [MJDIYGifHeader headerWithRefreshingBlock:^{
        _isMore = NO;
        [self loadNewData];
    }];
    _tableView.footer = [MJAutoGifFooter footerWithRefreshingBlock:^{
        _isMore = YES;
        [self loadNewData];
    }];
    
    _isMore = NO;
    
    [self loadNewData];
    
    _isCreatUI = NO;
}

- (void)leftButtonClick:(id)sender
{
    if(_isNewTopic) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTopicCreated" object:nil userInfo:nil];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)shareBtnClicked
{
//    BOOL _isMe = [[[[_dataDictionary objectForKey:@"detail"] objectForKey:@"user_info"] objectForKey:@"uid"] isEqualToString:[[UserModel userPassport] objectForKey:@"uid"]];
//    NSLog(@"%@",_dataDictionary);
//    [LPActivityView showInView:self.view delegate:self cancelButtonTitle:@"取消" shareButtonImagesNameArray:@[@"Activity_qq",@"Activity_weixin",@"Activity_pengyouquan",@"Activity_sina",@"Activity_kongjian"] downButtonImagesNameArray:@[_isMe?@"":@"Activity_jubao"] tagNumber:1];
    [LPActivityView showInView:self.view delegate:self cancelButtonTitle:@"取消" shareButtonImagesNameArray:@[@"Activity_qq",@"Activity_weixin",@"Activity_pengyouquan",@"Activity_sina",@"Activity_kongjian"] downButtonImagesNameArray:nil tagNumber:1];
}

- (void)postButtonClick
{
    PostWeiBoViewController *postWeiBoVC = [[PostWeiBoViewController alloc] initWithNibName:nil bundle:nil andPlaceText:[NSString stringWithFormat:@"#%@#",_topicName]];
    [self presentViewController:postWeiBoVC animated:YES completion:nil];
}

- (void)loadNewData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_isMore)
    {
        if (ARRAY_NOT_EMPTY(_dataArray))
        {
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_topicName,@"topic_name",[[_dataArray objectAtIndex:[_dataArray count]-1] objectForKey:@"feed_id"],@"max_id", nil];
        }
        else
        {
            [self stopRefreshing];
            return;
        }
    }
    else
    {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_topicName,@"topic_name", nil];
    }
    
//    [self showHudInView:self.view hint:@"加载中..."];
    [DHHshowLoading showGrayLoadingForView:self.view allowUserInteraction:YES];
    [Api requestWithMethod:@"GET" withPath:API_URL_TopicDetail withParams:params withSuccess:^(id responseObject){
        //NSLog(@"%@",responseObject);
        if (![[responseObject objectForKey:@"status"] intValue])
        {
            [self stopRefreshing];
            [DHHshowLoading hideLoadingForView:self.view];
            [self showHudInView:self.view showHint:@"该专辑被屏蔽"];
            self.rightButton.hidden = YES;
            return ;
        }
        if (!_isMore)
        {
            if ([_dataArray count])
            {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            _dataDictionary = responseObject;
            [self creatUpViewWithData:responseObject];
        }
        else
        {
            if (ARRAY_NOT_EMPTY([responseObject objectForKey:@"data"]))
            {
                [_dataArray addObjectsFromArray:[responseObject objectForKey:@"data"]];
            }
            else
            {
                [self stopRefreshing];
                _isMore = NO;
                [DHHshowLoading hideLoadingForView:self.view];
                [self showHudInView:self.view showHint:@"没有更多了"];
                return;
            }
        }
        [self stopRefreshing];
        _isMore = NO;
        [DHHshowLoading hideLoadingForView:self.view];
        [_tableView reloadData];
    } withError:^(NSError *error){
        [self stopRefreshing];
        _isMore = NO;
        [DHHshowLoading hideLoadingForView:self.view];
        [self showHudInView:self.view showHint:@"请检查网络设置"];
    }];
}

- (void)creatUpViewWithData:(NSDictionary *)data
{
    
    UIView *bgView = [[UIView alloc] init];
    bgView.userInteractionEnabled = YES;
    bgView.backgroundColor = BG_COLOR;
    
    UIView *customView = [[UIView alloc] init];
    customView.userInteractionEnabled = YES;
    customView.backgroundColor = [UIColor whiteColor];
    [bgView addSubview:customView];
    
    //封面
    UIImageView *customImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 200)];
    [customImageView sd_setImageWithURL:[NSURL URLWithString:[[data objectForKey:@"detail"] objectForKey:@"pic"]] placeholderImage:[UIImage imageNamed:@"Topic_morentupian.jpg"]];
    customImageView.userInteractionEnabled = YES;
    customImageView.contentMode = UIViewContentModeScaleAspectFill;
    customImageView.clipsToBounds = YES;
    customView.userInteractionEnabled = YES;
    [customView addSubview:customImageView];
    
    UIControl *customControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 200)];
    [customControl addTarget:self action:@selector(customImageViewClicked) forControlEvents:UIControlEventTouchUpInside];
    [customImageView addSubview:customControl];
    
    //用户头像
    UIImageView *userHeadImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(customImageView.frame)-30, 60, 60)];
    [userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[[[[data objectForKey:@"detail"] objectForKey:@"userinfo"] objectForKey:@"avatar"] objectForKey:@"avatar_middle"]] placeholderImage:[UIImage imageNamed:@"morentouxiang"]];
    userHeadImageView.layer.cornerRadius = 30;
    userHeadImageView.layer.borderWidth = 1;
    userHeadImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    userHeadImageView.layer.masksToBounds = YES;
    [customView addSubview:userHeadImageView];
    
    //创建者
    UILabel *creatrLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(customImageView.frame)-30, UI_SCREEN_WIDTH-90, 30)];
    NSString *createrString = [[[data objectForKey:@"detail"] objectForKey:@"userinfo"] objectForKey:@"uname"];
    creatrLabel.text = [NSString stringWithFormat:@"%@",createrString];
    creatrLabel.textColor = [UIColor whiteColor];
    [customView addSubview:creatrLabel];
    
    //阅读数
    NSString *readNumString = [NSString stringWithFormat:@"%@ 阅读",[[data objectForKey:@"detail"] objectForKey:@"view_count"]];
    CGFloat readNumW = [readNumString boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    UILabel *readNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, CGRectGetMaxY(customImageView.frame)+10, readNumW, 30)];
    readNumLabel.textAlignment = NSTextAlignmentCenter;
    readNumLabel.font = [UIFont systemFontOfSize:14];
    readNumLabel.text = readNumString;
    readNumLabel.textColor = CONTENT_COLOR;
    [customView addSubview:readNumLabel];

    //分享数
    NSString *trendString = [NSString stringWithFormat:@"%@ 分享", [[data objectForKey:@"detail"] objectForKey:@"count"]];
    CGFloat trendW = [trendString boundingRectWithSize:CGSizeMake(300, 1000) options:NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.width;
    UILabel *trendsLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(readNumLabel.frame)+10, CGRectGetMaxY(customImageView.frame)+10, trendW, 30)];
    trendsLabel.textAlignment = NSTextAlignmentCenter;
    trendsLabel.font = [UIFont systemFontOfSize:14];
    trendsLabel.text = trendString;
    trendsLabel.textColor = CONTENT_COLOR;
    [customView addSubview:trendsLabel];
    
    UILabel *line = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(userHeadImageView.frame)+10, UI_SCREEN_WIDTH, 0.5)];
    line.backgroundColor = BG_COLOR;
    [customView addSubview:line];
    
    //简介
    NSString *string = [[data objectForKey:@"detail"] objectForKey:@"des"];
    if(!STRING_NOT_EMPTY(string)) {
        string = @"暂时无简介";
    }
    CGFloat height = [string boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH-20, 1000) options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesFontLeading | NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14]} context:nil].size.height;
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(line.frame), UI_SCREEN_WIDTH-20, height+20)];
    contentLabel.font = [UIFont systemFontOfSize:14];
    contentLabel.text = string;
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = CONTENT_COLOR;
    [customView addSubview:contentLabel];
    
    //修改坐标
    customView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, CGRectGetMaxY(contentLabel.frame));
    
    //下半部分
    UIView *oparView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(customView.frame)+10, UI_SCREEN_WIDTH-20, 50)];
    oparView.backgroundColor = [UIColor whiteColor];
    oparView.userInteractionEnabled = YES;
    [bgView addSubview:oparView];
    
    //粉丝数
    UIView *fansView = [[UIView alloc] initWithFrame:CGRectMake(10, 10, UI_SCREEN_WIDTH-70, 30)];
    fansView.userInteractionEnabled = YES;
    [oparView addSubview:fansView];
    
    UIControl *fansControl = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH-70, 30)];
    [fansControl addTarget:self action:@selector(countClicked) forControlEvents:UIControlEventTouchUpInside];
    [fansView addSubview:fansControl];
    
    UILabel *fansCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH-70, 30)];
    NSString *fansString = [NSString stringWithFormat:@"%@订阅",[[data objectForKey:@"detail"] objectForKey:@"favorite_count"]];
    fansCountLabel.text = fansString;
    fansCountLabel.textColor = RGBA(60, 180, 20);
    fansCountLabel.font = [UIFont systemFontOfSize:14];
    [fansView addSubview:fansCountLabel];
    
    //图片墙
    UIButton *imageWallBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageWallBtn.frame = CGRectMake(oparView.frame.size.width-40, 10, 30, 30);
    [imageWallBtn setImage:[UIImage imageNamed:@"TopicDetail_imgWall"] forState:UIControlStateNormal];
    [imageWallBtn addTarget:self action:@selector(wallBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [oparView addSubview:imageWallBtn];
    
    bgView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, CGRectGetMaxY(oparView.frame)+5);
    _tableView.tableHeaderView = bgView;
    
    [_barView removeFromSuperview];
    
    //底部bar
    _barView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-50, UI_SCREEN_WIDTH, 50)];
    _barView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:0.7];
    _barView.userInteractionEnabled = YES;
    [self.view addSubview:_barView];
    
    _subscribeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _subscribeBtn.frame = CGRectMake(10, 10, 80, 30);
    [_subscribeBtn setImage:[UIImage imageNamed:@"Find_biaoqian_detail_dingyue"] forState:UIControlStateNormal];
    [_subscribeBtn addTarget:self action:@selector(setClicked) forControlEvents:UIControlEventTouchUpInside];
    _subscribeBtn.tag = 1;
    [_barView addSubview:_subscribeBtn];
    
    _postTopicBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _postTopicBtn.frame = CGRectMake(UI_SCREEN_WIDTH/2-40, 10, 80, 30);
    [_postTopicBtn setImage:[UIImage imageNamed:@"Find_biaoqian_detail_Post"] forState:UIControlStateNormal];
    [_postTopicBtn addTarget:self action:@selector(postButtonClick) forControlEvents:UIControlEventTouchUpInside];
    _postTopicBtn.tag = 2;
    [_barView addSubview:_postTopicBtn];
    
    _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _shareBtn.frame = CGRectMake(UI_SCREEN_WIDTH-90, 10, 80, 30);
    [_shareBtn setImage:[UIImage imageNamed:@"Find_biaoqian_detail_share"] forState:UIControlStateNormal];
    [_shareBtn addTarget:self action:@selector(shareBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    _shareBtn.tag = 3;
    [_barView addSubview:_shareBtn];
    
    NSString *uidString = [[[data objectForKey:@"detail"] objectForKey:@"userinfo"] objectForKey:@"uid"];
    if ([uidString isEqualToString:[[UserModel userPassport] objectForKey:@"uid"]]) {
        [_subscribeBtn setImage:[UIImage imageNamed:@"TopicDetail_setting"] forState:UIControlStateNormal];
        _ishost = YES;
    } else {
        _ishost = NO;
        if([[[data objectForKey:@"detail"] objectForKey:@"favorite"] integerValue]) {
            [_subscribeBtn setImage:[UIImage imageNamed:@"Find_biaoqian_detail_yidingyue"] forState:UIControlStateNormal];
            _isAttention = YES;
        } else {
            _isAttention = NO;
            [_subscribeBtn setImage:[UIImage imageNamed:@"Find_biaoqian_detail_dingyue"] forState:UIControlStateNormal];
        }
    }
    
    _params = [NSMutableDictionary dictionary];
    [_params setObject:[[data objectForKey:@"detail"] objectForKey:@"topic_id"] forKey:@"topic_id"];
}

- (void)customImageViewClicked
{
    NSMutableArray *photos = [NSMutableArray array];
    MJPhoto *photo = [[MJPhoto alloc] init];
    photo.url = [NSURL URLWithString:[[_dataDictionary objectForKey:@"detail"] objectForKey:@"pic"]];// 图片路径
    UIView *view = [_tableView.tableHeaderView.subviews objectAtIndex:0];
    photo.srcImageView = [view.subviews objectAtIndex:0]; // 来源于哪个UIImageView
    [photos addObject:photo];
    // 2.显示相册
    MJPhotoBrowser *browser = [[MJPhotoBrowser alloc] init];
    browser.currentPhotoIndex = 0; // 弹出相册时显示的第一张图片是？
    browser.photos = photos; // 设置所有的图片
    [browser show];
}

- (void)countClicked
{
//    FansListViewController *fansVc = [[FansListViewController alloc] initWithNibName:nil bundle:nil andID:[_params objectForKey:@"topic_id"] andType:fansListTypeTopic];
//    [self.navigationController pushViewController:fansVc animated:YES];
}
- (void)setClicked
{
    if(_ishost) {
        TopicSettingViewController *vc = [[TopicSettingViewController alloc] initWithTopicId:[_params objectForKey:@"topic_id"]];
        [self.navigationController pushViewController:vc animated:YES];
    } else {
        if(_isAttention) {
            [LPActionSheetView showInView:self.view title:@"您确定取消订阅吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@[@"确定"] tagNumber:1];
        } else {
            [Api requestWithMethod:@"POST" withPath:API_URL_ATTENTIONTOPIC withParams:_params withSuccess:^(id responseObject) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                if([[dic objectForKey:@"status"] integerValue]) {
                    [self hideHud];
                    [self loadNewData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ATTENTIONCHANGED" object:nil userInfo:nil];
                } else {
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"订阅失败，请重试"];
                }
            } withError:^(NSError *error) {
                [self hideHud];
                [self showHudInView:self.view showHint:@"请检查网络设置"];
            }];
        }
    }
    
}
- (void)wallBtnClicked
{
//    PictureWallCollectionViewController *vc = [[PictureWallCollectionViewController alloc] init];
//    vc.topicName = _topicName;
//    [self.navigationController pushViewController:vc animated:YES];
}
#pragma mark LPActionSheetViewDelegate
- (void)actionSheet:(LPActionSheetView *)actionSheetView clickedOnButtonIndex:(NSInteger)buttonIndex
{
    if (actionSheetView.tag == 1) {
        if(buttonIndex == 0) {
            [Api requestWithMethod:@"POST" withPath:API_URL_NOTATTENTIONTOPIC withParams:_params withSuccess:^(id responseObject) {
                NSDictionary *dic = (NSDictionary *)responseObject;
                if([[dic objectForKey:@"status"] integerValue]) {
                    [self hideHud];
                    [self loadNewData];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"ATTENTIONCHANGED" object:nil userInfo:nil];
                } else {
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"取消订阅	失败，请重试"];
                }
            } withError:^(NSError *error) {
                [self hideHud];
                [self showHudInView:self.view showHint:@"请检查网络设置"];
            }];
        }
    }
    
}
- (void)actionSheetClickedOnDestructiveButton:(LPActionSheetView *)actionSheetView
{
    if (actionSheetView.tag == 2)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[_dataArray objectAtIndex:_index] objectForKey:@"feed_id"],@"feed_id",nil];
        [self showHudInView:self.view showHint:@"加载中"];
        [Api requestWithMethod:@"GET" withPath:API_URL_DEL_weibo withParams:params withSuccess:^(id responseObject){
            if ([[responseObject objectForKey:@"status"] intValue])
            {
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"WeiBoDel" object:self userInfo:nil];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MeStatusChanged" object:self userInfo:nil];
            }
            else
            {
                
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
            [DHHshowLoading hideLoadingForView:self.view];
        } withError:^(NSError *error){
            [DHHshowLoading hideLoadingForView:self.view];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    }
    else if (actionSheetView.tag == 3)
    {
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[_dataArray objectAtIndex:_index] objectForKey:@"feed_id"],@"feed_id",@"3",@"from",@"举报",@"reason",nil];
        [self showHudInView:self.view showHint:@"加载中"];
        [Api requestWithMethod:@"GET" withPath:API_URL_DENOUNCE_weibo withParams:params withSuccess:^(id responseObject){
            if ([[responseObject objectForKey:@"status"] intValue])
            {
                [DHHshowLoading hideLoadingForView:self.view];
                [self showHudInView:self.view showHint:@"举报成功"];
            }
            else
            {
                [DHHshowLoading hideLoadingForView:self.view];
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
        } withError:^(NSError *error){
            [DHHshowLoading hideLoadingForView:self.view];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    } else if (actionSheetView.tag == 4) {
        
    }
}
#pragma mark - MJRefreshBaseViewDelegate
-(void)stopRefreshing
{
	[_tableView.header endRefreshing];
	[_tableView.footer endRefreshing];
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PostWeiBoSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WeiBoDetailZan" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"commentWeiBoSucceed" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"WeiBoDel" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"TOPICSETTINGSUCCED" object:nil];
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _tableView) {
        CGPoint pt = scrollView.contentOffset;
        if(pt.y <= 200.0) {
            self.titleImageView.backgroundColor = [UIColor colorWithWhite:1.0 alpha:pt.y/200.0];
            self.titleLabel.textColor = [UIColor colorWithWhite:(200-pt.y)/200.0 alpha:1.0];
        }
        if(pt.y < 100.0) {
            self.leftButton.alpha = (100.0-pt.y)/100.0;
            [self.leftButton setImage:[UIImage imageNamed:@"Find_topic_detail_back"] forState:UIControlStateNormal];
        } else if (pt.y >= 100 && pt.y < 200) {
            [self.leftButton setImage:[UIImage imageNamed:@"base_fanhui"] forState:UIControlStateNormal];
            self.leftButton.alpha = pt.y/100.0;
        }
    }
}
#pragma mark - scrollViewDelegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    if(scrollView == _tableView) {
        if(velocity.y > 0.0) {
            [UIView animateWithDuration:0.3 animations:^{
                _barView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 50);
            } completion:^(BOOL finished) {
            }];
        } else {
            [UIView animateWithDuration:0.3 animations:^{
                _barView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-50, UI_SCREEN_WIDTH, 50);
            } completion:^(BOOL finished) {
            }];
        }
    }
}
#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    WeiBoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == NULL)
    {
        cell = [[WeiBoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    [cell updateCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [WeiBoTableViewCell heightForCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.01;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.row;
    _isForward = NO;
    
//    PengYouQuanDetailViewController *pengYouQuanDetailVC = [[PengYouQuanDetailViewController alloc] initWithNibName:nil bundle:nil andFeedID:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"feed_id"]];
//    pengYouQuanDetailVC.type = 1;
//    [self.navigationController pushViewController:pengYouQuanDetailVC animated:YES];
}

#pragma mark - WeiBoTableViewCellDelegate

- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotocategoryDetail:(NSDictionary *)dic
{
//    LabelPlazaViewDetailController *labelPlazaDetailViewNC = [[LabelPlazaViewDetailController alloc] initWithLabelPlazaID:[dic objectForKey:@"feed_category_id"] andLabelPlazaName:[dic objectForKey:@"title"]];
//    [self.navigationController pushViewController:labelPlazaDetailViewNC animated:YES];
}

- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell forwadButtonClickedWithIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *dataDictionary = [_dataArray objectAtIndex:indexPath.row];
    
    if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"post"])
    {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : 发表的分享",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostType:PostTypeForward andPostShowTitle:[NSString stringWithFormat:@"@%@",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostShowImage:nil andPostShowcontent:[dataDictionary objectForKey:@"content"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    } else if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"postimage"]) {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ :发表的分享",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostType:PostTypeForward andPostShowTitle:[NSString stringWithFormat:@"@%@",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostShowImage:[[[dataDictionary objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"attach_small"] andPostShowcontent:[dataDictionary objectForKey:@"content"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    } else if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"postvideo"]) {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : 发表的分享",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostType:PostTypeForward andPostShowTitle:[NSString stringWithFormat:@"@%@",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostShowImage:[[[dataDictionary objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"flashimg"] andPostShowcontent:[[[dataDictionary objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"title"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    } else if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"repost"] && [[[dataDictionary objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"post"])
    {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : %@",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"],[dataDictionary objectForKey:@"content"]] andPostType:PostTypeForward andPostShowTitle:[NSString stringWithFormat:@"@%@",[[[dataDictionary objectForKey:@"source_info"] objectForKey:@"user_info"] objectForKey:@"uname"]] andPostShowImage:nil andPostShowcontent:[[dataDictionary objectForKey:@"source_info"] objectForKey:@"content"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    } else if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"repost"] && [[[dataDictionary objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"postimage"])
    {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : %@",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"],[dataDictionary objectForKey:@"content"]] andPostType:PostTypeForward andPostShowTitle:[NSString stringWithFormat:@"@%@",[[[dataDictionary objectForKey:@"source_info"] objectForKey:@"user_info"] objectForKey:@"uname"]] andPostShowImage:[[[[dataDictionary objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"attach_small"] andPostShowcontent:[[dataDictionary objectForKey:@"source_info"] objectForKey:@"content"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    } else if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"repost"] && [[[dataDictionary objectForKey:@"source_info"] objectForKey:@"type"] isEqualToString:@"postvideo"])
    {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : %@",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"],[dataDictionary objectForKey:@"content"]] andPostType:PostTypeForward andPostShowTitle:[NSString stringWithFormat:@"@%@",[[[dataDictionary objectForKey:@"source_info"] objectForKey:@"user_info"] objectForKey:@"uname"]] andPostShowImage:[[[[dataDictionary objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"flashimg"] andPostShowcontent:[[[[dataDictionary objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"title"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    }
    else if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"weiba_post"])
    {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : 分享长文",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostType:PostTypeForward andPostShowTitle:[dataDictionary objectForKey:@"title"] andPostShowImage:[dataDictionary objectForKey:@"post_first_image"] andPostShowcontent:[dataDictionary objectForKey:@"content"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    }
    else if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"blog_post"])
    {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : 分享知识",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"]] andPostType:PostTypeForward andPostShowTitle:[dataDictionary objectForKey:@"title"] andPostShowImage:[dataDictionary objectForKey:@"post_first_image"] andPostShowcontent:[dataDictionary objectForKey:@"content"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    }
    else if ([[dataDictionary objectForKey:@"type"] isEqualToString:@"weiba_repost"] || [[dataDictionary objectForKey:@"type"] isEqualToString:@"blog_repost"])
    {
        PostCommentViewController *postCommentVC = [[PostCommentViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dataDictionary objectForKey:@"feed_id"] andPlaceHolderContent:[NSString stringWithFormat:@"//@%@ : %@",[[dataDictionary objectForKey:@"user_info"] objectForKey:@"uname"],[dataDictionary objectForKey:@"content"]] andPostType:PostTypeForward andPostShowTitle:[[dataDictionary objectForKey:@"source_info"] objectForKey:@"title"] andPostShowImage:[[dataDictionary objectForKey:@"source_info"] objectForKey:@"post_first_image"] andPostShowcontent:[[dataDictionary objectForKey:@"source_info"] objectForKey:@"content"]];
        [self presentViewController:postCommentVC animated:YES completion:nil];
    }
}
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell shareButtonClickedWithIndexPath:(NSIndexPath *)indexPath
{
    _index = indexPath.row;
    BOOL _isMe = [[[[_dataArray objectAtIndex:_index] objectForKey:@"user_info"] objectForKey:@"uid"] isEqualToString:[[UserModel userPassport] objectForKey:@"uid"]];
    [LPActivityView showInView:self.view delegate:self cancelButtonTitle:@"取消" shareButtonImagesNameArray:@[@"Activity_qq",@"Activity_weixin",@"Activity_pengyouquan",@"Activity_sina",@"Activity_kongjian"] downButtonImagesNameArray:@[_isMe?@"Activity_shanchu":@"Activity_jubao"] tagNumber:2];
//    [LPActivityView showInView:self.view delegate:self cancelButtonTitle:@"取消" shareButtonImagesNameArray:@[@"Activity_qq",@"Activity_weixin",@"Activity_pengyouquan",@"Activity_sina",@"Activity_kongjian"] downButtonImagesNameArray:nil tagNumber:2];
}
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell pinglunButtonClickedWithIndexPath:(NSIndexPath *)indexPath
{
    _index1 = indexPath.row;
    
    if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"can_comment"] intValue])
    {
        CommentView *commView = [[CommentView alloc]initWithFrame:CGRectMake(0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
        commView.delegate = self;
        [self.tabBarController.view addSubview:commView];
        [UIView animateWithDuration:0.3 animations:^{
            commView.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT);
        }];
    }
    else
    {
        [self showHudInView:self.view showHint:@"您没有权限评论TA的分享"];
    }
}
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell zanButtonClickedWithIndexPath:(NSIndexPath *)indexPath
{
    NSString *path = [[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"is_digg"] intValue]?API_URL_DEL_zan:API_URL_ADD_zan;
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"feed_id"],@"feed_id", nil];
	[Api requestWithMethod:@"get" withPath:path withParams:params withSuccess:^(id responseObject) {
        //NSLog(@"%@",responseObject);
		if ([[responseObject objectForKey:@"status"] intValue])
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:indexPath.row]];
            [dic setObject:[[dic objectForKey:@"is_digg"] intValue]?[NSString stringWithFormat:@"%d",[[dic objectForKey:@"digg_count"] intValue]-1]:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"digg_count"] intValue]+1] forKey:@"digg_count"];
            [dic setObject:[[dic objectForKey:@"is_digg"] intValue]?@"0":@"1" forKey:@"is_digg"];
            [_dataArray replaceObjectAtIndex:indexPath.row withObject:dic];
		}
        else
        {
			[self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
		}
        [_tableView reloadData];
	} withError:^(NSError *error) {
        [self showHudInView:self.view showHint:@"请检查网络设置"];
	}];
}
-(void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell videoButtonClickedWithIndexPath:(NSIndexPath *)indexPath
{
    
    if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"postvideo"])
    {
        if([[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"iframe"]) {
            BrowserViewController *browserVC = [[BrowserViewController alloc] initWithUrlString:[[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"flashvar"]];
            [self presentViewController:browserVC animated:YES completion:nil];
        } else {
            [self playVideoWithPath:[[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"flashvar"]];
        }
    }
    else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"repost"])
    {
        if([[[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"iframe"]) {
            BrowserViewController *browserVC = [[BrowserViewController alloc] initWithUrlString:[[[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"flashvar"]];
            [self presentViewController:browserVC animated:YES completion:nil];
        } else {
            [self playVideoWithPath:[[[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"source_info"] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"flashvar"]];
        }
    }
}
- (void)playVideoWithPath:(NSString *)path
{
    if(path.length == 0) {
        return;
    }
    if(!_playController) {
        _playController = [[MPMoviePlayerViewController alloc] initWithContentURL:[NSURL URLWithString:path]];
        _playController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        [self presentViewController:_playController animated:YES completion:^{
            
        }];
        [_playController.moviePlayer prepareToPlay];
        [_playController.moviePlayer play];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished) name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    }
}
- (void)playVideoFinished
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:nil];
    if (_playController) {
        [_playController.moviePlayer stop];
        _playController = nil;
    }
}
-(void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell showUserProfileByName:(NSString *)name
{
    NSLog(@"%@",name);
}
-(void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell showUrl:(NSString *)url
{
	BrowserViewController *browserVC = [[BrowserViewController alloc] initWithUrlString:url];
	[self presentViewController:browserVC animated:YES completion:^{}];
}
-(void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell tableViewCellClickAtIndex:(NSInteger)index
{
//    NSLog(@"%d",index);
    _index = index;
    _isForward = NO;
    
//    PengYouQuanDetailViewController *pengYouQuanDetailVC = [[PengYouQuanDetailViewController alloc] initWithNibName:nil bundle:nil andFeedID:[[_dataArray objectAtIndex:index] objectForKey:@"feed_id"]];
//    pengYouQuanDetailVC.type = 1;
//    [self.navigationController pushViewController:pengYouQuanDetailVC animated:YES];
}
-(void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotoForwardDetail:(NSDictionary *)dic
{
    _isForward = YES;
    
//    PengYouQuanDetailViewController *pengYouQuanDetailVC = [[PengYouQuanDetailViewController alloc] initWithNibName:nil bundle:nil andFeedID:[dic objectForKey:@"feed_id"]];
//    pengYouQuanDetailVC.type = 1;
//    [self.navigationController pushViewController:pengYouQuanDetailVC animated:YES];
}
-(void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotoWeibaDetail:(NSDictionary *)dic
{
    NSString *postID = [dic objectForKey:@"app_row_id"];
    CircleDetailViewController *circleDetailVC = [[CircleDetailViewController alloc] initWithNibName:nil bundle:nil andID:postID];
    [self.navigationController pushViewController:circleDetailVC animated:YES];
}
-(void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotoBlogDetail:(NSDictionary *)dic
{
    NSString *blogID = [dic objectForKey:@"app_row_id"];
    KnowledgeDetailViewController *knowledgeDetailVC = [[KnowledgeDetailViewController alloc] initWithNibName:nil bundle:nil andID:blogID];
    [self.navigationController pushViewController:knowledgeDetailVC animated:YES];
}
- (void)weiboTableViewCell:(WeiBoTableViewCell *)weiboTableViewCell gotoLongWeiboDetail:(NSDictionary *)dic
{
//    LongWeiboDetailViewController *knowledgeDetailVC = [[LongWeiboDetailViewController alloc] initWithNibName:nil bundle:nil andID:[dic objectForKey:@"app_row_id"]];
//    [self.navigationController pushViewController:knowledgeDetailVC animated:YES];
}
#pragma mark - CommentDelegate
-(void)sendTextForComment:(NSString *)commStr
{
	NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:commStr,@"content",@"3",@"from",[[_dataArray objectAtIndex:_index1] objectForKey:@"feed_id"],@"feed_id", nil];
    [self showHudInView:self.view hint:@"评论中..."];
	[Api requestWithMethod:@"get" withPath:API_URL_COMMENT_weibo withParams:param withSuccess:^(id responseObject) {
		if ([[responseObject objectForKey:@"status"] intValue]==1)
        {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index1]];
            [dic setObject:[NSString stringWithFormat:@"%d",[[dic objectForKey:@"comment_count"] intValue]+1] forKey:@"comment_count"];
            [_dataArray replaceObjectAtIndex:_index1 withObject:dic];
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
    NSString *content = @"";
    NSString *title = @"";
    if(activityView.tag == 1) {
        content = [NSString stringWithFormat:@"来自到处是宝%@的分享",[UserModel userUname]];
        title = _topicName;
    } else {
        title = [[_dataArray objectAtIndex:_index] objectForKey:@"content"];
        if(title.length > 80) {
            title = [[[_dataArray objectAtIndex:_index] objectForKey:@"content"] substringToIndex:80];
        }
        content = [NSString stringWithFormat:@"来自到处是宝%@的分享",[UserModel userUname]];
    }
    NSString *shareUrl;
    
    id shareImageUrl;
    if(activityView.tag == 1) {
        _isShareTopic = YES;
        shareUrl = [NSString stringWithFormat:@"%@%@",API_URL_TOPIC,[_topicName stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        if (STRING_NOT_EMPTY([[_dataDictionary objectForKey:@"detail"] objectForKey:@"pic"])) {
            shareImageUrl = [ShareSDK imageWithUrl:[[_dataDictionary objectForKey:@"detail"] objectForKey:@"pic"]];
        } else {
            shareImageUrl = [ShareSDK imageWithPath:[[NSBundle mainBundle] pathForResource:@"WeiboDetail_beijing@2x" ofType:@"png"]];
        }
    } else {
        _isShareTopic = NO;
        shareUrl = [NSString stringWithFormat:@"%@%@",API_URL_XiangQing,[[_dataArray objectAtIndex:_index] objectForKey:@"feed_id"]];
        if (ARRAY_NOT_EMPTY([[_dataArray objectAtIndex:_index] objectForKey:@"attach_info"])) {
            shareImageUrl = [ShareSDK imageWithUrl:[[[[_dataArray objectAtIndex:_index] objectForKey:@"attach_info"] objectAtIndex:0] objectForKey:@"attach_small"]];
        } else {
            shareImageUrl = [ShareSDK imageWithPath:APPICON];
        }
    }

    if(index < 100) {
        WHShare *share = [[WHShare alloc] init];
        share.delegate = self;
        [share whShareWithTitle:title content:content shareImageUrl:shareImageUrl urlString:shareUrl index:index];
    } else {
        if(activityView.tag == 2) {
            if ([[[[_dataArray objectAtIndex:_index] objectForKey:@"user_info"] objectForKey:@"uid"] isEqualToString:[[UserModel userPassport] objectForKey:@"uid"]])
            {
                [LPActionSheetView showInView:self.view title:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil tagNumber:2];
            }
            else
            {
                [LPActionSheetView showInView:self.view title:@"确定要举报吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil tagNumber:3];
            }
        } else {
            if ([[[_dataDictionary objectForKey:@"user_info"] objectForKey:@"uid"] isEqualToString:[[UserModel userPassport] objectForKey:@"uid"]])
            {
                //                    [LPActionSheetView showInView:self.view title:@"确定要删除吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil tagNumber:2];
            }
            else
            {
                //                    [LPActionSheetView showInView:self.view title:@"确定要举报吗？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:nil tagNumber:4];
            }
            
        }
    }
}
#pragma mark - WHShareDelegate
- (void)WHShareSucceed
{
    NSDictionary *params;
    if(_isShareTopic) {
        params = [NSDictionary dictionaryWithObjectsAndKeys:@"", @"feed_id",  @"", @"source_uid", [[UserModel userPassport] objectForKey:@"uid"], @"share_uid", nil];
    } else {
        params = [NSDictionary dictionaryWithObjectsAndKeys:[[_dataArray objectAtIndex:_index] objectForKey:@"feed_id"], @"feed_id",  [[[_dataArray objectAtIndex:_index] objectForKey:@"user_info"] objectForKey:@"uid"], @"source_uid", [[UserModel userPassport] objectForKey:@"uid"], @"share_uid", nil];
    }
    [Api requestWithMethod:@"get" withPath:API_URL_Statistic withParams:params withSuccess:^(id responseObject) {
    } withError:^(NSError *error) {
    }];
    [self showHudInView:self.view showHint:@"分享成功"];
}
- (void)WHShareFailedWithError:(NSString *)error
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享失败" message:error delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alertView show];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end