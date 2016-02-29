//
//  FootprintViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/26.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "FootprintViewController.h"
#import "FootCatalogdata.h"
#import "FootprintTableViewCell.h"
#import "CatalogDetailsViewController.h"

@interface FootprintViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray  *catalogArray;
@property (nonatomic,assign)BOOL            isMore;

@end

@implementation FootprintViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _catalogArray = [[NSMutableArray alloc]init];
    
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [self loaddata];
    
    // Do any additional setup after loading the view.
}

- (void)loaddata
{
    NSDictionary *prams = [NSDictionary dictionary];
    if (_isMore) {
        prams = @{@"max_id":@"1"};
    }else{
        
        prams = @{@"max_id":@"0"};
    }
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getUserRead withParams:prams withSuccess:^(id responseObject) {
        NSArray *array = [[NSArray alloc]init];
        array = responseObject;
        if (ARRAY_NOT_EMPTY(array)) {
            for (NSDictionary *dic in array) {
                
                [_catalogArray addObject:[FootCatalogdata WithTypeListDataDic:dic]];
            }
            [_tableView reloadData];
            //            NSLog(@"%@",_antiqueCatalogDataArray);
        }else{
            
        }
        
        
        
    } withError:^(NSError *error) {
        
        NSLog(@"失败 %@",error);
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
    FootprintTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FootprintTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    return 171.0f;
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
    FootCatalogdata *antiqueCatalogdata = _catalogArray[indexPath.row];
    catalogVC.ID = antiqueCatalogdata.ID;
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
