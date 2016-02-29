//
//  CatalogGetListViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/18.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "CatalogGetListViewController.h"
#import "CatalogGetList.h"
#import "CatalogListTableViewCell.h"

@interface CatalogGetListViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray  *listArray;
@property (nonatomic,strong)CatalogGetList  *cataloglist;
@property (nonatomic,strong)NSMutableArray  *cataloglistArray;
@property (nonatomic,strong)NSMutableArray  *cataloglistCellArray;

@end

@implementation CatalogGetListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"目录";
    
    _cataloglistArray = [[NSMutableArray alloc]init];
    _cataloglistCellArray = [[NSMutableArray alloc]init];
    
    [self CreatUI];
    [self loaddata];
    // Do any additional setup after loading the view.
}

- (void)CreatUI{
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
}

- (void)loaddata{
    
    NSDictionary *prams = [NSDictionary dictionary];
    prams = @{@"id":_ID};
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getList withParams:prams withSuccess:^(id responseObject) {
        
        if (ARRAY_NOT_EMPTY([responseObject objectForKey:@"list"])) {
            _cataloglist = [CatalogGetList WithCatalogGetListDic:responseObject];
            for (NSDictionary *dic in _cataloglist.list) {
                [_cataloglistArray addObject:dic];
                CatalogListTableViewCell *catalistCell = [[CatalogListTableViewCell alloc]init];
                [_cataloglistCellArray addObject:catalistCell];
            }
            [_tableView reloadData];
        }
        
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
    return _cataloglistArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cellantique";
    CatalogListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[CatalogListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    [cell initWithdic:[_cataloglistArray objectAtIndex:indexPath.row] andWithcataloggetlist:_cataloglist andWithIndexPath:indexPath];
    
    
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogListTableViewCell *catalogCell = _cataloglistCellArray[indexPath.row];
    [catalogCell initWithdic:[_cataloglistArray objectAtIndex:indexPath.row] andWithcataloggetlist:_cataloglist andWithIndexPath:indexPath];
    
    return catalogCell.height;
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
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
