//
//  ClassficationDailView.m
//  AntiqueCatalog
//
//  Created by cssweb on 16/4/6.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ClassficationDailView.h"
#import "CatalogCategorydata.h"
#import "AntiqueCatalogData.h"
#import "AntiqueCatalogViewCell.h"
#import "CatalogDetailsViewController.h"
#import "MJRefresh.h"

@interface ClassficationDailView ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) UITableView * dailTableView;

@property (nonatomic,strong) NSMutableArray * dataArray;
@property (nonatomic,assign)BOOL             isMore;

@end

@implementation ClassficationDailView
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
    // Do any additional setup after loading the view.
    self.dataArray = [NSMutableArray array];
    UILabel * label = [[UILabel alloc] initWithFrame:CGRectMake(10, UI_NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, 40)];
    label.text = @"全部";
    [self.view addSubview:label];
    _isMore = NO;
    self.dailTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, label.frame.origin.y + label.frame.size.height, self.view.bounds.size.width, UI_SCREEN_HEIGHT - (label.frame.origin.y + label.frame.size.height))];
    
    self.dailTableView.delegate = self;
    self.dailTableView.dataSource = self;
    [self.view addSubview:self.dailTableView];
    [self loadgetCategoryCatalog];
    
    __unsafe_unretained UITableView *tableView = _dailTableView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //        NSLog(@"rrrrrrrrrrrrrrrrrrr");
//        [self.titleDataArray removeAllObjects];
        [self loadTitleWith:tableView];
        
    }];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",self.dataDict[@"title"]];

}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
}

-(void)loadTitleWith:(UITableView*)tableView{
    if (self.dataArray.count) {
        [self.dataArray removeAllObjects];
    }
    NSDictionary *prams = [NSDictionary dictionary];
    //    CatalogCategorydata *catalog = _catalogcategoryarray[_tabbarInteger];
    if (_isMore) {
        
        prams = @{@"id":[NSString stringWithFormat:@"%@",self.dataDict[@"id"]],@"max_id":@"1"};
    }else{
        
        prams = @{@"id":[NSString stringWithFormat:@"%@",self.dataDict[@"id"]],@"max_id":@"0"};
    }
    
    
//    [Api showLoadMessage:@"加载数据中"];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getCategoryCatalog withParams:prams withSuccess:^(id responseObject) {
        [tableView.mj_header endRefreshing];

//        [Api hideLoadHUD];
        //        NSMutableArray *dataArray = [_allDataArray objectAtIndex:_tabbarInteger];
        for (NSDictionary *dic in responseObject) {
            [self.dataArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
        }
        [self.dailTableView reloadData];
        
        
        
    } withError:^(NSError *error) {
        [tableView.mj_header endRefreshing];
    }];

}

- (void)loadgetCategoryCatalog
{
    NSDictionary *prams = [NSDictionary dictionary];
//    CatalogCategorydata *catalog = _catalogcategoryarray[_tabbarInteger];
    if (_isMore) {
        
        prams = @{@"id":[NSString stringWithFormat:@"%@",self.dataDict[@"id"]],@"max_id":@"1"};
    }else{
        
        prams = @{@"id":[NSString stringWithFormat:@"%@",self.dataDict[@"id"]],@"max_id":@"0"};
    }
    
    
    [Api showLoadMessage:@"加载数据中"];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getCategoryCatalog withParams:prams withSuccess:^(id responseObject) {
        [Api hideLoadHUD];
//        NSMutableArray *dataArray = [_allDataArray objectAtIndex:_tabbarInteger];
        for (NSDictionary *dic in responseObject) {
            [self.dataArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
        }
        [self.dailTableView reloadData];
        
//        [_allDataArray replaceObjectAtIndex:_tabbarInteger withObject:dataArray];
//        [[_tableViewArray objectAtIndex:_tabbarInteger] reloadData];
        
        
    } withError:^(NSError *error) {
        [Api hideLoadHUD];
    }];
    

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

#pragma mark UITableViewDelegate and UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.dataArray.count;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *identifier = @"cellUp";
    AntiqueCatalogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AntiqueCatalogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (ARRAY_NOT_EMPTY(self.dataArray)) {
        cell.antiquecatalogdata = self.dataArray[indexPath.row];
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
//    NSMutableArray *array = [[NSMutableArray alloc]init];
//    array = [_allDataArray objectAtIndex:_tabbarInteger];
//    NSDictionary *dict = [self.dataArray objectAtIndex:indexPath.row];
//    NSLog(@"dddddddddd:%@",dict);
    CatalogDetailsViewController *catalogVC = [[CatalogDetailsViewController alloc]init];
    AntiqueCatalogData *antiqueCatalogdata = [self.dataArray objectAtIndex:indexPath.row];;
    catalogVC.ID = antiqueCatalogdata.ID;
    [self.navigationController pushViewController:catalogVC animated:YES];
    
}



@end
