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

- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(downList:) name:@"AddDownList" object:nil];
    }
    return self;
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:@"AddDownList" object:nil];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.titleLabel.text = @"下载列表";
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
        if (DIC_NOT_EMPTY(tempDict)) {
            [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:tempDict]];

        }

    }
    [_tableView reloadData];
    [db close];
    
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
        [db open];
        FMResultSet * tempRs = [Api queryResultSetWithWithDatabase:db AndTable:DOWNTABLE_NAME AndWhereName:DOWNFILEID AndValue:cataData.ID];
        
        if ([tempRs next]) {
            NSString * stateStr = [tempRs objectForColumnName:DOWNFILE_TYPE];
            NSString * progress = [tempRs objectForColumnName:DOWNFILE_Progress];
            if (STRING_NOT_EMPTY(progress)) {
                cell.downProsseLabel.text = progress;

            }
            if ([stateStr isEqualToString:@"1"]) {
//                cell.downProsseLabel.text = @"100%";
                cell.downStatelabel.text = @"下载完成";
                cell.downBtn.hidden = YES;
            }else if([stateStr isEqualToString:@"0"]){
//                cell.downProsseLabel.text = @"0.00%";
                cell.downStatelabel.text = @"等待下载";
                cell.downBtn.hidden = NO;
                [cell.downBtn setTitle:@"等待" forState:UIControlStateNormal];
            }else if ([stateStr isEqualToString:@"2"]){
//                cell.downProsseLabel.text = @"0.00%";
                cell.downStatelabel.text = @"正在下载";
                cell.downBtn.hidden = NO;
                [cell.downBtn setTitle:@"暂停" forState:UIControlStateNormal];
            }else if ([stateStr isEqualToString:@"3"]){
                //                cell.downProsseLabel.text = @"0.00%";
                cell.downStatelabel.text = @"正在下载";
                cell.downBtn.hidden = NO;
                [cell.downBtn setTitle:@"暂停" forState:UIControlStateNormal];
            }
        }
        [db close];

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
    NSLog(@"ddddddddddd通知 通知＝＝＝＝＝:%@",obj.userInfo);
//    NSDictionary * dict = (NSDictionary*)obj.userInfo;
//    [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:dict]];
//    [self.tableView reloadData];
//    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[[myOp.userInfo objectForKey:@"keyOp"] intValue] inSection:0];
    NSDictionary * userDict = obj.userInfo;
    if (DIC_NOT_EMPTY(userDict)) {
        NSString * fileId = [NSString stringWithFormat:@"%@",userDict[@"FiledId"]];
        for (int i = 0; i < _antiqueCatalogDataArray.count; i ++) {
            AntiqueCatalogData * antiqueCatalogdata  = _antiqueCatalogDataArray[i];
            if ([fileId isEqualToString: antiqueCatalogdata.ID]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
//                DownListViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
//                cell.downProsseLabel.text = [NSString stringWithFormat:@"%@",userDict[@"ProgreValue"]];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }

        }
   
    }
   

    
}

@end
