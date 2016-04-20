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
    FMDatabase *db;

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
    db = [Api initTheFMDatabase];
    [db open];
    FMResultSet * resOne = [Api  queryTableIALLDatabase:db AndTableName:DOWNTABLE_NAME];

    self.catalogArray = [NSMutableArray array];
    _antiqueCatalogDataArray = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    while([resOne next]){
        NSString* infoData =[resOne objectForColumnName:ALLINFOData];
        NSDictionary * dict = [Api dictionaryWithJsonString:infoData];
        NSDictionary * tempDict = dict[@"catalog"];
        [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:tempDict]];

    }
    [_tableView reloadData];

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
        AntiqueCatalogData * cataData = _antiqueCatalogDataArray[indexPath.row];
        FMResultSet * tempRs = [Api queryResultSetWithWithDatabase:db AndTable:DOWNTABLE_NAME AndWhereName:DOWNFILEID AndValue:cataData.ID];
        if ([tempRs next]) {
            NSString * stateStr = [tempRs objectForColumnName:DOWNFILE_TYPE];
            if ([stateStr isEqualToString:@"1"]) {
                cell.downProsseLabel.text = @"100%";
                cell.downStatelabel.text = @"下载完成";
                cell.downBtn.hidden = YES;
            }else if([stateStr isEqualToString:@"0"]){
                cell.downProsseLabel.text = @"0.00%";
                cell.downStatelabel.text = @"等待下载";
                cell.downBtn.hidden = NO;
                [cell.downBtn setTitle:@"等待" forState:UIControlStateNormal];
            }else if ([stateStr isEqualToString:@"2"]){
                cell.downProsseLabel.text = @"0.00%";
                cell.downStatelabel.text = @"正在下载";
                cell.downBtn.hidden = NO;
                [cell.downBtn setTitle:@"暂停" forState:UIControlStateNormal];
            }
        }

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
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[myOp.userInfo objectForKey:@"keyOp"] intValue] inSection:0];

    
}

@end
