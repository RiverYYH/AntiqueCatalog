//
//  PostCommentViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/24.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "PostCommentViewController.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIImageView+WebCache.h"
#import "AFURLRequestSerialization.h"
#import "AFHTTPRequestOperation.h"
#import "UIViewController+HUD.h"

@interface PostCommentViewController ()
{
    UIPlaceHolderTextView *_textView;
    UIView *_customView;
    UILabel *_countLabel;
    
    UIButton *_smileButton;
    UIView *_faceBackView;
    UIPageControl *_pageControl;
    
    float _textCount;
    NSString *_feedID;
    NSString *_placeHolderContent;
    
    BOOL _isSmile;
    PostType _postType;
    NSInteger _showHeight;
    NSString *_showImageUrlString;
    NSString *_showTitleString;
    NSString *_showcontentString;
    
    CLLocationManager *_locationManager;
    UIView *_locationView;
    UIImageView *_locationImageView;
    UILabel *_locationLabel;
    //定位相关
    BOOL isLocation;
    NSString *_locationStr;
    double latitude,longitude;
    NSInteger selectIndex;
    NSString *selectAddress;
    NSInteger _locationHeight;
    
}
@end

@implementation PostCommentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFeedID:(NSString *)feedID andPlaceHolderContent:(NSString *)placeHolderContent andPostType:(PostType)postType andPostShowTitle:(NSString *)titleString andPostShowImage:(NSString *)imageStringUrl andPostShowcontent:(NSString *)contentString
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _feedID = feedID;
        _placeHolderContent = placeHolderContent;
        _postType = postType;
        _showcontentString = contentString;
        _showImageUrlString = imageStringUrl;
        _showTitleString = titleString;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    }
    return self;
}

-(void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
    
	[_textView becomeFirstResponder];
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - 通知方法
- (void)keyboardWillShow:(NSNotification *)notification
{
    _isSmile = YES;
    
    [_smileButton setImage:[UIImage imageNamed:@"PostWeiBo_biaoqing"] forState:UIControlStateNormal];
    
    NSValue *endValue   = [notification.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    _textView.frame = CGRectMake(12, UI_NAVIGATION_BAR_HEIGHT+_showHeight, UI_SCREEN_WIDTH-24, UI_SCREEN_HEIGHT-[endValue CGRectValue].size.height-49-24);
    
    [UIView animateWithDuration:0.3 animations:^{
        _faceBackView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 216);
        _customView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-[endValue CGRectValue].size.height-49-24, UI_SCREEN_WIDTH, 44);
        _countLabel.frame = CGRectMake(UI_SCREEN_WIDTH-64, UI_SCREEN_HEIGHT-[endValue CGRectValue].size.height-24, 50, 24);
        _locationView.frame = CGRectMake(12, UI_SCREEN_HEIGHT-[endValue CGRectValue].size.height-24, _locationHeight+40, 24);
    }];
}
- (void)keyboardWillHide:(NSNotification *)tification
{
    _textView.frame = CGRectMake(12, UI_NAVIGATION_BAR_HEIGHT+_showHeight, UI_SCREEN_WIDTH-24, UI_SCREEN_HEIGHT-49-24);
    
    [UIView animateWithDuration:0.3 animations:^{
        _faceBackView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 216);
        _customView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-49-24, UI_SCREEN_WIDTH, 44);
        _countLabel.frame = CGRectMake(UI_SCREEN_WIDTH-64, UI_SCREEN_HEIGHT-24, 50, 24);
        _locationView.frame = CGRectMake(12, UI_SCREEN_HEIGHT-24, _locationHeight+40, 24);
    }];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    switch (_postType)
    {
        case PostTypeComment:
        {
            self.titleLabel.text = @"发评论";
        }
            break;
        case PostTypeForward:
        {
             self.titleLabel.text = @"转发分享";
        }
            break;
        case PostTypeForwardCircle:
        {
             self.titleLabel.text = @"转发长文";
        }
            break;
        case PostTypeForwardKnowledge:
        {
             self.titleLabel.text = @"转发知识";
        }
            break;
        default:
            break;
    }
	[self.leftButton setImage:nil forState:UIControlStateNormal];
	[self.leftButton setTitle:@"取消" forState:UIControlStateNormal];
	[self.leftButton setTitle:@"发布" forState:UIControlStateNormal];
    
    _showHeight = 0;
    if (_postType == PostTypeForward || _postType == PostTypeForwardCircle || _postType == PostTypeForwardKnowledge) {
        
        _showHeight = 92;
        
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(12, UI_NAVIGATION_BAR_HEIGHT+6, UI_SCREEN_WIDTH-24, 80)];
        [self.view addSubview:bgView];
        
        NSInteger exsit = 0;
        if(STRING_NOT_EMPTY(_showImageUrlString)) {
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, 70, 70)];
            [imageView sd_setImageWithURL:[NSURL URLWithString:_showImageUrlString] placeholderImage:[UIImage imageNamed:@"morentupian"]];
            [bgView addSubview:imageView];
            
            exsit = 80;
        }
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(exsit, 0, UI_SCREEN_WIDTH-24-exsit, 30)];
        titleLabel.text = _showTitleString;
        titleLabel.textColor = TITLE_COLOR;
        titleLabel.numberOfLines = 0;
        [bgView addSubview:titleLabel];
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(exsit, 30, UI_SCREEN_WIDTH-24-exsit, 50)];
        contentLabel.text = [self flattenHTML:_showcontentString trimWhiteSpace:YES];
        contentLabel.textColor = CONTENT_COLOR;
        contentLabel.numberOfLines = 0;
        contentLabel.font = [UIFont systemFontOfSize:12];
        [bgView addSubview:contentLabel];
        
        UILabel *lineLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT+_showHeight, UI_SCREEN_WIDTH, 0.5)];
        lineLabel.backgroundColor = LINE_COLOR;
        [self.view addSubview:lineLabel];
    }
    
    _textView = [[UIPlaceHolderTextView alloc]initWithFrame:CGRectMake(12, UI_NAVIGATION_BAR_HEIGHT+_showHeight, UI_SCREEN_WIDTH-24, 150)];
	_textView.font = [UIFont systemFontOfSize:15.0];
	_textView.delegate = self;
	_textView.placeholder = @"写点儿什么...";
	_textView.placeholderColor = CONTENT_COLOR;
    _textView.textColor = CONTENT_COLOR;
    _textView.backgroundColor = [UIColor clearColor];
    if (STRING_NOT_EMPTY(_placeHolderContent))
    {
        _textView.text = _placeHolderContent;
        _textView.selectedRange = NSMakeRange(0, 0);
    }
	[self.view addSubview:_textView];
    
    _customView = [[UIView alloc] initWithFrame:CGRectMake(0, UI_SCREEN_HEIGHT-216-49, UI_SCREEN_WIDTH, 44)];
    [self.view addSubview:_customView];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(12, 0, UI_SCREEN_WIDTH-24, 0.5)];
    line1.backgroundColor = LINE_COLOR;
    [_customView addSubview:line1];
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(12, 43.5, UI_SCREEN_WIDTH-24, 0.5)];
    line2.backgroundColor = LINE_COLOR;
    [_customView addSubview:line2];
    
    NSArray *arr = @[@"PostWeiBo_aite",@"PostWeiBo_huati",@"PostWeiBo_biaoqing"];
    for (int i=0; i<3; i++)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(21.5+((UI_SCREEN_WIDTH-53-180)/4.0+10+50)*i, 11, (UI_SCREEN_WIDTH-53-180)/4.0+10, 22);
        button.adjustsImageWhenHighlighted = NO;
        button.tag = 101+i;
        [button setImage:[UIImage imageNamed:[arr objectAtIndex:i]] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [_customView addSubview:button];
        
        if (i == 2)
        {
            _smileButton = button;
        }
    }
	
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
    
    _locationView = [[UIView alloc]initWithFrame:CGRectMake(12, CGRectGetMaxY(_customView.frame)-24, 80, 24)];
    _locationView.backgroundColor = HEADER_COLOR;
    _locationView.layer.masksToBounds = YES;
    _locationView.layer.cornerRadius = 12;
    [self.view addSubview:_locationView];
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(locationClick)];
    [_locationView addGestureRecognizer:tgr];
    
    _locationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 17, 14)];
    _locationImageView.image = [UIImage imageNamed:@"PostWeiBo_dingwei"];
    [_locationView addSubview:_locationImageView];
    
    _locationLabel = [[UILabel alloc]initWithFrame:CGRectMake(30, 5, 50, 14)];
    _locationLabel.font = [UIFont systemFontOfSize:14.0];
    _locationLabel.textColor = TITLE_COLOR;
    _locationLabel.text = @"我在...";
    [_locationView addSubview:_locationLabel];
    
	_countLabel = [[UILabel alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH-62, CGRectGetMinY(_customView.frame)-24, 50, 24)];
	_countLabel.font = [UIFont systemFontOfSize:11.0];
	_countLabel.textAlignment = NSTextAlignmentRight;
	_countLabel.textColor = TITLE_COLOR;
	_countLabel.text = [NSString stringWithFormat:@"%d/300",300];
	[self.view addSubview:_countLabel];
    
    [self updateFace];
    _isSmile = YES;
    _locationStr = @"";
    _locationHeight = 40;
}

//去除HTML标签
- (NSString *)flattenHTML:(NSString *)html trimWhiteSpace:(BOOL)trim {
    NSScanner *theScanner = [NSScanner scannerWithString:html];
    NSString *text = nil;
    while ([theScanner isAtEnd] == NO) {
        // find start of tag
        [theScanner scanUpToString:@"<" intoString:NULL] ;
        // find end of tag
        [theScanner scanUpToString:@">" intoString:&text] ;
        // replace the found tag with a space
        //(you can filter multi-spaces out later if you wish)
        html = [html stringByReplacingOccurrencesOfString:[ NSString stringWithFormat:@"%@>", text]withString:@""];
    }
    return trim ? [html stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] : html;
}

- (void)leftButtonClick:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)buttonClicked:(UIButton *)button
{
    [_textView resignFirstResponder];
    
    switch (button.tag)
    {
        case 101:
        {
            AtFriendViewController *topicVC = [[AtFriendViewController alloc] init];
            topicVC.delegate = self;
            [self presentViewController:topicVC animated:YES completion:nil];
        }
            break;
        case 102:
        {
            TopicViewController *topicVC = [[TopicViewController alloc] init];
            topicVC.delegate = self;
            [self presentViewController:topicVC animated:YES completion:nil];
        }
            break;
        case 103:
        {
            if (_isSmile)
            {
                _isSmile = NO;

                [UIView animateWithDuration:0.3 animations:^{
                    _faceBackView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-216, UI_SCREEN_WIDTH, 216);
                    _customView.frame = CGRectMake(0, UI_SCREEN_HEIGHT-216-49, UI_SCREEN_WIDTH, 44);
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
    
    if (!STRING_NOT_EMPTY(_textView.text))
    {
        [self showHudInView:self.view showHint:@"内容不得为空"];
        return;
    }
    
    if(!longitude) {
        NSDictionary *dic = [UserModel userLocation];
        longitude = [[dic objectForKey:@"longitude"] doubleValue];
        latitude = [[dic objectForKey:@"latitude"] doubleValue];
    }
    
    if (_textCount>300)
    {
        [self showHudInView:self.view showHint:@"字数不可超过300"];
        return;
    }
    
    NSDictionary *param = [NSDictionary dictionary];
    NSString *path = [NSString string];
    switch (_postType)
    {
        case PostTypeComment:
        {
            param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"content",@"3",@"from",_feedID,@"feed_id", nil];
            path = API_URL_COMMENT_weibo;
        }
            break;
        case PostTypeForward:
        {
            if([_locationStr isEqualToString:@""]){
                param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"content",@"3",@"from",_feedID,@"feed_id",[NSString stringWithFormat:@"%f",longitude], @"longitude",[NSString stringWithFormat:@"%f",latitude], @"latitude", nil];
            } else {
                param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"content",@"3",@"from",_feedID,@"feed_id", _locationStr, @"address",[NSString stringWithFormat:@"%f",longitude], @"longitude",[NSString stringWithFormat:@"%f",latitude], @"latitude", nil];
            }
            path = API_URL_REPOST_weibo;
        }
            break;
        case PostTypeForwardCircle:
        {
            if([_locationStr isEqualToString:@""]) {
                param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"content",@"3",@"from",_feedID,@"post_id",@"1",@"ifShareFeed",[NSString stringWithFormat:@"%f",longitude], @"longitude",[NSString stringWithFormat:@"%f",latitude], @"latitude", nil];
            } else {
                param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"content",@"3",@"from",_feedID,@"post_id",@"1",@"ifShareFeed", _locationStr, @"address", [NSString stringWithFormat:@"%f",longitude], @"longitude",[NSString stringWithFormat:@"%f",latitude], @"latitude", nil];
            }
            path = API_URL_COMMENT_weiba;
        }
            break;
        case PostTypeForwardKnowledge:
        {
            if([_locationStr isEqualToString:@""]){
                param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"content",@"3",@"from",_feedID,@"feed_id",[NSString stringWithFormat:@"%f",longitude], @"longitude",[NSString stringWithFormat:@"%f",latitude], @"latitude", nil];
            } else {
                param = [NSDictionary dictionaryWithObjectsAndKeys:_textView.text,@"content",@"3",@"from",_feedID,@"feed_id", _locationStr, @"address", [NSString stringWithFormat:@"%f",longitude], @"longitude",[NSString stringWithFormat:@"%f",latitude], @"latitude", nil];
            }
            path = API_URL_REPOST_Knowledge;
        }
            break;
        default:
            break;
    }
    [self showHudInView:self.view hint:@"发送中..."];
	[Api requestWithMethod:@"get" withPath:path withParams:param withSuccess:^(id responseObject) {
		if ([[responseObject objectForKey:@"status"] intValue]==1)
        {
            [self dismissViewControllerAnimated:YES completion:nil];
            switch (_postType)
            {
                case PostTypeComment:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"commentWeiBoSucceed" object:self userInfo:nil];
                }
                    break;
                case PostTypeForward:
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"PostWeiBoSucceed" object:self userInfo:@{@"feed_id": [responseObject objectForKey:@"feed_id"]}];
                }
                    break;
                default:
                    break;
            }
		}
        else
        {
			[self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
		}
        [self hideHud];
	} withError:^(NSError *error) {
        [self hideHud];
        [self showHudInView:self.view showHint:@"请检查网络设置"];
	}];
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


- (void)locationClick
{
    if (isLocation)
    {
        [self.view endEditing:YES];
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
            
        default:
            break;
    }
}
-(void)deleteLocation
{
    isLocation = NO;
    
    _locationLabel.frame = CGRectMake(30, 5, 50, 14);
    _locationLabel.text = @"我在...";
    _locationView.frame = CGRectMake(12, CGRectGetMaxY(_customView.frame)+12, 80, 24);
    
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
    
    NSDictionary * dic1 = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:14],NSFontAttributeName,nil];
    CGSize timeSize = [_locationStr boundingRectWithSize:CGSizeMake(UI_SCREEN_WIDTH, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic1 context:nil].size;
    if (timeSize.width >= 200.0)
    {
        _locationHeight = 200;
    }
    else
    {
        _locationHeight = timeSize.width;
    }
    _locationLabel.frame = CGRectMake(30, 5, _locationHeight, 14);
    _locationView.frame = CGRectMake(12, CGRectGetMaxY(_customView.frame)+12, _locationHeight+40, 24);
    _locationLabel.text = _locationStr;
    isLocation = YES;
    
    [_textView becomeFirstResponder];
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
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.view endEditing:YES];
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
        _countLabel.text = @"300/300";
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
	[contentViewText insertString:[NSString stringWithFormat:@" [%@]",str] atIndex:location];
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

#pragma mark - AtFriendViewControllerDelegate
- (void)returnAtName:(NSString *)name
{
    NSMutableString *contentViewText = [NSMutableString stringWithString:_textView.text];
    [contentViewText insertString:[ NSString stringWithFormat:@"@%@%@",name,@" "] atIndex:_textView.selectedRange.location];
    _textView.text = contentViewText;
	[self updateWordCount];
}

#pragma mark - TopicViewControllerDelegate
- (void)returnTopicName:(NSString *)name
{
    NSMutableString *contentViewText = [NSMutableString stringWithString:_textView.text];
    [contentViewText insertString:[ NSString stringWithFormat:@"#%@%@",name,@"#"] atIndex:_textView.selectedRange.location];
    _textView.text = contentViewText;
	[self updateWordCount];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end