//
//  AuctionViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/14.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "AuctionViewController.h"

#import "AntiqueCatalogData.h"
#import "AntiqueCatalogViewCell.h"
#import "CatalogDetailsViewController.h"

#import "Authordata.h"
#import "citydata.h"

#import "RetrievalConditionView.h"

#define headheight 30

@interface AuctionViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,RetrievalConditionViewDelegate>

@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray  *catalogArray;//图录数组
@property (nonatomic,assign)NSInteger       page;
@property (nonatomic,assign)BOOL            isMore;

@property (nonatomic,strong)Authordata      *authordata;
@property (nonatomic,strong)citydata        *cityData;
@property (nonatomic,strong)NSMutableArray  *authorArray;
@property (nonatomic,strong)NSMutableArray  *cityArray;

@property (nonatomic,strong)UIView          *headView;
@property (nonatomic,strong)UILabel         *label;
@property (nonatomic,strong)UIButton        *button;
@property (nonatomic,strong)RetrievalConditionView *retrievalView;
@property (nonatomic,assign)BOOL            isretrievalView;

@property (nonatomic,assign)NSInteger       yearinteger;//为了判断年份的选项,决定retrievalView和tableView的frame,我只能说这样的数据设计真操蛋
@property (nonatomic,assign)NSInteger       monthinteger;

@property (nonatomic,copy)NSString          *v_status;//预展状态,拍卖结束传 1 ,其他不用传
@property (nonatomic,copy)NSString          *uid;
@property (nonatomic,copy)NSString          *city;
@property (nonatomic,copy)NSString          *stime_year;
@property (nonatomic,copy)NSString          *stime_month;

@property (nonatomic,assign)BOOL            isFirst;

@property (nonatomic,strong)NSMutableDictionary *conditionsDic;

@end

@implementation AuctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"拍卖";
    _catalogArray = [[NSMutableArray alloc]init];
    _authorArray = [[NSMutableArray alloc]init];
    _cityArray = [[NSMutableArray alloc]init];
    _conditionsDic = [[NSMutableDictionary alloc]init];
    
    _yearinteger = 0;
    _monthinteger = 0;
    
    _page = 1;
    _isMore = NO;
    _isretrievalView = NO;
    _isFirst = YES;
    [self CreatUI];
    [self loaddata];
    // Do any additional setup after loading the view.
}

- (void)CreatUI{
    
    _headView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, headheight)];
    _headView.backgroundColor = White_Color;
    [self.view addSubview:_headView];
    
    _label = [Allview Withstring:@"全部" Withcolor:Blue_color Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentCenter];
    _label.frame = CGRectMake(headheight+10, 0, UI_SCREEN_WIDTH - 80, headheight);
    [_headView addSubview:_label];
    
    _button = [[UIButton alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH - 40, 0, 30, 30)];
    [_button setImage:[UIImage imageNamed:@"icon_arrow_down"] forState:UIControlStateNormal];
    [_button addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_headView addSubview:_button];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT+32, UI_SCREEN_WIDTH, UI_SCREEN_SHOW - 32) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)loaddata{
    
    NSString *stringpage = [NSString stringWithFormat:@"%ld",(long)_page];
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    if (_isMore) {
        
        prams = [NSMutableDictionary dictionaryWithObjectsAndKeys:stringpage,@"page", nil];
        
    }else{
        
        prams = [NSMutableDictionary dictionaryWithObjectsAndKeys:stringpage,@"page", nil];
        NSArray *array = [_conditionsDic allKeys];
        [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [prams setValue:[_conditionsDic objectForKey:obj] forKey:obj];
        }];
    }
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_retrieve withParams:prams withSuccess:^(id responseObject) {
        if (_isMore) {
            
        }else{
            [_catalogArray removeAllObjects];
            
        }
        NSArray *dataarray = [[NSArray alloc]init];
        dataarray = [responseObject objectForKey:@"data"];
        if (ARRAY_NOT_EMPTY(dataarray)) {
            for (NSDictionary *dic in dataarray) {
                [_catalogArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
            }
        }
        
        if (_isFirst) {
            NSArray *author = [[NSArray alloc]init];
            author = [responseObject objectForKey:@"author"];
            
            NSArray *city = [[NSArray alloc]init];
            city = [responseObject objectForKey:@"city"];
            for (NSDictionary *dic in author) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_authorArray addObject:[Authordata WithAuthordataDic:dic]];
                }
            }
            for (NSDictionary *dic in city) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_cityArray addObject:[citydata WithcitydataDic:dic]];
                }
            }
            _isFirst = NO;

        }
        
        [_tableView reloadData];
        
    } withError:^(NSError *error) {
        
        
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _catalogArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cellantique";
    AntiqueCatalogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AntiqueCatalogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (ARRAY_NOT_EMPTY(_catalogArray)) {
        cell.antiquecatalogdata = _catalogArray[indexPath.row];
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
    return 0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    CatalogDetailsViewController *catalogVC = [[CatalogDetailsViewController alloc]init];
    AntiqueCatalogData *antiqueCatalogdata = _catalogArray[indexPath.row];
    catalogVC.ID = antiqueCatalogdata.ID;
    catalogVC.mfileName = antiqueCatalogdata.name;
    [self.navigationController pushViewController:catalogVC animated:YES];
}

- (void)btnClick:(UIButton *)button{
    
    if (_retrievalView == NULL) {
        _retrievalView = [RetrievalConditionView initWithauthor:_authorArray andWithcity:_cityArray];
        _retrievalView.delegate = self;
        _retrievalView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, (40+1)*3);
        [self.view addSubview:_retrievalView];
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_retrievalView.frame), UI_SCREEN_WIDTH, UI_SCREEN_SHOW-32);
        _isretrievalView = YES;
        
    }else{
        _retrievalView.hidden = NO;
        _retrievalView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, _retrievalView.frame.size.width, _retrievalView.frame.size.height);
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_retrievalView.frame), UI_SCREEN_WIDTH, UI_SCREEN_SHOW-32);
    }
    
}
#pragma mark-UIScrollViewDelegate
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView == _tableView) {
        if ((_tableView.contentOffset.y > 3.f) && (_isretrievalView = YES)) {
            _retrievalView.hidden = YES;
            [UIView animateWithDuration:0.3 animations:^{
                _tableView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT + headheight+2, UI_SCREEN_WIDTH, UI_SCREEN_SHOW-32);
            }];
            
            
        }
    }
}

#pragma mark - RetrievalConditionViewDelegate
- (void)hanstate:(NSInteger)integer{
    
    if (integer == 2) {
        
        if (_yearinteger == 0) {
            _retrievalView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, _retrievalView.frame.size.width, (40+1)*4);
            _tableView.frame = CGRectMake(0, CGRectGetMaxY(_retrievalView.frame), UI_SCREEN_WIDTH, UI_SCREEN_SHOW - 32);
        }else{
            _retrievalView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, _retrievalView.frame.size.width, (40+1)*5);
            _tableView.frame = CGRectMake(0, CGRectGetMaxY(_retrievalView.frame), UI_SCREEN_WIDTH, UI_SCREEN_SHOW - 32);
        }
        _v_status = @"1";
        [_conditionsDic setValue:_v_status forKey:@"v_status"];
        
        if (STRING_NOT_EMPTY(_stime_year)) {
            
            NSString *stime;
            NSString *ntime;
            if (STRING_NOT_EMPTY(_stime_month)) {
                if ([_stime_month isEqualToString:@"12"]) {
                    stime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",_stime_year,_stime_month];
                    NSInteger yearselect = [_stime_year integerValue] + 1;
                    ntime = [NSString stringWithFormat:@"%ld-01-01 00:00:00",(long)yearselect];
                    
                }else{
                    stime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",_stime_year,_stime_month];
                    NSInteger monthselect = [_stime_month integerValue] + 1;
                    ntime = [NSString stringWithFormat:@"%@-%ld-01 00:00:00",_stime_year,(long)monthselect];
                    
                    
                }
            }else{
                stime = [NSString stringWithFormat:@"%@-01-01 00:00:00",_stime_year];
                NSInteger yearselect = [_stime_year integerValue] + 1;
                ntime = [NSString stringWithFormat:@"%ld-01-01 00:00:00",(long)yearselect];
            }
            
            [_conditionsDic setValue:[UserModel toformateTime:stime] forKey:@"stime"];
            [_conditionsDic setValue:[UserModel toformateTime:ntime] forKey:@"ntime"];

            
        }else{
            NSArray *array = [_conditionsDic allKeys];
            for (NSObject *obj in array) {
                NSString *str = (NSString *)obj;
                if ([str isEqualToString:@"stime"] || [str isEqualToString:@"ntime"]) {
                    [_conditionsDic removeObjectForKey:@"stime"];
                    [_conditionsDic removeObjectForKey:@"ntime"];
                }
            }
        }
        
    }else{
        //得到词典中所有KEY值
        NSArray *array = [_conditionsDic allKeys];
        for (NSObject *obj in array) {
            NSString *str = (NSString *)obj;
            if ([str isEqualToString:@"v_status"]||[str isEqualToString:@"stime"] || [str isEqualToString:@"ntime"]) {
                [_conditionsDic removeObjectForKey:@"v_status"];
                [_conditionsDic removeObjectForKey:@"stime"];
                [_conditionsDic removeObjectForKey:@"ntime"];
            }
        }

        if (integer == 1) {
            _v_status = @"0";
            [_conditionsDic setValue:_v_status forKey:@"v_status"];
        }else{
            _v_status = @"";

        }
        _retrievalView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, _retrievalView.frame.size.width, (40+1)*3);
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_retrievalView.frame), UI_SCREEN_WIDTH, UI_SCREEN_SHOW);
        
    }
    [self hanloadData];

    
}
- (void)hanauthor:(id)obj{
    
    if ([obj isKindOfClass:[Authordata class]]) {
        Authordata *authordata = obj;
        _uid = authordata.uid;
        [_conditionsDic setValue:_uid forKey:@"uid"];
    }else{
        //得到词典中所有KEY值
//        NSEnumerator * enumeratorKey = [_conditionsDic keyEnumerator];
        NSArray *array = [_conditionsDic allKeys];
        for (NSObject *obj in array) {
            NSString *str = (NSString *)obj;
            if ([str isEqualToString:@"uid"]) {
                [_conditionsDic removeObjectForKey:@"uid"];
            }
        }
    }
    NSLog(@"%@",_conditionsDic);
    [self hanloadData];

    
}
- (void)hancity:(id)obj{
    
    if ([obj isKindOfClass:[citydata class]]) {
        citydata *cityData = obj;
        _city = cityData.area_id;
        [_conditionsDic setValue:_city forKey:@"city"];
    }else{
        //得到词典中所有KEY值
        NSArray *array = [_conditionsDic allKeys];

        for (NSObject *obj in array) {
            NSString *str = (NSString *)obj;
            if ([str isEqualToString:@"city"]) {
                [_conditionsDic removeObjectForKey:@"city"];
            }
        }
    }
    [self hanloadData];


}
- (void)hanyear:(NSString *)obj andint:(NSInteger)integer{
    
    _yearinteger = integer;
    
    if (_yearinteger == 0) {
        
        _stime_year = @"";
        _retrievalView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, _retrievalView.frame.size.width, (40+1)*4);
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_retrievalView.frame), UI_SCREEN_WIDTH, UI_SCREEN_SHOW - 32);
        NSArray *array = [_conditionsDic allKeys];
        for (NSObject *obj in array) {
            NSString *str = (NSString *)obj;
            if ([str isEqualToString:@"stime"] || [str isEqualToString:@"ntime"]) {
                [_conditionsDic removeObjectForKey:@"stime"];
                [_conditionsDic removeObjectForKey:@"ntime"];
            }
        }
        
    }else{
        
        _stime_year = obj;
        _retrievalView.frame = CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, _retrievalView.frame.size.width, (40+1)*5);
        _tableView.frame = CGRectMake(0, CGRectGetMaxY(_retrievalView.frame), UI_SCREEN_WIDTH, UI_SCREEN_SHOW-32);
        
        NSString *stime;
        NSString *ntime;
        if (STRING_NOT_EMPTY(_stime_month)) {
            if ([_stime_month isEqualToString:@"12"]) {
                stime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",_stime_year,_stime_month];
                NSInteger yearselect = [_stime_year integerValue] + 1;
                ntime = [NSString stringWithFormat:@"%ld-01-01 00:00:00",(long)yearselect];
                
            }else{
                stime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",_stime_year,_stime_month];
                NSInteger monthselect = [_stime_month integerValue] + 1;
                ntime = [NSString stringWithFormat:@"%@-%ld-01 00:00:00",_stime_year,(long)monthselect];
                
                
            }
        }else{
            stime = [NSString stringWithFormat:@"%@-01-01 00:00:00",_stime_year];
            NSInteger yearselect = [_stime_year integerValue] + 1;
            ntime = [NSString stringWithFormat:@"%ld-01-01 00:00:00",(long)yearselect];
        }
        
        [_conditionsDic setValue:[UserModel toformateTime:stime] forKey:@"stime"];
        [_conditionsDic setValue:[UserModel toformateTime:ntime] forKey:@"ntime"];
        

    }
    [self hanloadData];

    
    
}
- (void)hanmonth:(NSString *)obj andint:(NSInteger)integer{
    
    NSString *stime;
    NSString *ntime;
    if (integer == 0) {
        _stime_month = @"";
        stime = [NSString stringWithFormat:@"%@-01-01 00:00:00",_stime_year];
        NSInteger yearselect = [_stime_year integerValue] + 1;
        ntime = [NSString stringWithFormat:@"%ld-01-01 00:00:00",(long)yearselect];
        
    }else{
        _stime_month = obj;
        if ([_stime_month isEqualToString:@"12"]) {
            stime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",_stime_year,_stime_month];
            NSInteger yearselect = [_stime_year integerValue] + 1;
            ntime = [NSString stringWithFormat:@"%ld-01-01 00:00:00",(long)yearselect];
            
        }else{
            stime = [NSString stringWithFormat:@"%@-%@-01 00:00:00",_stime_year,_stime_month];
            NSInteger monthselect = [_stime_month integerValue] + 1;
            ntime = [NSString stringWithFormat:@"%@-%ld-01 00:00:00",_stime_year,(long)monthselect];
            
            
        }
        
    }
    [_conditionsDic setValue:[UserModel toformateTime:stime] forKey:@"stime"];
    [_conditionsDic setValue:[UserModel toformateTime:ntime] forKey:@"ntime"];

    [self hanloadData];
    
}

- (void)hanloadData{
    _isMore = NO;
    [self loaddata];
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
