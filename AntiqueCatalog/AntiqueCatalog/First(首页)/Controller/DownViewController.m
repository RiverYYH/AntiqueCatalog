//
//  DownViewController.m
//  AntiqueCatalog
//
//  Created by yangyonghe on 16/4/16.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "DownViewController.h"
#import "CatalogDetailsViewController.h"
#import "AntiqueCatalogViewCell.h"
#import "DownListViewCell.h"

@interface DownViewController ()<UITableViewDataSource,UITableViewDelegate>{
    
}
@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray *antiqueCatalogDataArray;

@end

@implementation DownViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downList:) name:@"AddDownList" object:nil];

}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AddDownList" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.catalogArray = [NSMutableArray array];
    _antiqueCatalogDataArray = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:self.dataDict]];


    // Do any additional setup after loading the view.



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
    DownListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[DownListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
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
    return 161.0f;
    
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
    
    [self.navigationController pushViewController:catalogVC animated:YES];
}


#pragma mak-- 
-(void)downList:(NSNotification *)obj{
    NSLog(@"ddddddddddd:%@",obj.userInfo);
//    NSDictionary * dict = (NSDictionary*)obj.userInfo;
//    [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:dict]];
//    [self.tableView reloadData];

    
}

@end
