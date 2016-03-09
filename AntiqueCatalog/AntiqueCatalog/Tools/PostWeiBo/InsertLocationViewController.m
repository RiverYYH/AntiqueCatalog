//
//  InsertLocationViewController.m
//  RiseClub
//
//  Created by liuxiaoqing on 14-9-26.
//  Copyright (c) 2014年 huweihong. All rights reserved.
//

#import "InsertLocationViewController.h"
#import "AFNetworking.h"
#import "AFHTTPRequestOperationManager.h"
#import "UIViewController+HUD.h"

@interface InsertLocationViewController ()

@end

@implementation InsertLocationViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.dataArray=[[NSMutableArray alloc]init];
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    self.titleLabel.text=@"我在这里";

    //地图搜索为地理编码和反地理编码做准备b977ac25274ba12b0db8a3da58159a04
    search=[[AMapSearchAPI alloc]initWithSearchKey:@"b977ac25274ba12b0db8a3da58159a04" Delegate:self];
    [self creatTableView];
    [self setLocation];
    [self creatSearchBar];
    [self creatMap];
    if (self.selectName.length) {
         [self GeocodeSearch];
    }
	
}

-(void)leftButtonClick:(id)sender{
    [self clearMapView];
    
	if (_isPost) {
		[self dismissViewControllerAnimated:YES completion:^{
			
		}];
	}else{
		[self.navigationController popViewControllerAnimated:YES];
	}
}

- (void)clearMapView
{
    _mapView.showsUserLocation = NO;
    [_mapView removeAnnotations:_mapView.annotations];
    [_mapView removeOverlays:_mapView.overlays];
    _mapView.delegate = nil;
}

-(void)GeocodeSearch
{
    //搜索请求的初始化
    AMapGeocodeSearchRequest *request=[[AMapGeocodeSearchRequest alloc]init];
    
    //设置搜索类型 正向的地理编码  5是正向 6是逆向
    request.searchType=AMapSearchType_Geocode;
    //设置一个地址
    request.address=self.selectName;
    //设置搜索的半径
    //把请求加入到搜索API指针中,结果在代理中返回
    [search AMapGeocodeSearch:request];
}
-(void)reGeocodeSearch
{
    //反地理编码
    AMapReGeocodeSearchRequest *reRequest=[[AMapReGeocodeSearchRequest alloc]init];
    //设置地理位置
    reRequest.radius=1000;
    reRequest.searchType=AMapSearchType_ReGeocode;
    reRequest.location=[AMapGeoPoint locationWithLatitude:[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue]    longitude:[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] floatValue]];
    //是否返回周边信息
    reRequest.requireExtension=YES;
    [search AMapReGoecodeSearch:reRequest];
    
    //周边搜索
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init]; poiRequest.searchType = AMapSearchType_PlaceAround;

    poiRequest.location = [AMapGeoPoint locationWithLatitude:[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"] floatValue] longitude:[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"] floatValue]];
    poiRequest.radius= 1000;
    [search AMapPlaceSearch: poiRequest];
    
}
#pragma mark-搜索方法
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest*)request response:(AMapPlaceSearchResponse *)response
{
    if (self.dataArray.count) {
        [self.dataArray removeAllObjects];
    }
    NSString *strCount = [NSString stringWithFormat:@"count: %d",response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"Suggestion: %@", response.suggestion];
    NSString *strPoi = @"";
    for (AMapPOI *p in response.pois) {
//        strPoi = [NSString stringWithFormat:@"%@\nPOI:%@", strPoi, p.description];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:p.name,@"name",p.address,@"address",p.location,@"location", nil];
            [self.dataArray addObject:dic];
    
    }

    NSString *result = [NSString stringWithFormat:@"%@ \n %@ \n %@", strCount, strSuggestion, strPoi];
    NSLog(@"Place:%@", result);
    [_tableView reloadData];
}
#pragma matk-MapViewDelegate
- (MAAnnotationView*)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[mapView.userLocation class]]) {
        return nil;
    }
    MAPinAnnotationView *pinview=(MAPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"ID"];
    if (pinview==nil) {
        pinview=[[MAPinAnnotationView alloc]initWithAnnotation:annotation reuseIdentifier:@"ID"];
        
        //是否显示气泡弹出框
        pinview.canShowCallout=YES;
        //设置动画
        pinview.animatesDrop=YES;
    }
    pinview.bounds=CGRectMake(0, 0, 50, 50);
    UIButton *submitBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    submitBtn.frame=CGRectMake(0, 0, 20, 20);
    [submitBtn setBackgroundImage:[UIImage imageNamed:@"ico_sel_small"] forState:0];
    pinview.rightCalloutAccessoryView=submitBtn;
    return pinview;
}
-(void)mapView:(MAMapView *)mapView annotationView:(MAAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control
{
    
//    MAPointAnnotation* annotation=view.annotation;
//    [[NSNotificationCenter defaultCenter]postNotificationName:@"SELECTED_SCHOOL_MAP" object:annotation.title];
//    [self dismissViewControllerAnimated:YES completion:^{
//        [[NSNotificationCenter defaultCenter]postNotificationName:@"dismiss1" object:nil];
//        
//    }];
    [self.navigationController popViewControllerAnimated:YES];
    
}

#pragma mark-地理编码
-(void)onGeocodeSearchDone:(AMapGeocodeSearchRequest *)request response:(AMapGeocodeSearchResponse *)response
{
    //返回根据地址搜索回来的经纬度 地理编码结果
    if (response.geocodes.count) {
        //        AMapGeocode *amp=[response.geocodes objectAtIndex:0];
        for (AMapGeocode *amp in response.geocodes) {
            //添加大头针
            MAPointAnnotation *annotation=[[MAPointAnnotation alloc]init];
            annotation.coordinate=CLLocationCoordinate2DMake(amp.location.latitude,amp.location.longitude);
            //解析地址
            annotation.title=self.selectName;
            annotation.subtitle=self.selectAddress;
            [_mapView addAnnotation:annotation];
            
        }
    }
}
#pragma mark-反地理编码
-(void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    self.currentLocation=response.regeocode.formattedAddress;
}

-(void)setLocation
{
	locManager=[[CLLocationManager alloc]init];
	locManager.delegate = self;
	locManager.desiredAccuracy = kCLLocationAccuracyBest;
	locManager.distanceFilter = 0.5;
	if ([CLLocationManager locationServicesEnabled]) {
		[locManager startUpdatingLocation];
	}
}

#pragma mark-CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager
	didUpdateToLocation:(CLLocation *)newLocation
		   fromLocation:(CLLocation *)oldLocation{
	
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
            //经纬度
            NSString *latStr=[NSString stringWithFormat:@"%f",location.latitude] ;
            NSString * lonStr=[NSString stringWithFormat:@"%f",location.longitude];
            
            [[NSUserDefaults standardUserDefaults] setObject:latStr forKey:@"latitude"];
            [[NSUserDefaults standardUserDefaults] setObject:lonStr forKey:@"longitude"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            [self reGeocodeSearch];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"网络不好，请稍后再试!");
        [self showHudInView:self.view showHint:@"定位失败"];
    }];
}
- (void)locationManager:(CLLocationManager *)manager
	   didFailWithError:(NSError *)error{
	
	NSString *errorString;
	[manager stopUpdatingLocation];
	NSLog(@"Error===== %@",[error localizedDescription]);
	switch([error code]) {
		case kCLErrorDenied:
			//Access denied by user
			errorString = @"Access to Location Services denied by user";
			//Do something...
            [self showHudInView:self.view showHint:@"无法获取位置信息!"];
			break;
		case kCLErrorLocationUnknown:
			//Probably temporary...
			errorString = @"Location data unavailable";
            [self showHudInView:self.view showHint:@"位置服务不可用!"];
			//Do something else...
			break;
		default:
			errorString = @"An unknown error has occurred";
            [self showHudInView:self.view showHint:@"定位发生错误!"];
			break;
	}
}

-(void)creatSearchBar
{
    _searchBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, (UI_NAVIGATION_BAR_HEIGHT), UI_SCREEN_WIDTH, 44)];
    _searchBar.placeholder=@"搜索附近位置";
    _searchBar.delegate=self;
    [self.view addSubview:_searchBar];
}
-(void)creatMap
{
    [MAMapServices sharedServices].apiKey = @"b977ac25274ba12b0db8a3da58159a04";

    _mapView=[[MAMapView alloc]initWithFrame:CGRectMake(0, (UI_NAVIGATION_BAR_HEIGHT)+44, UI_SCREEN_WIDTH,(UI_SCREEN_HEIGHT-(UI_NAVIGATION_BAR_HEIGHT)-44)/2)];
    _mapView.delegate=self;
    _mapView.showsUserLocation=YES;
    _mapView.logoCenter=CGPointMake(UI_SCREEN_WIDTH-55, (UI_SCREEN_HEIGHT-(UI_NAVIGATION_BAR_HEIGHT)-44)/2-10);
    [self.view addSubview:_mapView];
    _mapView.logoCenter=CGPointMake(UI_SCREEN_WIDTH-50, UI_SCREEN_HEIGHT-(UI_NAVIGATION_BAR_HEIGHT)-10);
    _mapView.showsUserLocation=YES;
    [_mapView setUserTrackingMode:MAUserTrackingModeFollow animated:YES];
    _mapView.showsScale=NO;
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_searchBar resignFirstResponder];
}
-(void)creatTableView
{
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0,(UI_NAVIGATION_BAR_HEIGHT)+44+(UI_SCREEN_HEIGHT-(UI_NAVIGATION_BAR_HEIGHT)-44)/2, UI_SCREEN_WIDTH, (UI_SCREEN_HEIGHT-(UI_NAVIGATION_BAR_HEIGHT)-44)/2) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    [self.view addSubview:_tableView];
}
#pragma mark-UISearchBar
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init]; poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = searchBar.text;
    poiRequest.city = @[@"beijing"];
    poiRequest.requireExtension = YES;
    [search AMapPlaceSearch: poiRequest];
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	[_searchBar resignFirstResponder];
}

-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
	for (UIView *v in searchBar.subviews)
	{
		if ([v isKindOfClass:[UIButton class]])
		{
			UIButton *btn = (UIButton *)v;
			[btn setTitle:@"取消" forState:UIControlStateNormal];
			[btn setTitleColor:[UIColor darkGrayColor] forState:0];
		}
	}
	return  YES;
}

-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:NO animated:YES];
	[_searchBar resignFirstResponder];
}


#pragma mark-UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 60;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
	if (self.dataArray.count) {
		return self.dataArray.count+1;
	}else{
		return 1;
	}
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LocationTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell==nil) {
        cell=[[LocationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    if (indexPath.row==0) {
        [cell updateCell1:self.currentLocation andIndex:indexPath.row andSelectIndex:self.selectIndex];
    }
    else
    {
		if (self.dataArray.count) {
			[cell updateCell:[self.dataArray objectAtIndex: indexPath.row-1] andIndex:indexPath.row andSelectIndex:self.selectIndex];
		}
    }
//    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isPost)
    {
        if ([self.delegate respondsToSelector:@selector(showLocation: andIndex:andImagePath:andImage:)])
        {
            if (indexPath.row==0)
            {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:[[user objectForKey:@"latitude"] floatValue] longitude:[[user objectForKey:@"longitude"] floatValue]];
                [self.delegate showLocation:[NSDictionary dictionaryWithObjectsAndKeys:point,@"location",self.currentLocation,@"name", self.currentLocation,@"address",nil] andIndex:indexPath.row andImagePath:nil	andImage:nil];
            }
            else
            {
                [self.delegate showLocation:[self.dataArray objectAtIndex:indexPath.row-1] andIndex:indexPath.row andImagePath:nil andImage:nil];
            }
            [self clearMapView];
            [self dismissViewControllerAnimated:YES completion:^{}];
        }
    }
    else
    {
        UIImage *sendImage = [_mapView takeSnapshotInRect:CGRectMake(0, 0, UI_SCREEN_WIDTH, 160)];
        NSData *imageViewData = UIImagePNGRepresentation(sendImage);
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths objectAtIndex:0];
        NSDate *datenow = [NSDate date];
        NSString *time = [NSString stringWithFormat:@"%ld", (long)[datenow timeIntervalSince1970]];
        NSString *pictureName= [NSString stringWithFormat:@"map_%@.png",time];
        NSString *savedImagePath = [documentsDirectory stringByAppendingPathComponent:pictureName];
        [imageViewData writeToFile:savedImagePath atomically:YES];//保存照片到沙盒目录
        if ([self.delegate respondsToSelector:@selector(showLocation: andIndex:andImagePath:andImage:)])
        {
            if (indexPath.row==0) {
                NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                AMapGeoPoint *point = [AMapGeoPoint locationWithLatitude:[[user objectForKey:@"latitude"] floatValue] longitude:[[user objectForKey:@"longitude"] floatValue]];
                [self.delegate showLocation:[NSDictionary dictionaryWithObjectsAndKeys:point,@"location",self.currentLocation,@"name",self.currentLocation,@"address", nil] andIndex:indexPath.row andImagePath:savedImagePath andImage:sendImage];
            }
            else
            {
                [self.delegate showLocation:[self.dataArray objectAtIndex:indexPath.row-1] andIndex:indexPath.row andImagePath:savedImagePath andImage:sendImage];
            }
            [self clearMapView];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
