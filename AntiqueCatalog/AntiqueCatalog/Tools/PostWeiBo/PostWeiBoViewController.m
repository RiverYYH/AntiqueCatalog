//
//  PostWeiBoViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/25.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "PostWeiBoViewController.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPRequestOperationManager.h"
#import "UpYun.h"
//#import "TopicDetailViewController.h"
#import "LabelsClassViewController.h"
#import "UIViewController+HUD.h"

#import <ShareSDK/ShareSDK.h>

@interface PostWeiBoViewController ()
{
    UIView *_functionView;
    
    UIPlaceHolderTextView *_textView;
    UIScrollView *_scrollView;
    UIView *_customView;
    UIButton *_tianjiaButton;
    UIView *_locationView;
    UIImageView *_locationImageView;
    UILabel *_locationLabel;
    UILabel *_countLabel;
    NSString *_placeText;
    NSString *_commenTopicName;//普通发微博添加的专辑名
    NSString *_oneTopicName;//在发布专辑界面发布专辑
    
    CLLocationManager *_locationManager;
    //定位相关
    BOOL isLocation;
    NSString *_locationStr;
    double latitude,longitude;
    NSInteger selectIndex;
    NSString *selectAddress;
    
    UIButton *_smileButton;
    UIView *_cameraBackView;
    UIView *_faceBackView;
    UIPageControl *_pageControl;
    
    NSMutableArray *_imageArray;
    NSInteger count;
    
    float _textCount;
    
    BOOL _isKeyBoard;
    BOOL _isSmile;
    
    BOOL _isImageBtn;//判断是否是直接进入图片或者拍照
    
    //又拍云
    BOOL _isUpyun;
    NSInteger _num;
    NSMutableDictionary *_imageUrlDetailDic;
    
    //标签
    UIView *_categoryView;
    NSMutableDictionary *_biaoqianDic;
    NSString *_selectLables;
    NSString *_ZiDingYiLables;
    NSMutableArray *_plazaSeletedArray;
    UILabel *_label1;
    UILabel *_label2;
    
    //分享到站外
    UIView *_shareView;
    UIButton *_weiXinBtn;
    UIButton *_sinaBtn;
    UIButton *_QQSpaceBtn;
}
@end

@implementation PostWeiBoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andPlaceText:(NSString *)placeText
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _placeText = placeText;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showPaiZhao:) name:@"post_photo" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(NewTopicCreated:) name:@"NewTopicCreated" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(PassOnLables:) name:@"BiaoQian" object:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(!_isImageBtn || [self.tag isEqualToString:@"1"]){
        [_textView becomeFirstResponder];
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"post_photo" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewTopicCreated" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"BiaoQian" object:nil];
}

#pragma mark - 通知方法
- (void)NewTopicCreated:(NSNotification *)notifition
{
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"NewTopicCreatedNext" object:nil userInfo:nil];
    }];
}
#pragma mark-标签的通知方法
- (void)PassOnLables:(NSNotification *)notifition
{
    //必须有，避免重复添加
    //    [_plazaSeletedArray removeAllObjects];
    [_plazaArray removeAllObjects];
    _selectLables = @"";
    _ZiDingYiLables = @"";
    //    NSMutableDictionary *notifitiondic = [notifition object];
    //    _plazaSeletedArray = [notifitiondic objectForKey:@"_selectArray"];
    NSLog(@"标签💊💊💊💊💊%@",_plazaSeletedArray);
    //    [_plazaSeletedArray addObjectsFromArray:[_biaoqianDic objectForKey:@"_selectArray"]];
    
    for (NSInteger i = 0; i < _plazaSeletedArray.count; i++) {
        NSString *str = (NSString *)_plazaSeletedArray[i];
        if (i == 0) {
            _selectLables = [_selectLables stringByAppendingString:str];
        }else{
            NSString *str1 = [NSString stringWithFormat:@",%@",str];
            _selectLables = [_selectLables stringByAppendingString:str1];
        }
        
    }
    if (_plazaSeletedArray.count) {
        _label1.hidden = YES;
        _label2.frame = CGRectMake(30, 0, UI_SCREEN_WIDTH - 70, 40);
        _label2.text = _selectLables;
    }else{
        _label1.hidden = NO;
        _label2.frame = CGRectMake(CGRectGetMaxX(_label1.frame), 0, UI_SCREEN_WIDTH - 120, 40);
        _label2.text = @"让你的艺术更多人看见";
    }
    
}

- (void)showPaiZhao:(NSNotification *)notifition
{
    NSDictionary *dic = notifition.userInfo;
    [_imageArray addObject:[dic objectForKey:@"photo_image"]];
    [self initPhotoView:_imageArray];
}
- (void)keyboardWillHide:(NSNotification *)notification
{
    _isKeyBoard = NO;
    if(_isSmile == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            _customView.frame = CGRectMake(0,UI_SCREEN_HEIGHT - 216 - 44,UI_SCREEN_WIDTH,44);
        }];
        
    }
    if (_isKeyBoard == NO && _isSmile == NO) {
        [UIView animateWithDuration:0.3 animations:^{
            _customView.frame = CGRectMake(0,UI_SCREEN_HEIGHT - 44,UI_SCREEN_WIDTH,44);
        }];
    }
}

- (void)keyboardWillShow:(NSNotification *)notification
{
    _isKeyBoard = YES;
    _isSmile = NO;
    
    NSValue * endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGFloat height = [endValue CGRectValue].size.height;
    [UIView animateWithDuration:0.3 animations:^{
        _customView.frame = CGRectMake(0,UI_SCREEN_HEIGHT - height - 44,UI_SCREEN_WIDTH,44);
    }];
    [_smileButton setImage:[UIImage imageNamed:@"PostWeiBo_biaoqing"] forState:UIControlStateNormal];
    
    [UIView animateWithDuration:0.1 animations:^{
        _faceBackView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 216);
        _cameraBackView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 216);
        
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    //	_titleLabel.text = @"发分享";
    self.view.backgroundColor = BG_COLOR;
    [self.leftButton setImage:nil forState:UIControlStateNormal];
    [self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftButton setTitleColor:BASE_NAVIGATION_BUTTONCOLOR forState:UIControlStateNormal];
    [self.rightButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:BASE_NAVIGATION_BUTTONCOLOR forState:UIControlStateNormal];

    _locationStr = @"";
    _imageArray = [NSMutableArray array];
    _imageUrlDetailDic = [NSMutableDictionary dictionary];
    _biaoqianDic = [NSMutableDictionary dictionary];
    _selectLables = @"";
    _ZiDingYiLables =  @"";
    
    _textView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(10, UI_NAVIGATION_BAR_HEIGHT+10, UI_SCREEN_WIDTH-20, 120)];
    _textView.font = [UIFont systemFontOfSize:14.0];
    //    _textView.frame
    _textView.delegate = self;
    _textView.placeholder = @"分享你的艺术";
    if (STRING_NOT_EMPTY(_placeText))
    {
        _textView.text = _placeText;
        _oneTopicName = [self isExistTopic];
    }
    if(STRING_NOT_EMPTY(_topicName)) {
        _textView.text = [NSString stringWithFormat:@"#%@#",_topicName];
    }
    _textView.placeholderColor = CONTENT_COLOR;
    _textView.textColor = CONTENT_COLOR;
    _textView.backgroundColor = [UIColor whiteColor];
    _textView.layer.masksToBounds = YES;
    _textView.layer.cornerRadius = 3;
    [self.view addSubview:_textView];
    [_textView becomeFirstResponder];
    
    _countLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-100, CGRectGetMaxY(_textView.frame), 80, 20)];
    _countLabel.font = [UIFont systemFontOfSize:11.0];
    _countLabel.textAlignment = NSTextAlignmentRight;
    _countLabel.textColor = TITLE_COLOR;
    _countLabel.text = [NSString stringWithFormat:@"%d/300",300];
    [self.view addSubview:_countLabel];
    
    _scrollView =[[UIScrollView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_countLabel.frame), UI_SCREEN_WIDTH-20, 70)];
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH-20, 70);
    _scrollView.bounces = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_scrollView];
    //添加按钮
    _tianjiaButton = [UIButton buttonWithType:UIButtonTypeCustom];
    _tianjiaButton.frame = CGRectMake(2, 2, 66, 66);
    _tianjiaButton.adjustsImageWhenHighlighted = NO;
    _tianjiaButton.tag = 100;
    [_tianjiaButton setImage:[UIImage imageNamed:@"PostWeiBo_tianjiazhaopian"] forState:UIControlStateNormal];
    [_tianjiaButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:_tianjiaButton];
    
    _functionView = [[UIView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(_scrollView.frame) + 5, UI_SCREEN_WIDTH-20, 81)];
    _functionView.backgroundColor = BG_COLOR;
    [self.view addSubview:_functionView];
    
    
    _categoryView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH-20, 40)];
    _categoryView.backgroundColor = [UIColor whiteColor];
    [_functionView addSubview:_categoryView];
    //    _plazaSeletedArray = [[NSMutableArray alloc] initWithArray:_plazaArray];
    _plazaSeletedArray = [[NSMutableArray alloc] init];
    if (ARRAY_NOT_EMPTY(_plazaArray)) {
        _selectLables = [_selectLables stringByAppendingString:[NSString stringWithFormat:@"%@",[[_plazaArray objectAtIndex:0] objectForKey:@"title"]]];
    }else {
        _selectLables = @"";
    }
    
    
    //    [self configPlaza:_plazaSeletedArray];
    
    UITapGestureRecognizer *labeltgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(labeltgrClick)];
    [_categoryView addGestureRecognizer:labeltgr];
    
    UIImageView *categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    categoryImageView.image = [UIImage imageNamed:@"Weibo_biaoqian"];
    [_categoryView addSubview:categoryImageView];
    
    _label1 = [Allview Withstring:@"添加标签" Withcolor:Black_Color Withbgcolor:Clear_Color Withfont:13 WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _label1.frame = CGRectMake(CGRectGetMaxX(categoryImageView.frame) + 5, 0, 55, 40);
    
    
    _label2 = [Allview Withstring:@"让你的艺术更多人看见" Withcolor:RGBA(160,160,160) Withbgcolor:Clear_Color Withfont:13 WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _label2.frame = CGRectMake(CGRectGetMaxX(_label1.frame), 0, UI_SCREEN_WIDTH - 120, 40);
    
    [_categoryView addSubview:_label1];
    [_categoryView addSubview:_label2];
    
    if (ARRAY_NOT_EMPTY(_plazaArray)) {
        [_plazaSeletedArray addObject:[NSString stringWithFormat:@"%@",[[_plazaArray objectAtIndex:0] objectForKey:@"title"]]];
        _label1.hidden = YES;
        _label2.frame = CGRectMake(30, 0, UI_SCREEN_WIDTH - 70, 40);
        _label2.text = _selectLables;
    }
    
    _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_categoryView.frame) + 1, UI_SCREEN_WIDTH-20, 40)];
    _shareView.backgroundColor = [UIColor whiteColor];
    [_functionView addSubview:_shareView];
    
    //定位
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager setDistanceFilter:kCLDistanceFilterNone];
    [_locationManager setDesiredAccuracy:kCLLocationAccuracyNearestTenMeters];
    if (iOSVersion>=8.0)
    {
        [_locationManager requestWhenInUseAuthorization];
    }
    _locationManager.delegate = self;
    [_locationManager startUpdatingLocation];
    
    _locationView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH-20, 40)];
    _locationView.backgroundColor = [UIColor whiteColor];
    _locationView.layer.masksToBounds = YES;
    _locationView.layer.cornerRadius = 12;
    [_shareView addSubview:_locationView];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationClick)];
    [_locationView addGestureRecognizer:tgr];
    
    _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 10, 20, 20)];
    _locationImageView.image = [UIImage imageNamed:@"PostWeiBo_dingwei"];
    [_locationView addSubview:_locationImageView];
    
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, UI_SCREEN_WIDTH - 70, 30)];
    _locationLabel.font = [UIFont systemFontOfSize:13.0];
    _locationLabel.textColor = Black_Color;
    _locationLabel.text = @"选择位置";
    [_locationView addSubview:_locationLabel];
    
    
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT - 44, UI_SCREEN_WIDTH, 44)];
    _customView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_customView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH-20, 0.5)];
    line1.backgroundColor = BAR_COLOR;
    [_customView addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(0, 43.5, UI_SCREEN_WIDTH-20, 0.5)];
    line2.backgroundColor = BAR_COLOR;
    [_customView addSubview:line2];
    
    NSArray *arr = @[@"PostWeiBo_aite",@"PostWeiBo_huati",@"PostWeiBo_biaoqing"];
    for (NSUInteger i=0; i<arr.count; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        CGFloat intervalW = UI_SCREEN_WIDTH - arr.count*22;
        button.frame = CGRectMake(intervalW/6+ 22*i + intervalW/3*i, 11, 22, 22);
        button.adjustsImageWhenHighlighted = NO;
        button.tag = 101+i;
        [button setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customView addSubview:button];
        
        if (i == 3)
        {
            _smileButton = button;
        }
    }
    
    //    UILabel *shareLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 5, 60, 30)];
    //    shareLabel.text = @"同步到";
    //    shareLabel.textColor = TITLE_COLOR;
    //    [_shareView addSubview:shareLabel];
    //
    //    _weiXinBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _weiXinBtn.frame = CGRectMake(70, 5, 30, 30);
    //    [_weiXinBtn setImage:[UIImage imageNamed:@"PostWeiBo_Pengyouquan"] forState:UIControlStateNormal];
    //    [_weiXinBtn setImage:[UIImage imageNamed:@"PostWeiBo_pengyouquan_seleted"] forState:UIControlStateSelected];
    //    [_weiXinBtn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [_shareView addSubview:_weiXinBtn];
    //
    //    _sinaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _sinaBtn.frame = CGRectMake(105, 5, 30, 30);
    //    [_sinaBtn setImage:[UIImage imageNamed:@"PostWeiBo_sina"] forState:UIControlStateNormal];
    //    [_sinaBtn setImage:[UIImage imageNamed:@"PostWeiBo_sina_seleted"] forState:UIControlStateSelected];
    //    [_sinaBtn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [_shareView addSubview:_sinaBtn];
    //
    //    _QQSpaceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    //    _QQSpaceBtn.frame = CGRectMake(140, 5, 30, 30);
    //    [_QQSpaceBtn setImage:[UIImage imageNamed:@"PostWeiBo_qzone"] forState:UIControlStateNormal];
    //    [_QQSpaceBtn setImage:[UIImage imageNamed:@"PostWeiBo_qzone_seleted"] forState:UIControlStateSelected];
    //    [_QQSpaceBtn addTarget:self action:@selector(typeBtnClicked:) forControlEvents:UIControlEventTouchUpInside];
    //    [_shareView addSubview:_QQSpaceBtn];
    
    if ([[UserModel userLoginType] isEqualToString:@""])
        
        [self updateCamera];
    [self updateFace];
    
    _isImageBtn = YES;
    _isUpyun = YES;
    if([self.tag isEqualToString:@"2"]||[self.tag isEqualToString:@"3"]) {
        self.view.hidden = YES;
    }
    _num = 0;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if([self.tag isEqualToString:@"2"]){
        if(_isImageBtn) {
            _isImageBtn = NO;
            UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
            picker.delegate = self;
            picker.isPhoto = YES;
            picker.maximumNumberOfSelectionPhoto = 9;
            [self presentViewController:picker animated:YES completion:^{}];
        }
    } else if ([self.tag isEqualToString:@"3"]) {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            if(_isImageBtn) {
                _isImageBtn = NO;
                SCNavigationController *nav = [[SCNavigationController alloc] init];
                nav.scNaigationDelegate = self;
                [nav showCameraWithParentController:self];
            }
        }
        else
        {
            [self showHudInView:self.view showHint:@"设备不支持"];
        }
    }
    if (!_isImageBtn) {
        self.view.hidden = NO;
    }
}

- (void)leftButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:NO completion:nil];
    
}
- (void)typeBtnClicked:(UIButton *)btn
{
    btn.selected = !btn.selected;
    if(btn == _QQSpaceBtn) {
        _sinaBtn.selected = NO;
        _weiXinBtn.selected = NO;
    } else if (btn == _weiXinBtn) {
        _sinaBtn.selected = NO;
        _QQSpaceBtn.selected = NO;
    } else if (btn == _sinaBtn) {
        _weiXinBtn.selected = NO;
        _QQSpaceBtn.selected = NO;
    }
}
#pragma mark-按钮的点击事件
- (void)buttonClicked:(UIButton *)button
{
    if(button.tag == 103) {
        _isSmile = !_isSmile;
    }
    [_textView resignFirstResponder];
    
    switch (button.tag)
    {
        case 100:
        {
            [LPActionSheetView showInView:self.view title:@"选择上传图片方式" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"] tagNumber:2];
        }
            break;
        case 101:
        {
//            LianXiRenViewController *lianXiRenVC = [[LianXiRenViewController alloc] init];
//            lianXiRenVC.delegate = self;
//            lianXiRenVC.type = LianXiRenViewControllerTypeAT;
//            [self presentViewController:lianXiRenVC animated:YES completion:nil];
        }
            break;
        case 102:
        {
            PostTopicListViewController *topicVC = [[PostTopicListViewController alloc] init];
            topicVC.delegate = self;
            topicVC.type = 1;
            [self presentViewController:topicVC animated:YES completion:nil];
        }
            break;
            //        case 103:
            //        {
            //            NSMutableArray *oneArray = [NSMutableArray array];
            //            [oneArray addObjectsFromArray:_plazaArray];
            //            [oneArray addObjectsFromArray:[_biaoqianDic objectForKey:@"_selectArray"]];
            //            [_biaoqianDic setObject:oneArray forKey:@"_selectArray"];
            //
            //            LabelsClassViewController *lablesClassNV = [[LabelsClassViewController alloc]init];
            //            lablesClassNV.ZiDingYiDIC = _biaoqianDic;
            //            //            [self.navigationController pushViewController:lablesClassNV animated:YES];
            //            [self presentViewController:lablesClassNV animated:YES completion:^{ }];
            //        }
            //            break;
        case 103:
        {
            if (_isSmile)
            {
                [UIView animateWithDuration:0.3 animations:^{
                    
                    
                    _customView.frame = CGRectMake(0,UI_SCREEN_HEIGHT - 216 - 44,UI_SCREEN_WIDTH,44);
                    _faceBackView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-216, UI_SCREEN_WIDTH, 216);
                    _cameraBackView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 216);
                    //                    _textView.frame = CGRectMake(10, 10+UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH-20, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-_functionView.frame.size.height-216);
                    
                    //                    _functionView.frame = CGRectMake(10, CGRectGetMaxY(_scrollView.frame) + 5, UI_SCREEN_WIDTH-20, _functionView.frame.size.height);
                }];
                
                [_smileButton setImage:[UIImage imageNamed:@"PostWeiBo_jianpan"] forState:UIControlStateNormal];
            }
            else
            {
                [_textView becomeFirstResponder];
            }
        }
            break;
            
        default:
            break;
    }
}

- (void)rightButtonClick:(id)sender
{
    [_textView resignFirstResponder];
    //检测专辑名是否改变
    NSString *newTopicName = [self isExistTopic];
    if (STRING_NOT_EMPTY(_topicName)) {
        if(STRING_NOT_EMPTY(newTopicName)) {
            if(![newTopicName isEqualToString:_topicName]) {
                [self showHudInView:self.view showHint:@"您的专辑名已改变，发布失败"];
                return;
            }
        } else {
            [self showHudInView:self.view showHint:@"您的专辑名已改变，发布失败"];
            return;
        }
    } else if(STRING_NOT_EMPTY(_oneTopicName)) {
        if(STRING_NOT_EMPTY(newTopicName)) {
            if(![newTopicName isEqualToString:_oneTopicName]) {
                [self showHudInView:self.view showHint:@"您的专辑名已改变，发布失败"];
                return;
            }
        } else {
            [self showHudInView:self.view showHint:@"您的专辑名已改变，发布失败"];
            return;
        }
    } else {
        if (STRING_NOT_EMPTY(newTopicName)) {
            if(![newTopicName isEqualToString:_commenTopicName]) {
                [self showHudInView:self.view showHint:@"您的专辑名已改变，发布失败"];
                return;
            }
        }
    }
    
    if(!longitude) {
        NSDictionary *dic = [UserModel userLocation];
        longitude = [[dic objectForKey:@"longitude"] doubleValue];
        latitude = [[dic objectForKey:@"latitude"] doubleValue];
    }
    
    if ([_imageArray count])
    {
        if (!STRING_NOT_EMPTY(_textView.text))
        {
            _textView.text = @"分享宝贝";
        }
    }
    
    if (_textCount>300)
    {
        [self showHudInView:self.view showHint:@"字数不可超过300"];
        return;
    }
    
    NSDictionary *params = [NSDictionary dictionary];
    if([_imageArray count]) {
        if (![_locationStr isEqualToString:@""])
        {
            params = @{@"content": _textView.text,@"from": @"3",@"type":@"postimage",@"address": _locationStr,@"longitude": [NSString stringWithFormat:@"%f",longitude],@"latitude": [NSString stringWithFormat:@"%f",latitude],@"feed_category_self":_selectLables};
        }
        else
        {
            params = @{@"content": _textView.text,@"from": @"3",@"type":@"postimage",@"longitude": [NSString stringWithFormat:@"%f",longitude],@"latitude": [NSString stringWithFormat:@"%f",latitude],@"feed_category_self":_selectLables};
        }
    } else {
        if (![_locationStr isEqualToString:@""])
        {
            params = @{@"content": _textView.text,@"from": @"3",@"address": _locationStr,@"longitude": [NSString stringWithFormat:@"%f",longitude],@"latitude": [NSString stringWithFormat:@"%f",latitude],@"feed_category_self":_selectLables};
        }
        else
        {
            params = @{@"content": _textView.text,@"from": @"3",@"longitude": [NSString stringWithFormat:@"%f",longitude],@"latitude": [NSString stringWithFormat:@"%f",latitude],@"feed_category_self":_selectLables};
        }
    }
    
    
    if ([_imageArray count])
    {
        [self showHudInView:self.view hint:@"分享你的艺术"];
        if(_isUpyun) {
            for(int i=0; i<[_imageArray count]; i++) {
                NSMutableDictionary *dic = [NSMutableDictionary dictionary];
                [_imageUrlDetailDic setObject:dic forKey:[NSString stringWithFormat:@"%d",i]];
                NSData *upLoadiImageData = [self compressImage:[_imageArray objectAtIndex:i]];
                UIImage *upLoadiImage = [UIImage imageWithData:upLoadiImageData];
                NSInteger currentHeight = upLoadiImage.size.height*600/upLoadiImage.size.width;
                UpYun *upYun = [self creatUpyun];
                [upYun.params setObject:[NSString stringWithFormat:@"%ld",currentHeight] forKey:@"image-height-range"];
                [dic setObject:@"600" forKey:@"imgaeWidth"];
                [dic setObject:[NSString stringWithFormat:@"%ld",currentHeight] forKey:@"imageHeight"];
                [upYun uploadFile:upLoadiImageData saveKey:[self getSaveKey:i]];
                
                __unsafe_unretained PostWeiBoViewController *weakSelf = self;
                upYun.successBlocker = ^(NSData *data) {
                    _num ++;
                    NSLog(@"%@",data);
                    if(_num == _imageArray.count) {
                        [weakSelf loadupDataWithPath:API_URL_POST_Photoweibo_New andParams:params andImage:YES];
                        return ;
                    }
                };
                
                upYun.failBlocker = ^(NSError *error) {
                    _num ++;
                    [_imageUrlDetailDic removeObjectForKey:[NSString stringWithFormat:@"%d",i]];
                    if(_num == _imageArray.count) {
                        [weakSelf loadupDataWithPath:API_URL_POST_Photoweibo_New andParams:params andImage:YES];
                        return ;
                    }
                    NSLog(@"error:%@",error);
                };
            }
            
        } else {
            NSString *path = [NSString stringWithFormat:@"%@&oauth_token=%@&oauth_token_secret=%@",API_URL_POST_Photoweibo,[[UserModel userPassport] objectForKey:@"oauthToken"],[[UserModel userPassport] objectForKey:@"oauthTokenSecret"]];
            NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                for (int i = 0; i < [_imageArray count]; i++)
                {
                    NSData *imageData= UIImageJPEGRepresentation([_imageArray objectAtIndex:i], 0.3);
                    [formData appendPartWithFileData:imageData name:[NSString stringWithFormat:@"%d",i] fileName:[NSString stringWithFormat:@"image%d.jpg",i] mimeType:@"image/jpeg"];
                }
            } error:nil];
            
            AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
            [operation start];
            [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
                [self hideHud];
                NSLog(@"%@",responseObject);
                NSDictionary *dataDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                if([dataDic objectForKey:@"status"] ) {
                    if(![[dataDic objectForKey:@"status"] intValue]) {
                        [self showHudInView:self.view showHint:[dataDic objectForKey:@"msg"]];
                        return ;
                    }
                }
                if(STRING_NOT_EMPTY(_topicName)) {
//                    TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc] initWithNibName:nil bundle:nil WithTopicName:_topicName];
//                    topicDetailVC.isNewTopic = YES;
//                    [self.navigationController pushViewController:topicDetailVC animated:YES];
                } else {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostWeiBoSucceed" object:self userInfo:@{@"feed_id": [[NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil] objectForKey:@"feed_id"]}];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"MeStatusChanged" object:self userInfo:nil];
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self hideHud];
                NSLog(@"error = %@",error);
            }];
        }
    }
    else
    {
        [self showHudInView:self.view hint:@"分享你的艺术"];
        [self loadupDataWithPath:API_URL_POST_Photoweibo_New andParams:params andImage:NO];
    }
}

- (void)loadupDataWithPath:(NSString *)path andParams:(NSDictionary *)params andImage:(BOOL)isHaveImage
{
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:params];
    NSString *shareImageUrl = nil;
    if(isHaveImage) {
        shareImageUrl = [NSString stringWithFormat:upYunImgUrl,[[_imageUrlDetailDic objectForKey:@"0"] objectForKey:@"imageSavePath"],[[_imageUrlDetailDic objectForKey:@"0"] objectForKey:@"imageSaveName"]];
        NSMutableArray *array = [NSMutableArray array];
        for(int i=0; i<_imageArray.count; i++) {
            NSDictionary *dic = [_imageUrlDetailDic objectForKey:[NSString stringWithFormat:@"%d",i]];
            if(dic != nil) {
                [array addObject:dic];
            }
        }
        NSData *data = [NSJSONSerialization dataWithJSONObject:array options:nil error:nil];
        NSString *string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [param setObject:string forKey:@"upload_info"];
    }
//    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_userBook withParams:prams withSuccess:^(id responseObject) {

    [Api requestWithMethod:@"POST" withPath:path withParams:param withSuccess:^(id responseObject){
        NSLog(@"%@",responseObject);
        if ([[responseObject objectForKey:@"status"] intValue] == 1)
        {
            [self hideHud];
            NSLog(@"发送成功!");
            if([responseObject objectForKey:@"status"] ) {
                if(![[responseObject objectForKey:@"status"] intValue]) {
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    
                    return ;
                }
            }
            if(_QQSpaceBtn.selected) {
                [self shareWithType:@"qzone" uid:[[responseObject objectForKey:@"feed_id"] stringValue] imageUrl:shareImageUrl];
            } else if (_weiXinBtn.selected) {
                [self shareWithType:@"pengyouquan" uid:[[responseObject objectForKey:@"feed_id"] stringValue] imageUrl:shareImageUrl];
            } else if (_sinaBtn.selected) {
                [self shareWithType:@"sina" uid:[[responseObject objectForKey:@"feed_id"] stringValue] imageUrl:shareImageUrl];
            }
            if(STRING_NOT_EMPTY(_topicName)) {
//                TopicDetailViewController *topicDetailVC = [[TopicDetailViewController alloc] initWithNibName:nil bundle:nil WithTopicName:_topicName];
//                topicDetailVC.isNewTopic = YES;
//                [self.navigationController pushViewController:topicDetailVC animated:YES];
            } else {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"PostWeiBoSucceed" object:self userInfo:@{@"feed_id": [responseObject objectForKey:@"feed_id"]}];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MeStatusChanged" object:self userInfo:nil];
                [self dismissViewControllerAnimated:YES completion:nil];
            }
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
- (void)shareWithType:(NSString *)type uid:(NSString *)uid imageUrl:(NSString *)imageUrl
{
    NSString *urlString = [NSString stringWithFormat:@"%@%@",API_URL_XiangQing,uid];
    id shareImageUrl;
    if(imageUrl == nil) {
        shareImageUrl = [ShareSDK imageWithPath:APPICON];
    } else {
        shareImageUrl = [ShareSDK imageWithUrl:imageUrl];
    }
    NSString *title = [NSString stringWithFormat:@"来自到处是宝%@的分享",[UserModel userUname]];
    NSString *content = _textView.text;
    if(content.length > 100) {
        content = [_textView.text substringToIndex:100];
    }
    
    if([type isEqualToString:@"qzone"]) {
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:DEFAULTCONTENT
                                                    image:shareImageUrl
                                                    title:title
                                                      url:urlString
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
    } else if ([type isEqualToString:@"sina"]) {
        id<ISSContent> publishContent = [ShareSDK content:[NSString stringWithFormat:@"%@%@",title,urlString]
                                           defaultContent:DEFAULTCONTENT
                                                    image:shareImageUrl
                                                    title:title
                                                      url:urlString
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
    } else if ([type isEqualToString:@"pengyouquan"]) {
        id<ISSContent> publishContent = [ShareSDK content:content
                                           defaultContent:DEFAULTCONTENT
                                                    image:shareImageUrl
                                                    title:title
                                                      url:urlString
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
}
//创建upyun
- (UpYun *)creatUpyun
{
    UpYun *upYun = [[UpYun alloc] init];
    upYun.bucket = Bucket;
    upYun.passcode = Passcode;
    [upYun.params setValuesForKeysWithDictionary:[NSDictionary dictionaryWithObjectsAndKeys:@"75",@"x-gmkerl-quality", @"600",@"image-width-range", nil]];
    return upYun;
}
//压缩图片
- (NSData *)compressImage:(UIImage *)image
{
    CGFloat p = 600 /image.size.width;
    CGSize size = CGSizeMake(600, image.size.height * p);
    UIGraphicsBeginImageContext(size);
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    NSData *imageData = UIImageJPEGRepresentation(newImage, 1.0);
    UIImage *imageDown;
    if ([imageData length] > 1024 * 200) {
        NSData *sImageData = UIImageJPEGRepresentation(newImage, 0.75);
        
        //        if ([imageData length] > 1024 * 20) {
        //            imageData = UIImageJPEGRepresentation(imageDown, 0.001);
        //            imageDown = [UIImage imageWithData:imageData];
        //        }
        return sImageData;
    }
    else{
        imageDown = [UIImage imageWithData:imageData];
        return imageData;
    }
}
#pragma mark - 检查是否有插入专辑
- (NSString *)isExistTopic
{
    NSRange range1 = [_textView.text rangeOfString:@"#" options:NSCaseInsensitiveSearch];
    if(range1.location == NSNotFound) {
        return nil;
    } else {
        NSString *string = [_textView.text substringFromIndex:range1.location+1];
        NSRange range2 = [string rangeOfString:@"#" options:NSCaseInsensitiveSearch];
        if(range2.location == NSNotFound) {
            return nil;
        } else {
            NSRange range;
            range.location = range1.location+1;
            range.length = range2.location;
            return [_textView.text substringWithRange:range];
        }
    }
}
#pragma mark - UITextViewDelegate
- (void)textViewDidChange:(UITextView *)textView
{
    [self updateWordCount];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"])
    {
        [_textView resignFirstResponder];
        return NO;
    }
    return YES;
}

#pragma mark - 更新字数
- (void)updateWordCount
{
    _textCount = 0;
    NSString *titleTemp= [_textView.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    for (int index = 0; index < [titleTemp length]; index++)
    {
        NSString *character = [titleTemp substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)
        {
            _textCount++;
        }
        else
        {
            _textCount = _textCount + 0.5;
        }
    }
    if (_textCount == 0)
    {
        _countLabel.text = @"0/300";
    }
    else
    {
        _countLabel.text = [NSString stringWithFormat:@"%.f/300",300 - _textCount];
        if (300 - _textCount<0)
        {
            _countLabel.textColor = [UIColor redColor];
        }
        else
        {
            _countLabel.textColor = TITLE_COLOR;
        }
    }
}

#pragma mark - 生成拍照
-(void)updateCamera
{
    _cameraBackView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 216)];
    [self.view addSubview:_cameraBackView];
    
    UIButton *cameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cameraButton.frame = CGRectMake(12, 0, 60, 70);
    cameraButton.adjustsImageWhenHighlighted = NO;
    [cameraButton setImage:[UIImage imageNamed:@"PostWeiBo_xiangji"] forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(goCamera) forControlEvents:UIControlEventTouchUpInside];
    [_cameraBackView addSubview:cameraButton];
    
    UIButton *photoButton = [UIButton buttonWithType:UIButtonTypeCustom];
    photoButton.frame = CGRectMake(12+60+30, 0, 60, 70);
    photoButton.adjustsImageWhenHighlighted = NO;
    [photoButton setImage:[UIImage imageNamed:@"PostWeiBo_xiangce"] forState:UIControlStateNormal];
    [photoButton addTarget:self action:@selector(goPhoto) forControlEvents:UIControlEventTouchUpInside];
    [_cameraBackView addSubview:photoButton];
}
#pragma mark - 生成表情
-(void)updateFace
{
    _faceBackView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 216)];
    _faceBackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_faceBackView];
    
    UIScrollView *faceScrollview = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 186)];
    for (int i=0; i<4; i++)
    {
        ExpressionView *fview=[[ExpressionView alloc] initWithFrame:CGRectMake(i*UI_SCREEN_WIDTH, 0, 315, 186)];
        [fview loadFacialView:i size:CGSizeMake(46, 46)];
        fview.delegate=self;
        [faceScrollview addSubview:fview];
    }
    faceScrollview.showsHorizontalScrollIndicator = NO;
    faceScrollview.delegate = self;
    faceScrollview.contentSize=CGSizeMake(UI_SCREEN_WIDTH*4, 186);
    faceScrollview.pagingEnabled=YES;
    
    _pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(0, 186, UI_SCREEN_WIDTH, 30)];
    _pageControl.backgroundColor = [UIColor clearColor];
    _pageControl.numberOfPages = 4;
    _pageControl.currentPage = 0;
    _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    _pageControl.currentPageIndicatorTintColor = TITLE_COLOR;
    
    [_faceBackView addSubview:faceScrollview];
    [_faceBackView addSubview:_pageControl];
}
#pragma mark - ExpressionViewDelegate
-(void)selectedFacialView:(NSString *)str
{
    NSInteger location =  [_textView selectedRange].location;
    NSMutableString *contentViewText = [NSMutableString stringWithString:_textView.text];
    [contentViewText insertString:[NSString stringWithFormat:@"[%@]",str] atIndex:location];
    _textView.text= contentViewText;
    NSArray *arr = [_textView.text componentsSeparatedByString:@"//@"];
    NSString *str2 = [arr objectAtIndex:0];
    _textView.selectedRange = NSMakeRange(str2.length, 0);
    [self updateWordCount];
}
#pragma mark - UIScrollViewDelegate
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    _pageControl.currentPage = scrollView.contentOffset.x/UI_SCREEN_WIDTH;
}

#pragma mark - 选择图片
- (void)goCamera
{
    if ([_imageArray count]>=9)
    {
        [self showHudInView:self.view showHint:@"最多可以发布9张图片"];
        return;
    }
    else
    {
        if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
        {
            SCNavigationController *nav = [[SCNavigationController alloc] init];
            nav.scNaigationDelegate = self;
            [nav showCameraWithParentController:self];
        }
        else
        {
            [self showHudInView:self.view showHint:@"设备不支持"];
        }
    }
}
- (void)goPhoto
{
    if ([_imageArray count]>=9)
    {
        [self showHudInView:self.view showHint:@"最多可以发布9张图片"];
        return;
    }
    else
    {
        UzysAssetsPickerController *picker = [[UzysAssetsPickerController alloc] init];
        picker.delegate = self;
        picker.isPhoto = YES;
        picker.maximumNumberOfSelectionPhoto = 9-_imageArray.count;
        [self presentViewController:picker animated:YES completion:^{}];
    }
}

#pragma mark - 拍照结束
- (void)didTakePicture:(SCNavigationController *)navigationController image:(UIImage *)image
{
    if ([self.tag isEqualToString:@"3"]) {
        self.view.hidden = NO;
    }
    [_textView becomeFirstResponder];
    
    [self dismissViewControllerAnimated:YES completion:^{
        [_imageArray addObject:image];
        [self initPhotoView:_imageArray];
    }];
}
- (void)UzysAssetsPickerController:(UzysAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    if ([self.tag isEqualToString:@"2"]) {
        self.view.hidden = NO;
    }
    [_textView becomeFirstResponder];
    
    for (int i=0; i<assets.count; i++)
    {
        ALAsset *asset = assets[i];
        [_imageArray addObject:[UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage]];
    }
    [self initPhotoView:_imageArray];
}

-(void)initPhotoView:(NSArray *)assets
{
    for (UIView *view in _scrollView.subviews)
    {
        [view removeFromSuperview];
    }
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        _scrollView.contentSize= CGSizeMake((assets.count+1)*68+2, _scrollView.frame.size.height);
        count = assets.count+1;
        for (int i=0; i< count; i++)
        {
            UIImageView *imgview;
            
            imgview=[[UIImageView alloc] initWithFrame:CGRectMake(i*68 + 2, 2, 66, 66)];
            
            imgview.contentMode=UIViewContentModeScaleAspectFill;
            imgview.clipsToBounds=YES;
            UIImage *tempImg;
            
            if (i!=assets.count)
            {
                tempImg = [assets objectAtIndex:i];
            }
            else
            {
                tempImg = [UIImage imageNamed:@"PostWeiBo_tianjiazhaopian"];
            }
            
            imgview.tag = 101+i;
            imgview.userInteractionEnabled = YES;
            [imgview addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImage:)]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [imgview setImage:tempImg];
                [_scrollView addSubview:imgview];
            });
        }
    });
}

- (void)tapImage:(UITapGestureRecognizer *)tap
{
    [_textView resignFirstResponder];
    
    if (tap.view.tag-101!=[_imageArray count])
    {
        ScanPhotoViewController *scanVC = [[ScanPhotoViewController alloc]init];
        scanVC.imgArr = _imageArray;
        scanVC.index = tap.view.tag-101;
        scanVC.delegate = self;
        [self presentViewController:scanVC animated:YES completion:^{}];
    }
    else
    {
        if (_imageArray.count>=9)
        {
            [self showHudInView:self.view showHint:@"最多可以发布9张图片"];
            return;
        }
        [LPActionSheetView showInView:self.view title:@"选择上传图片方式" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"拍照",@"从手机相册选择"] tagNumber:2];
    }
}

#pragma mark - sendPhotoArrDelegate
-(void)sendPhotoArr:(NSArray *)array
{
    [_imageArray removeAllObjects];
    _imageArray = [[NSMutableArray alloc]initWithArray:array];
    [self initPhotoView:_imageArray];
}

#pragma mark - AtFriendViewControllerDelegate

- (void)UserInfoWithUid:(NSString *)uid andUname:(NSString *)uname andAvatar:(NSString *)avatar andintro:(NSString *)intro
{
    NSMutableString *contentViewText = [NSMutableString stringWithString:_textView.text];
    [contentViewText insertString:[ NSString stringWithFormat:@"@%@%@",uname,@" "] atIndex:_textView.selectedRange.location];
    _textView.text = contentViewText;
    [self updateWordCount];
}
#pragma mark - PostTopicViewControllerDelegate
- (void)PostTopicListViewWithTopicName:(NSString *)name
{
    _commenTopicName = name;
    NSMutableString *contentViewText = [NSMutableString stringWithString:_textView.text];
    [contentViewText insertString:[ NSString stringWithFormat:@"#%@%@",name,@"#"] atIndex:_textView.selectedRange.location];
    _textView.text = contentViewText;
    [self updateWordCount];
}

#pragma mark - 位置相关
#pragma mark - CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    CLLocation *newLocation = [locations firstObject];
    [_locationManager stopUpdatingLocation];
    [self shiftReGeoCodeByLocation:newLocation.coordinate];
    
}
//改变坐标系，从地球坐标系转换到火星坐标系
- (void)shiftReGeoCodeByLocation:(CLLocationCoordinate2D )userLocation
{
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    NSString *urlString = [NSString stringWithFormat:@"http://restapi.amap.com/v3/assistant/coordinate/convert?key=%@&locations=%f,%f&coordsys=gps&output=json",GaoDeRestKey,userLocation.longitude,userLocation.latitude];
    [manager GET:urlString parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        
        if([dic[@"info"] isEqualToString:@"ok"]){
            NSString *loc = dic[@"locations"];
            NSArray *arr = [loc componentsSeparatedByString:@","];
            CLLocationCoordinate2D location = CLLocationCoordinate2DMake([arr[1] doubleValue], [arr[0] doubleValue]);
            
            //得到 火星坐标后续处理
            longitude = location.longitude;
            latitude = location.latitude;
            
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%f",location.longitude],@"longitude",[NSString stringWithFormat:@"%f",location.latitude],@"latitude", nil];
            [Api requestWithMethod:@"GET" withPath:API_URL_CheckinLo withParams:param withSuccess:^(id responseObject) {
                NSLog(@"res = %@",responseObject);
            } withError:^(NSError *error) {
                
            }];
            
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络不好，请稍后再试!");
        [self showHudInView:self.view showHint:@"定位失败"];
    }];
}

- (void)labeltgrClick
{
    NSMutableArray *oneArray = [NSMutableArray array];
    [oneArray addObjectsFromArray:_plazaArray];
    [oneArray addObjectsFromArray:[_biaoqianDic objectForKey:@"_selectArray"]];
    [_biaoqianDic setObject:oneArray forKey:@"_selectArray"];
    
    LabelsClassViewController *lablesClassNV = [[LabelsClassViewController alloc]initWithNibName:nil bundle:nil withselectArray:_plazaSeletedArray];
    //            [self.navigationController pushViewController:lablesClassNV animated:YES];
    [self presentViewController:lablesClassNV animated:YES completion:^{ }];
}

- (void)locationClick
{
    if (isLocation)
    {
        [LPActionSheetView showInView:self.view title:@"位置操作" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:nil otherButtonTitles:@[@"删除位置",@"修改位置"] tagNumber:1];
    }
    else
    {
        [self insertLocation];
    }
}
-(void)insertLocation
{
    InsertLocationViewController *locationVC = [[InsertLocationViewController alloc] init];
    locationVC.delegate = self;
    locationVC.isPost = YES;
    locationVC.selectIndex = selectIndex;
    locationVC.selectName = _locationStr;
    locationVC.selectAddress = selectAddress;
    [self presentViewController:locationVC animated:YES completion:^{
    }];
}
- (void)actionSheet:(LPActionSheetView *)actionSheetView clickedOnButtonIndex:(NSInteger)buttonIndex
{
    switch (actionSheetView.tag)
    {
        case 1:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    [self deleteLocation];
                }
                    break;
                case 1:
                {
                    [self insertLocation];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
        case 2:
        {
            switch (buttonIndex)
            {
                case 0:
                {
                    [self goCamera];
                }
                    break;
                case 1:
                {
                    [self goPhoto];
                }
                    break;
                    
                default:
                    break;
            }
        }
            break;
            
        default:
            break;
    }
}
-(void)deleteLocation
{
    isLocation = NO;
    
    //    _locationLabel.frame = CGRectMake(30, 5, 50, 14);
    _locationLabel.text = @"选择位置";
    //    _locationView.frame = CGRectMake(12, CGRectGetMaxY(_customView.frame)+12, 80, 24);
    
    _locationStr = @"";
    
    [_textView becomeFirstResponder];
}
-(void)showLocation:(NSDictionary *)dic andIndex:(NSInteger)index andImagePath:(NSString *)filePath andImage:(UIImage *)image
{
    AMapGeoPoint *point= [dic objectForKey:@"location"];
    
    _locationStr = [dic objectForKey:@"name"];
    selectAddress = [dic objectForKey:@"address"];
    latitude = point.latitude;
    longitude = point.longitude;
    selectIndex=index;
    
    //    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
    //    CGSize timeSize = [_locationStr boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    //    float length;
    //    if (timeSize.width >= 200.0)
    //    {
    //        length = 200;
    //    }
    //    else
    //    {
    //        length = timeSize.width;
    //    }
    //    _locationLabel.frame = CGRectMake(30, 5, length, 14);
    //    _locationView.frame = CGRectMake(12, CGRectGetMaxY(_customView.frame)+12, length+40, 24);
    _locationLabel.text = _locationStr;
    isLocation = YES;
    
    [_textView becomeFirstResponder];
}
#pragma mark - upyun
-(NSString * )getSaveKey:(NSInteger)tag {
    /**
     *	@brief	方式1 由开发者生成saveKey
     */
    NSDate *d = [NSDate date];
    NSTimeInterval dat = [[NSDate date] timeIntervalSince1970]*1000*1000;
    NSMutableDictionary *dic = [_imageUrlDetailDic objectForKey:[NSString stringWithFormat:@"%ld",tag]];
    [dic setObject:[NSString stringWithFormat:@"%.0f",dat] forKey:@"imageSaveName"];
    [dic setObject:@"jpg" forKey:@"imageExtension"];
    [dic setObject:[NSString stringWithFormat:@"/%@/%@%@/%@/",[self changeStandrad:[self getYear:d]],[self changeStandrad:[self getMonth:d]],[self changeStandrad:[self getDay:d]],[self changeStandrad:[self getHour:d]]] forKey:@"imageSavePath"];
    [dic setObject:@"orgname" forKey:@"imageOrigName"];
    [dic setObject:@"" forKey:@"hash"];
    [_imageUrlDetailDic setObject:dic forKey:[NSString stringWithFormat:@"%ld",tag]];
    return [NSString stringWithFormat:@"/%@/%@%@/%@/%.0f.jpg",[self changeStandrad:[self getYear:d]],[self changeStandrad:[self getMonth:d]],[self changeStandrad:[self getDay:d]],[self changeStandrad:[self getHour:d]],dat];
    
    /**
     *	@brief	方式2 由服务器生成saveKey
     */
    //    return [NSString stringWithFormat:@"/{year}/{mon}/{filename}{.suffix}"];
    
    /**
     *	@brief	更多方式 参阅 http://wiki.upyun.com/index.php?title=Policy_%E5%86%85%E5%AE%B9%E8%AF%A6%E8%A7%A3
     */
    
}
- (NSString *)changeStandrad:(NSInteger)data
{
    NSString *changeData;
    if(data < 10) {
        changeData = [NSString stringWithFormat:@"0%ld",data];
    } else {
        changeData = [NSString stringWithFormat:@"%ld",data];
    }
    return changeData;
}

- (NSInteger)getYear:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSYearCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger year=[comps year];
    return year;
}

- (NSInteger)getMonth:(NSDate *) date{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSMonthCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger month = [comps month];
    return month;
}
- (NSInteger)getDay:(NSDate *) date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger day = [comps day];
    return day;
}
- (NSInteger)getHour:(NSDate *)date
{
    NSDateFormatter *formatter =[[NSDateFormatter alloc] init];
    [formatter setTimeStyle:NSDateFormatterMediumStyle];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSInteger unitFlags = NSHourCalendarUnit;
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    NSInteger hour = [comps hour];
    return hour;
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
