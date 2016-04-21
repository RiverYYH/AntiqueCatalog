//
//  ClassificationViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ClassificationViewController.h"
#import "TabbarScrollView.h"
#import "CatalogCategorydata.h"
#import "AntiqueCatalogData.h"
#import "AntiqueCatalogViewCell.h"
#import "CatalogDetailsViewController.h"

#define tabbarViewheight 32

@interface ClassificationViewController ()<UIScrollViewDelegate,UITableViewDataSource,UITableViewDelegate,TabbarScrollViewDelegate>

@property (nonatomic,strong)NSMutableArray   *catalogcategoryarray;

@property (nonatomic,strong)TabbarScrollView *tabbarView;
@property (nonatomic,strong)UIScrollView     *scrollView;
@property (nonatomic,strong)UITableView      *tableVeiw;
@property (nonatomic,strong)NSMutableArray   *tableViewArray;
@property (nonatomic,strong)NSMutableArray   *allDataArray;//存储图录数据的总数组

@property (nonatomic,assign)NSInteger        tabbarInteger;
@property (nonatomic,assign)BOOL             isMore;

@property (strong,nonatomic) NSMutableArray * saveDidLoadPageArray;
@end

@implementation ClassificationViewController

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"分类";
    
    _catalogcategoryarray = [[NSMutableArray alloc]init];
    _tableViewArray = [[NSMutableArray alloc]init];
    _allDataArray = [[NSMutableArray alloc]init];
    
    self.saveDidLoadPageArray = [NSMutableArray array];
    _tabbarInteger = 0;
    _isMore = NO;

    [self loadtitle];
}

- (void)loadtitle{
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getCatalogCategory withParams:nil withSuccess:^(id responseObject) {
        
        if (ARRAY_NOT_EMPTY(responseObject)) {
            for (NSDictionary *dic in responseObject) {
                CatalogCategorydata *catalogcategory = [CatalogCategorydata WithCatalogCategoryDataDic:dic];
                [_catalogcategoryarray addObject:catalogcategory];
            }
            [self CreatUI];
 
        }
        
    } withError:^(NSError *error) {
        
    }];
    
}

- (void)CreatUI{
    _tabbarView = [[TabbarScrollView alloc]initWithheight:tabbarViewheight andWitharray:_catalogcategoryarray];
    _tabbarView.Tabbardelegate = self;
    [self.view addSubview:_tabbarView];
    
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT+tabbarViewheight, UI_SCREEN_WIDTH, UI_SCREEN_SHOW - tabbarViewheight)];
    _scrollView.contentSize = CGSizeMake(UI_SCREEN_WIDTH*_catalogcategoryarray.count, 0);
    _scrollView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.scrollEnabled = YES;
    _scrollView.delegate = self;
    _scrollView.tag = 1000;
    [self.view addSubview:_scrollView];
    
    [_catalogcategoryarray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        _tableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(idx*UI_SCREEN_WIDTH, 0, UI_SCREEN_WIDTH, UI_SCREEN_SHOW - tabbarViewheight) style:UITableViewStyleGrouped];
        _tableVeiw.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
        _tableVeiw.separatorColor = Clear_Color;
        _tableVeiw.backgroundColor = White_Color;
        _tableVeiw.delegate = self;
        _tableVeiw.dataSource = self;
        [_tableViewArray addObject:_tableVeiw];
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        [_allDataArray addObject:array];
        
        [_scrollView addSubview:_tableVeiw];
        
    }];

    [self loadgetCategoryCatalog];
    
}

- (void)loadgetCategoryCatalog
{
    NSDictionary *prams = [NSDictionary dictionary];
    CatalogCategorydata *catalog = _catalogcategoryarray[_tabbarInteger];
    if (_isMore) {
        
        prams = @{@"id":catalog.ID,@"max_id":@"1"};
    }else{
        
        prams = @{@"id":catalog.ID,@"max_id":@"0"};
    }
    [Api showLoadMessage:@"加载数据中"];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getCategoryCatalog withParams:prams withSuccess:^(id responseObject) {
        [Api hideLoadHUD];
        NSMutableArray *dataArray = [_allDataArray objectAtIndex:_tabbarInteger];
        for (NSDictionary *dic in responseObject) {
            [dataArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
        }
        [_allDataArray replaceObjectAtIndex:_tabbarInteger withObject:dataArray];
        [[_tableViewArray objectAtIndex:_tabbarInteger] reloadData];
    } withError:^(NSError *error) {
        [Api hideLoadHUD];
    }];
    
    NSString * tbbarIndexStr = [NSString stringWithFormat:@"%ld",(long)_tabbarInteger];
    [self.saveDidLoadPageArray addObject:tbbarIndexStr];
}

#pragma mark - TabbarScrollViewDelegate
-(void)hanTabbarIndexPath:(NSInteger)indexPath{
    
    _tabbarInteger = indexPath;
    _scrollView.contentOffset = CGPointMake(indexPath*UI_SCREEN_WIDTH, 0);
    /*
    if (!ARRAY_NOT_EMPTY([_allDataArray objectAtIndex:_tabbarInteger])) {
        [self loadgetCategoryCatalog];
    }
    */
    BOOL flag = NO;
    for(NSString * str in self.saveDidLoadPageArray){
        NSInteger tbbar_index = [str integerValue];
        if(tbbar_index == _tabbarInteger){
            flag = YES;
            break;
        }
    }
    if(flag == NO){
        [self loadgetCategoryCatalog];
    }

}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView.tag == 1000) {
        [_tabbarView btnClickByScrollWithIndex:_scrollView.contentOffset.x/UI_SCREEN_WIDTH];
        _tabbarInteger = _scrollView.contentOffset.x/UI_SCREEN_WIDTH;
//        if (!ARRAY_NOT_EMPTY([_allDataArray objectAtIndex:_tabbarInteger])) {
//            [self loadgetCategoryCatalog];
//        }
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *array = [_allDataArray objectAtIndex:_tabbarInteger];
    return array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [_allDataArray objectAtIndex:_tabbarInteger];
    static NSString *identifier = @"cellUp";
    AntiqueCatalogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AntiqueCatalogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (ARRAY_NOT_EMPTY(array)) {
        cell.antiquecatalogdata = array[indexPath.row];
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
    return 1.0f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    array = [_allDataArray objectAtIndex:_tabbarInteger];
    CatalogDetailsViewController *catalogVC = [[CatalogDetailsViewController alloc]init];
    AntiqueCatalogData *antiqueCatalogdata = array[indexPath.row];
    catalogVC.ID = antiqueCatalogdata.ID;
    catalogVC.mfileName = antiqueCatalogdata.name;

    [self.navigationController pushViewController:catalogVC animated:YES];
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
