//
//  FirstPageViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/1.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "FirstPageViewController.h"
#import "DHHBannerView.h"

#import "AntiqueCatalogData.h"
#import "MybookCatalogdata.h"

#import "AntiqueCatalogViewCell.h"
#import "firstScrollView.h"
#import "LeftMenuView.h"

#import "MybookCollectionViewCell.h"
#import "MybookView.h"

#import "CatalogDetailsViewController.h"
#import "headerViewbutton.h"

#import "ClassificationViewController.h"
#import "FllowViewController.h"
#import "AuctionViewController.h"
#import "SearchViewController.h"

#import "LoginViewController.h"
#import "FootprintViewController.h"

#import "UserinfoViewController.h"
#import "MyMessageViewController.h"
#import "SettingViewController.h"
#import "InviteViewController.h"
#import "ClassficationViewController.h"
#import "MJRefresh.h"
#import "DownViewController.h"
#import "AFHTTPRequestOperation.h"
#import "FMDB.h"
#import "MF_Base64Additions.h"
#import "DownFileMannger.h"

@interface FirstPageViewController()<DHHBannerViewDelegate,UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,MybookViewDelegate,LeftMenuViewDelegate>{
    dispatch_group_t groupQueue;
    
    NSMutableDictionary *dicOperation;
    dispatch_semaphore_t fd_sema;
//    NSOperationQueue *queue;
    dispatch_queue_t myCustomQueue;
    FMDatabase *db;
    NSOperationQueue*operationQueue;
    
    
}

@property (nonatomic,strong)UIButton *antiquecatalogButton;
@property (nonatomic,strong)UIButton *bookcaseButton;
@property (nonatomic,strong)UIImageView *line;

@property (nonatomic,strong)UIScrollView *scrollView;
@property (nonatomic,strong)UITableView *tableVeiw;
@property (nonatomic,strong)UIView *tableheaderVeiw;
@property (nonatomic,strong)LeftMenuView *leftmenuveiw;

@property (nonatomic,strong)NSMutableArray *antiqueCatalogArray;
@property (nonatomic,strong)NSMutableArray *antiqueCatalogDataArray;
@property (nonatomic,assign)BOOL isMore;

@property (nonatomic,strong)MybookView *mybookView;
@property (nonatomic,strong)NSMutableArray *mybookCatalogArray;
@property (nonatomic,strong)NSMutableArray *mybookCatalogDataArray;

@property (nonatomic,strong)DHHBannerView *bannerView;
@property (nonatomic,strong)UIButton *Classification;
@property (nonatomic,strong)UIButton *Auction;
@property (nonatomic,strong)UIButton *Follow;

@property (nonatomic,assign)BOOL      isLogin;

@property (nonatomic,strong)UIView   *upView;
@property (nonatomic,strong)UIButton  *cancel;
@property (nonatomic,strong)UIButton   *sure;
@property (nonatomic,strong)UIButton   *downbtn;
@property (nonatomic,assign)BOOL       edit;
@property (nonatomic,strong)NSDictionary * downListDict;
@property (nonatomic,strong) NSMutableArray * dowLoadArray;
@end

@implementation FirstPageViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addmybook:) name:@"addmybook" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(deleteOVer:) name:@"deleteOVer" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(addFOFQueues:) name:@"AddFIFOF" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dowLoadNextFile:) name:@"DownNextFiled" object:nil];
        //[[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delayMethod) name:@"DownNextFiled" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(stopDowLoadFile:) name:@"STOPDOWN" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goDowLoadFile:) name:@"GODOWN" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(fialdDownNext:) name:@"FailDownFiledNext" object:nil];


        
    }
    return self;
}

- (void)addmybook:(NSNotificationCenter *)obj{
    
    _isMore = NO;
    [self loadmybookdata];
    
}

- (void)deleteOVer:(NSNotificationCenter *)obj{
    
    [_upView removeFromSuperview];
    [_downbtn removeFromSuperview];
    _upView = nil;
    _edit = NO;
    _scrollView.scrollEnabled = YES;
    
}

-(void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"addmybook" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"deleteOVer" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AddFIFOF" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"DownNextFiled" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"STOPDOWN" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"GODOWN" object:nil];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"FailDownFiledNext" object:nil];


}

//-(void)viewDidDisappear:(BOOL)animated{
//    [super viewDidDisappear: animated];
//    [db close];
//}
//
//-(void)viewWillAppear:(BOOL)animated{
//    [super viewWillAppear:animated];
//
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dowLoadArray = [NSMutableArray array];
    
    db = [Api initTheFMDatabase];

    operationQueue = [[NSOperationQueue alloc] init];
//    [db open];
//    NSOperationQueues
    [operationQueue setMaxConcurrentOperationCount:10];
   groupQueue = dispatch_group_create();
    fd_sema = dispatch_semaphore_create(0);
    myCustomQueue = dispatch_queue_create("example.MyCustomQueue", DISPATCH_QUEUE_SERIAL);

    dicOperation = [[NSMutableDictionary alloc]init];
//    queue = [[NSOperationQueue alloc] init];
//    [queue setMaxConcurrentOperationCount:1];
//    
    self.titleLabel.hidden = YES;
    [self.leftButton setImage:[UIImage imageNamed:@"icon_user"] forState:UIControlStateNormal];
    [self.leftButton setImageEdgeInsets:UIEdgeInsetsMake(-3,10,-5,-10)];
    
    [self.rightButton setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,-10)];
    
    
    _isMore = NO;
    _antiqueCatalogArray = [[NSMutableArray alloc]init];
    _antiqueCatalogDataArray = [[NSMutableArray alloc]init];
    _mybookCatalogArray  = [[NSMutableArray alloc]init];
    _mybookCatalogDataArray = [[NSMutableArray alloc]init];
    
    _edit = NO;
    
    self.view.userInteractionEnabled = YES;
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePanGesture:)];
    [self.view addGestureRecognizer:panGestureRecognizer];
    
    [self CreatUI];
    
    [self loaddata];
    [self loadmybookdata];
    [self loaduserdata];
    
}

- (void)leftButtonClick:(id)sender{
    
    [_leftmenuveiw click];
    
}
- (void)rightButtonClick:(id)sender{
    
    SearchViewController *searchVC = [[SearchViewController alloc]init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

- (void)loaddata
{
    NSDictionary *prams = [NSDictionary dictionary];
    if (_isMore) {
        prams = @{@"max_id":@"1"};
    }else{
        
        prams = @{@"max_id":@"0"};
    }
    
    [Api showLoadMessage:@"正在加载数据"];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_index withParams:prams withSuccess:^(id responseObject) {
        NSArray *array = [[NSArray alloc]init];
        array = responseObject;
        if (ARRAY_NOT_EMPTY(array)) {
            for (NSDictionary *dic in array) {
                [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
            }
            [_tableVeiw reloadData];
//            NSLog(@"%@",_antiqueCatalogDataArray);
        }else{
           
        }
        [Api hideLoadHUD];
        _isMore = NO;
        
        
        
    } withError:^(NSError *error) {
        [Api hideLoadHUD];
         NSLog(@"失败 %@",error);
    }];
}

- (void)loadmybookdata{
    NSDictionary *prams = [NSDictionary dictionary];
    if (_isMore) {
        prams = @{@"max_id":@"1"};
    }else{
        prams = @{@"max_id":@"0"};
    }
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_userBook withParams:prams withSuccess:^(id responseObject) {
         NSArray *array = [[NSArray alloc]init];
        array = responseObject;
        
        if (!_isMore) {
            [_mybookCatalogDataArray removeAllObjects];
        }
        if (ARRAY_NOT_EMPTY(array)) {
            for (NSDictionary *dic in array) {
                [_mybookCatalogDataArray addObject:[MybookCatalogdata WithMybookCatalogDataDic:dic]];
            }
            [_mybookView loadMybookCatalogdata:_mybookCatalogDataArray];
        }else{
            
        }
        _isMore = NO;
        
    } withError:^(NSError *error) {
        
    }];
    
}

#pragma mark- 读取用户信息
- (void)loaduserdata{
    
//    if (_isLogin) {
//        [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER withParams:nil withSuccess:^(id responseObject) {
//            
//            NSLog(@"%@",responseObject);
//            
//        } withError:^(NSError *error) {
//            
//        }];
//    }

}

#pragma mark - LeftMenuViewDelegate
- (void)gologin{
    
    LoginViewController *loginVC = [[LoginViewController alloc]init];
    [self.navigationController pushViewController:loginVC animated:YES];
    
}
- (void)golist:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
        {
            switch (indexPath.row) {
                case 0:
                {
                    FootprintViewController *footVC = [[FootprintViewController alloc]init];
                    [self.navigationController pushViewController:footVC animated:YES];
                }
                    break;
                case 1:
                {
                    MyMessageViewController *mymessageVC = [[MyMessageViewController alloc]init];
                    [self.navigationController pushViewController:mymessageVC animated:YES];
                }
                    break;
                case 2:
                {
                    InviteViewController * page = [[InviteViewController alloc]init];
                    [self.navigationController pushViewController:page animated:YES];
                }
                    break;
                case 3:
                {
                    UserinfoViewController *userinfoVC = [[UserinfoViewController alloc]init];
                    [self.navigationController pushViewController:userinfoVC animated:YES];
                }
                    break;
                case 4:
                {
                    DownViewController *downVc = [[DownViewController alloc]init];
                    downVc.dataDict = self.downListDict;
                    [self.navigationController pushViewController:downVc animated:YES];
                    
                    
                }
                    break;
                default:
                    break;
            }
        }
            break;
        case 1:
        {
            SettingViewController *systemSettingVC = [[SettingViewController alloc] init];
            [self.navigationController pushViewController:systemSettingVC animated:YES];
            
        }
            break;
            
        default:
            break;
    }
}

- (void)CreatUI
{
    _antiquecatalogButton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"图录" Withcolor:Deputy_Colour WithSelectcolor:Essential_Colour Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
    _antiquecatalogButton.frame = CGRectMake(UI_SCREEN_WIDTH/2-80, 20, 80, 44);
    [self.titleImageView addSubview:_antiquecatalogButton];
    _antiquecatalogButton.selected = YES;
    _antiquecatalogButton.tag = 1;
    [_antiquecatalogButton addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    
    _bookcaseButton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"云库" Withcolor:Deputy_Colour WithSelectcolor:Essential_Colour Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
    _bookcaseButton.frame = CGRectMake(UI_SCREEN_WIDTH/2, 20, 80, 44);
    [self.titleImageView addSubview:_bookcaseButton];
    _bookcaseButton.selected = NO;
    _bookcaseButton.tag = 2;
    [_bookcaseButton addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    _line = [[UIImageView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/2-55, 61, 30, 3)];
    _line.backgroundColor = Essential_Colour;
    [self.titleImageView addSubview:_line];
    
    _scrollView = [[firstScrollView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW)];
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*2, 0);
    _scrollView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    [self.view addSubview:_scrollView];
    
    _tableheaderVeiw = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 0)];
    _tableheaderVeiw.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    
    NSArray *URLs = @[@"http://admin.guoluke.com:80/userfiles/files/admin/201509181708260671.png",
                      @"http://admin.guoluke.com:80/userfiles/files/admin/201509181707000766.png",
                      @"http://img.guoluke.com/upload/201509091054250274.jpg"];
    
    _bannerView = [DHHBannerView bannerViewWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_WIDTH/45*16)
                                                            delegate:self
                                                           imageURLs:URLs
                                                    placeholderImage:nil
                                                       timerInterval:5.0f
                                       currentPageIndicatorTintColor:[UIColor redColor]
                                              pageIndicatorTintColor:[UIColor whiteColor]];
    [_tableheaderVeiw addSubview:_bannerView];
    [self addtableheaderVeiwbutton];
    _tableheaderVeiw.frame = CGRectMake(0, 0, UI_SCREEN_WIDTH, CGRectGetMaxY(_bannerView.frame)+60);
    
    _tableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableVeiw.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableVeiw.showsHorizontalScrollIndicator=NO;
    _tableVeiw.showsVerticalScrollIndicator=NO;
    _tableVeiw.allowsMultipleSelection = NO;
    _tableVeiw.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableVeiw.delegate = self;
    _tableVeiw.dataSource = self;
    [self setupRefresh];
    [self setupLoadMore];
    _tableVeiw.tableHeaderView = _tableheaderVeiw;
    
    [_scrollView addSubview:_tableVeiw];
    
    
    _mybookView = [[MybookView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_SHOW)];
    _mybookView.delegate = self;
    [_scrollView addSubview:_mybookView];
    
    _leftmenuveiw = [[LeftMenuView alloc]initWithFrame:CGRectMake(-UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT)];
    _leftmenuveiw.delegate = self;
    [self.view addSubview:_leftmenuveiw];
    
    
}
- (void)addtableheaderVeiwbutton{
    
    _Classification = [[headerViewbutton alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_bannerView.frame), UI_SCREEN_WIDTH/3, 60)];
    [_Classification setImage:[UIImage imageNamed:@"Classification"] forState:UIControlStateNormal];
    _Classification.tag = 1000;
    [_Classification setTitle:@"分类" forState:UIControlStateNormal];
    [_Classification addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    _Auction = [[headerViewbutton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/3, CGRectGetMaxY(_bannerView.frame), UI_SCREEN_WIDTH/3, 60)];
    [_Auction setImage:[UIImage imageNamed:@"Auction"] forState:UIControlStateNormal];
    _Auction.tag = 1001;
    [_Auction setTitle:@"拍卖" forState:UIControlStateNormal];
    [_Auction addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    _Follow = [[headerViewbutton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH/3*2, CGRectGetMaxY(_bannerView.frame), UI_SCREEN_WIDTH/3, 60)];
    [_Follow setImage:[UIImage imageNamed:@"Follow"] forState:UIControlStateNormal];
    _Follow.tag = 1002;
    [_Follow setTitle:@"关注" forState:UIControlStateNormal];
    
    [_Follow addTarget:self action:@selector(clickbutton:) forControlEvents:UIControlEventTouchUpInside];
    
    [_tableheaderVeiw addSubview:_Classification];
    [_tableheaderVeiw addSubview:_Auction];
    [_tableheaderVeiw addSubview:_Follow];
    
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView == scrollView) {
        
        if (_scrollView.contentOffset.x == 0.f) {
            
            _antiquecatalogButton.selected = YES;
            _bookcaseButton.selected = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _line.frame = CGRectMake(UI_SCREEN_WIDTH/2-55, 61, 30, 3);
            }];
            
            
        }else if (_scrollView.contentOffset.x == UI_SCREEN_WIDTH ) {
            _antiquecatalogButton.selected = NO;
            _bookcaseButton.selected = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _line.frame = CGRectMake(UI_SCREEN_WIDTH/2+25, 61, 30, 3);
            }];
            
        }
        
    }
}

#pragma mark-Nav_button的点击事件
- (void)clickbutton:(UIButton *)button
{
    switch (button.tag) {
        case 1:
        {
            _bookcaseButton.selected = NO;
            _antiquecatalogButton.selected = YES;
            [UIView animateWithDuration:0.5 animations:^{
                _line.frame = CGRectMake(UI_SCREEN_WIDTH/2-55, 61, 30, 3);
            }];
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:NO];
        }
            break;
        case 2:
        {
            _bookcaseButton.selected = YES;
            _antiquecatalogButton.selected = NO;
            [UIView animateWithDuration:0.5 animations:^{
                _line.frame = CGRectMake(UI_SCREEN_WIDTH/2+25, 61, 30, 3);
            }];
            [_scrollView setContentOffset:CGPointMake(UI_SCREEN_WIDTH, 0) animated:NO];


        }
            break;
        case 1000:
        {
//            ClassificationViewController *classifVC = [[ClassificationViewController alloc]init];
//            [self.navigationController pushViewController:classifVC animated:YES];
            ClassficationViewController *classifVC = [[ClassficationViewController alloc]init];
            [self.navigationController pushViewController:classifVC animated:YES];
            
        }
            break;
        case 1001:
        {
            AuctionViewController *auctionVC = [[AuctionViewController alloc]init];
            [self.navigationController pushViewController:auctionVC animated:YES];
        }
            break;
        case 1002:
        {
            FllowViewController *fllowVC = [[FllowViewController alloc]init];
            [self.navigationController pushViewController:fllowVC animated:YES];
        }
            break;
        default:
            break;
    }
}

#pragma mark-轮播图的点击事件
- (void)bannerView:(DHHBannerView *)bannerView didClickedImageIndex:(NSInteger)index {
    
    NSLog(@"you clicked image in %@ at index: %ld", bannerView, (long)index);
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return _antiqueCatalogDataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cellUp";
    AntiqueCatalogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AntiqueCatalogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (ARRAY_NOT_EMPTY(_antiqueCatalogDataArray)) {
        cell.antiquecatalogdata = _antiqueCatalogDataArray[indexPath.row];
    }
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 141.0f;
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogDetailsViewController *catalogVC = [[CatalogDetailsViewController alloc]init];
    AntiqueCatalogData *antiqueCatalogdata = _antiqueCatalogDataArray[indexPath.row];
    catalogVC.ID = antiqueCatalogdata.ID;
    catalogVC.catalogData = antiqueCatalogdata;
    catalogVC.mfileName = antiqueCatalogdata.name;

    catalogVC.delegate = self;
    [self.navigationController pushViewController:catalogVC animated:YES];
}

#pragma mark-MybookViewDelegate
-(void)hanIndexPath:(NSIndexPath *)indexPath{
    
    CatalogDetailsViewController *catalogVC = [[CatalogDetailsViewController alloc]init];
    MybookCatalogdata *mybookcatalogdata = _mybookCatalogDataArray[indexPath.row];
    catalogVC.ID = mybookcatalogdata.ID;
    catalogVC.mfileName = mybookcatalogdata.name;

    [self.navigationController pushViewController:catalogVC animated:YES];
    
}

- (void)longhan{
    
    if (_upView == nil) {
        _edit = YES;
        _scrollView.scrollEnabled = NO;
        _upView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_NAVIGATION_BAR_HEIGHT)];
        _upView.backgroundColor = White_Color;
        _upView.layer.masksToBounds = YES;
        _upView.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
        _upView.layer.borderWidth = 1.0;
        
        _cancel = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"取消" Withcolor:Blue_color WithSelectcolor:Blue_color Withfont:Catalog_Cell_Name_Font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:NO];
        _cancel.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT - 44, 44, 44);
        _cancel.tag = 0;
        [_cancel addTarget:self action:@selector(editclick:) forControlEvents:UIControlEventTouchUpInside];
        
        _sure = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"全选" Withcolor:Blue_color WithSelectcolor:Blue_color Withfont:Catalog_Cell_Name_Font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:NO];
        _sure.frame = CGRectMake(UI_SCREEN_WIDTH - 44, UI_NAVIGATION_BAR_HEIGHT - 44, 44, 44);
        _sure.tag = 1;
        [_sure addTarget:self action:@selector(editclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_upView];
        [_upView addSubview:_cancel];
        [_upView addSubview:_sure];
        
        _downbtn = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"删除" Withcolor:Blue_color WithSelectcolor:Blue_color Withfont:Catalog_Cell_Name_Font WithBgcolor:White_Color WithcornerRadius:0 Withbold:NO];
        _downbtn.frame = CGRectMake(0, UI_SCREEN_HEIGHT - 64, UI_SCREEN_WIDTH, 64);
        _downbtn.layer.masksToBounds = YES;
        _downbtn.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
        _downbtn.layer.borderWidth = 1.0;
        _downbtn.tag = 2;
        [_downbtn addTarget:self action:@selector(editclick:) forControlEvents:UIControlEventTouchUpInside];
        
        [self.view addSubview:_downbtn];

        
    }
    

}

-(void)reloadTableViewDataWithCollectionView:(UICollectionView*)collectionView AndTypoe:(int)type{
    NSDictionary *prams = [NSDictionary dictionary];
    if (type == 2) {
        prams = @{@"max_id":@"1"};
    }else{
        
        prams = @{@"max_id":@"0"};
    }
    
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_userBook withParams:prams withSuccess:^(id responseObject) {
        
        //        NSLog(@"%@",responseObject);
        
        NSArray *array = responseObject;
        
        if (ARRAY_NOT_EMPTY(array)) {
            if(type == 1){  //如果是刷新的话  需要把原先的数组清空重新装填新的数据;不然是加载更多数据的话 返回的是增量，不用删除原先数组，直接在原先数组上添加增量
//                [_antiqueCatalogDataArray removeAllObjects];
                [_mybookCatalogDataArray removeAllObjects];

            }
//                [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
                for (NSDictionary *dic in array) {
                    [_mybookCatalogDataArray addObject:[MybookCatalogdata WithMybookCatalogDataDic:dic]];
                }
                [_mybookView loadMybookCatalogdata:_mybookCatalogDataArray];
//            [_tableVeiw reloadData];
        }else{
            
        }
        
        _isMore = NO;
        
        if(type == 1){
            [collectionView.mj_header endRefreshing];
        }
        if(type == 2){
            [collectionView.mj_footer endRefreshing];
        }
        
//        NSArray *array = [[NSArray alloc]init];
//        array = responseObject;
//        
//        if (!_isMore) {
//            [_mybookCatalogDataArray removeAllObjects];
//        }
//        if (ARRAY_NOT_EMPTY(array)) {
//            for (NSDictionary *dic in array) {
//                [_mybookCatalogDataArray addObject:[MybookCatalogdata WithMybookCatalogDataDic:dic]];
//            }
//            [_mybookView loadMybookCatalogdata:_mybookCatalogDataArray];
//        }else{
//            
//        }
//        _isMore = NO;
        
    } withError:^(NSError *error) {
        if(type == 1){
            [collectionView.mj_header endRefreshing];
        }
        if(type == 2){
            [collectionView.mj_footer endRefreshing];
        }
    }];
        

}
- (void)editclick:(UIButton *)btn
{
    switch (btn.tag) {
        case 0:
        {
            [_upView removeFromSuperview];
            [_downbtn removeFromSuperview];
            _upView = nil;
            _edit = NO;
            _scrollView.scrollEnabled = YES;
            [[NSNotificationCenter defaultCenter]postNotificationName:@"allcancel" object:nil];
  
        }
            break;
        case 1:
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"allselect" object:nil];
            
        }
            break;
        case 2:
        {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"delete" object:nil];
            
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - Gesture Handler
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer
{
    
    if (_edit == NO) {
        [_leftmenuveiw handlePanGesture:recognizer];
    }

}

#pragma mark - 下拉刷新
- (void)setupRefresh{
    
    __unsafe_unretained UITableView *tableView = _tableVeiw;
   tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
       [self reloadTableViewDataWithTableview:tableView AndTypoe:1];
   }];
}

-(void)setupLoadMore{
    __unsafe_unretained UITableView *tableView = _tableVeiw;
    tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self reloadTableViewDataWithTableview:tableView AndTypoe:2];
    }];
}
-(void)reloadTableViewDataWithTableview:(UITableView *)tableView AndTypoe:(int)type{
    NSDictionary *prams = [NSDictionary dictionary];
    if (type == 2) {
        prams = @{@"max_id":@"1"};
    }else{
        
        prams = @{@"max_id":@"0"};
    }

    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_index withParams:prams withSuccess:^(id responseObject) {
        NSArray *array = responseObject;
        
        if (ARRAY_NOT_EMPTY(array)) {
            if(type == 1){  //如果是刷新的话  需要把原先的数组清空重新装填新的数据;不然是加载更多数据的话 返回的是增量，不用删除原先数组，直接在原先数组上添加增量
                [_antiqueCatalogDataArray removeAllObjects];
            }
            for (NSDictionary *dic in array) {
                [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
            }
            [_tableVeiw reloadData];
        }else{
    
        }
        
        _isMore = NO;
        
    } withError:^(NSError *error) {
        
        NSLog(@"失败 %@",error);
    }];
    if(type == 1){
        [tableView.mj_header endRefreshing];
    }
    if(type == 2){
        [tableView.mj_footer endRefreshing];
    }
}

-(void)addDataTowDownList:(NSDictionary *)dataDict{
//    self.downListDict = dataDict;
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDownList" object:self userInfo:nil];

}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
            [self delayMethod];
            
        }
            break;
            
        default:
            break;
    }
}

-(void)delayMethod{
    NSLog(@"delaymethod");
    
    if (self.dowLoadArray.count >0) {
        [self.dowLoadArray removeObjectAtIndex:0];
        if (self.dowLoadArray.count) {
            DownFileMannger * downNext = self.dowLoadArray[0];
            [downNext createQuue];
            [downNext.netWorkQueue go];
//            for (int i = 0; i < self.dowLoadArray.count; i ++) {
//                DownFileMannger * downFileMangerONe = self.dowLoadArray[i];
////                NSLog(@"dddddddddddddd:%@  %@",downFileMangerONe.fileId,downFileMangerONe.fileName);
//            }
            [self downFileWithArray:downNext.dataList withFileName:downNext.fileName withFiledId:downNext.fileId withDownMannger:downNext];
        }
        
        
    }

}

-(void)fialdDownNext:(NSNotification*)notification{
//    [self delayMethod];
    if (self.dowLoadArray.count) {
        [self.dowLoadArray removeAllObjects];
        
    }
}

-(void)dowLoadNextFile:(NSNotification*)notification{
    NSString * mesg = [NSString stringWithFormat:@"图录下载完成"];
    UIAlertView * altView = [[UIAlertView alloc] initWithTitle:@"提示" message:mesg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
    [altView show];
    
}

#pragma mark - 下载按钮点击后的 通知方法
-(void)addFOFQueues:(NSNotification*)notification{
    NSDictionary * dict = notification.userInfo;
    if (DIC_NOT_EMPTY(dict)) {
        NSArray * listArray = dict[@"list"];
        NSString * name = dict[@"fileName"];
        NSString * fileId = dict[@"filedId"];
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DownFileMannger * downFileManger = [[DownFileMannger alloc] init];
            downFileManger.dataList = listArray;
            downFileManger.fileId = fileId;
            downFileManger.fileName = name;
            if (self.dowLoadArray.count == 0) {
                [downFileManger createQuue];
                [downFileManger.netWorkQueue go];
                [self downFileWithArray:listArray withFileName:name withFiledId:fileId withDownMannger:downFileManger];

            }
            [self.dowLoadArray addObject:downFileManger];
//            for (int i = 0; i < self.dowLoadArray.count; i ++) {
//                DownFileMannger * downFileMangerONe = self.dowLoadArray[i];
//                NSLog(@"llllllllllll:%@",downFileMangerONe);
//            }
            
      
        });
    }
}

-(void)downFileWithArray:(NSArray *)listDict withFileName:(NSString *)name withFiledId:(NSString *)fileId withDownMannger:(DownFileMannger*)downMannger{
    
    NSString *pathOne = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@_%@/Image",fileId,name] ];
    NSString * tempPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/temp/%@_%@/Image",fileId,name] ];
    for (NSDictionary * responseDict in listDict) {
        if([[responseDict allKeys] containsObject:@"child"]){
            NSArray * childArray = responseDict[@"child"];
            NSArray * valueArray = responseDict[@"value"];
            if (ARRAY_NOT_EMPTY(childArray)) {
                int tag = 0;
                
                for (NSDictionary * childDict in childArray) {
                    NSArray * cValueArray= childDict[@"value"];
                    for (NSDictionary * cValueDict in cValueArray) {
                        NSString *imageUrl = cValueDict[@"cover"];
                        NSArray * array = [imageUrl componentsSeparatedByString:@"/"];
                        NSString * tempstr = @"";
                        for (int i =3; i < array.count; i ++) {
                            if (i < (array.count-1)) {
                                tempstr = [tempstr stringByAppendingString:[NSString stringWithFormat:@"%@/",array[i]]];
                                
                            }else{
                                
                            }
                        }
                        
                        NSString * imageId = cValueDict[@"id"];
                        NSString * saveImagePath = [pathOne stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempstr]];
                        NSString * tempsaveImagePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempstr]];
                        NSFileManager *fileManagerOne = [NSFileManager defaultManager];
                        //判断temp文件夹是否存在
                        BOOL fileExistsOne = [fileManagerOne fileExistsAtPath:saveImagePath];
                        
                        if (!fileExistsOne) {//如果不存在说创建,因为下载时,不会自动创建文件夹
                            [fileManagerOne createDirectoryAtPath:saveImagePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
                        }
                        BOOL fileExistsTwo = [fileManagerOne fileExistsAtPath:tempsaveImagePath];
                        
                        if (!fileExistsTwo) {//如果不存在说创建,因为下载时,不会自动创建文件夹
                            [fileManagerOne createDirectoryAtPath:tempsaveImagePath
                                      withIntermediateDirectories:YES
                                                       attributes:nil
                                                            error:nil];
                        }

                        
                        
                        NSString *videoName = [array objectAtIndex:array.count-1];
                        NSString *downloadPath = [saveImagePath stringByAppendingPathComponent:videoName];
                        NSString * tempPath = [tempsaveImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",videoName]];
                        
                        if (STRING_NOT_EMPTY(imageUrl)) {
                            //                            [self dowLoadImage:imageUrl withArrayCount:valueArray.count withImageId:imageId withTag:i];
                            //                            [self dowImageUrl:imageUrl withSavePath:downloadPath withTag:tag withImageId:imageId withFileId:fileId withFileName:name];
                            [downMannger dowImageUrl:imageUrl withSavePath:downloadPath withTempPath:tempPath withTag:tag withImageId:imageId withFileId:fileId withFileName:name];
                            
                            tag++;
                            
                        }else{
                            
                        }
                        
                    }
                    
                }
                
            }else if (ARRAY_NOT_EMPTY(valueArray)){
                int tag = 0;
                
                for (NSDictionary * valueDict in valueArray) {
                    
                    NSString *imageUrl = valueDict[@"cover"];
                    NSArray * array = [imageUrl componentsSeparatedByString:@"/"];
                    NSString * tempstr = @"";
                    for (int i =3; i < array.count; i ++) {
                        if (i < (array.count-1)) {
                            tempstr = [tempstr stringByAppendingString:[NSString stringWithFormat:@"%@/",array[i]]];
                            
                        }else{
                            
                        }
                    }
                    
                    NSString * imageId = valueDict[@"id"];
                    NSString * saveImagePath = [pathOne stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempstr]];
                    NSString * tempsaveImagePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempstr]];

                    NSFileManager *fileManagerOne = [NSFileManager defaultManager];
                    //判断temp文件夹是否存在
                    BOOL fileExistsOne = [fileManagerOne fileExistsAtPath:saveImagePath];
                    
                    if (!fileExistsOne) {//如果不存在说创建,因为下载时,不会自动创建文件夹
                        [fileManagerOne createDirectoryAtPath:saveImagePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
                    }
                    
//                    NSString * tempSavePath = [NSString stringWithFormat:@"%@/temp",saveImagePath];
                    BOOL fileExistsTwo = [fileManagerOne fileExistsAtPath:tempsaveImagePath];
                    
                    if (!fileExistsTwo) {//如果不存在说创建,因为下载时,不会自动创建文件夹
                        [fileManagerOne createDirectoryAtPath:tempsaveImagePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
                    }
                    
                    NSString *videoName = [array objectAtIndex:array.count-1];
                    NSString *downloadPath = [saveImagePath stringByAppendingPathComponent:videoName];
                    NSString * tempPath = [tempsaveImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",videoName]];

                    if (STRING_NOT_EMPTY(imageUrl)) {
                        //                        [self dowLoadImage:imageUrl withArrayCount:valueArray.count withImageId:imageId withTag:i];
                        //                        [self dowImageUrl:imageUrl withSavePath:downloadPath withTag:tag withImageId:imageId withFileId:fileId withFileName:name];
                        [downMannger dowImageUrl:imageUrl withSavePath:downloadPath withTempPath:tempPath withTag:tag withImageId:imageId withFileId:fileId withFileName:name];
                        
                        tag++;
                        
                        
                    }else{
                        
                    }
                }
                
            }
            
            
        }else if([[responseDict allKeys] containsObject:@"value"]){
            NSArray * valueArray = responseDict[@"value"];
            if (ARRAY_NOT_EMPTY(valueArray)){
                int tag = 0;
                for (NSDictionary * valueDict in valueArray) {
                    NSString *imageUrl = valueDict[@"cover"];
                    NSArray * array = [imageUrl componentsSeparatedByString:@"/"];
                    NSString * tempstr = @"";
                    for (int i =3; i < array.count; i ++) {
                        if (i < (array.count-1)) {
                            tempstr = [tempstr stringByAppendingString:[NSString stringWithFormat:@"%@/",array[i]]];
                            
                        }else{
                            
                        }
                    }
                    NSString * imageId = valueDict[@"id"];
                    NSString * saveImagePath = [pathOne stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempstr]];
                    NSString * tempsaveImagePath = [tempPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@",tempstr]];

                    NSFileManager *fileManagerOne = [NSFileManager defaultManager];
                    //判断temp文件夹是否存在
                    BOOL fileExistsOne = [fileManagerOne fileExistsAtPath:saveImagePath];
                    
                    if (!fileExistsOne) {//如果不存在说创建,因为下载时,不会自动创建文件夹
                        [fileManagerOne createDirectoryAtPath:saveImagePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
                    }
                    
//                    NSString * tempSavePath = [NSString stringWithFormat:@"%@/temp",saveImagePath];
                    BOOL fileExistsTwo = [fileManagerOne fileExistsAtPath:tempsaveImagePath];
                    
                    if (!fileExistsTwo) {//如果不存在说创建,因为下载时,不会自动创建文件夹
                        [fileManagerOne createDirectoryAtPath:tempsaveImagePath
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
                    }
                    NSString *videoName = [array objectAtIndex:array.count-1];
                    NSString *downloadPath = [saveImagePath stringByAppendingPathComponent:videoName];
                    NSString * tempPath = [tempsaveImagePath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.temp",videoName]];

                    if (STRING_NOT_EMPTY(imageUrl)) {
                        
                        //                        [self dowImageUrl:imageUrl withSavePath:downloadPath withTag:tag withImageId:imageId withFileId:fileId withFileName:name];
                        [downMannger dowImageUrl:imageUrl withSavePath:downloadPath withTempPath:tempPath withTag:tag withImageId:imageId withFileId:fileId withFileName:name];
                        
                        tag++;
                        
                        
                    }
                }
                
                
            }
            
            
        }
        
    }
}


-(void)stopDowLoadFile:(NSNotification*)notification{
    NSString * fileId = notification.userInfo[@"fileId"];
    NSString * fileName = notification.userInfo[@"fileName"];
    for (DownFileMannger * downFile in self.dowLoadArray) {
        if ([fileId isEqualToString:downFile.fileId]) {
            NSArray *tempRequestList=[downFile.netWorkQueue operations];
            for (ASIHTTPRequest *request in tempRequestList) {
                //取消请求
                [request clearDelegatesAndCancel];
            }
            
//            break;
        }
    }

}

-(void)goDowLoadFile:(NSNotification*)notification{
    NSString * fileId = notification.userInfo[@"fileId"];
    NSString * fileName = notification.userInfo[@"fileName"];
    NSArray * listArray = notification.userInfo[@"list"];
    if (self.dowLoadArray.count ) {
        for (DownFileMannger * downFile in self.dowLoadArray) {
            if ([fileId isEqualToString:downFile.fileId]) {
                //            [downFile.netWorkQueue go];
                
                //            [downFile.netWorkQueue cancelAllOperations];
                [downFile.netWorkQueue reset];
                downFile.netWorkQueue = nil;
                [downFile createQuue];
                
                [downFile.netWorkQueue go];
                [self downFileWithArray:downFile.dataList withFileName:downFile.fileName withFiledId:fileId withDownMannger:downFile];
                
                break;
            }
        }
 
    }else{
        DownFileMannger * downFile = [[DownFileMannger alloc] init];
        if(downFile.netWorkQueue){
            [downFile.netWorkQueue reset];
            downFile.netWorkQueue = nil;

        }
        [downFile createQuue];
        
        [downFile.netWorkQueue go];
        [self downFileWithArray:listArray withFileName:fileName withFiledId:fileId withDownMannger:downFile];
        
    }
    
//    for (DownFileMannger * downFile in self.dowLoadArray) {
//        if ([fileId isEqualToString:downFile.fileId]) {
//            NSArray *tempRequestList=[downFile.netWorkQueue operations];
//            for (ASIHTTPRequest *request in tempRequestList) {
//                //取消请求
//                [request startAsynchronous];
//            }
//            
//            //            break;
//        }
//    }

}


@end
