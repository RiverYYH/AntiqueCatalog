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

@interface DownViewController ()<UITableViewDataSource,UITableViewDelegate,UIAlertViewDelegate>{
    FMDatabase *db;
    NSInteger row;
}
@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray *antiqueCatalogDataArray;
//@property (nonatomic,strong)NSMutableArray *dataArray;

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
//    self.catalogArray = [NSMutableArray array];

    _antiqueCatalogDataArray = [[NSMutableArray alloc]init];
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    while([resOne next]){
//        NSString* infoData =[resOne objectForColumnName:ALLINFOData];
        NSString * filedName = [resOne objectForColumnName:DOWNFILE_NAME];
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [paths objectAtIndex:0];    //初始化临时文件路径
        NSString *folderPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@",filedName]];
        NSString * filedPath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",filedName]];
        
        NSFileManager* fm = [NSFileManager defaultManager];
        NSData* data = [[NSData alloc] init];
        data = [fm contentsAtPath:filedPath];
//        NSLog(@"%@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
        
        NSString *fileStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSDictionary * dict = [Api dictionaryWithJsonString:fileStr];
        NSDictionary * tempDict = dict[@"catalog"];
        
        if (DIC_NOT_EMPTY(tempDict)) {
            [_antiqueCatalogDataArray addObject:[AntiqueCatalogData WithTypeListDataDic:tempDict]];
            [self.catalogArray addObject:dict];

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
    [cell.deletBtn addTarget:self action:@selector(deletBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.deletBtn.tag = indexPath.row;
    [cell.downBtn addTarget:self action:@selector(downBtnButtonClick:) forControlEvents:UIControlEventTouchUpInside];

    if (ARRAY_NOT_EMPTY(_antiqueCatalogDataArray)) {
        cell.antiquecatalogdata = _antiqueCatalogDataArray[indexPath.row];
        NSDictionary * cellDict = self.catalogArray[indexPath.row];
        AntiqueCatalogData * cataData = _antiqueCatalogDataArray[indexPath.row];
        objc_setAssociatedObject(cell.downBtn, "firstObject", cataData, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        objc_setAssociatedObject(cell.downBtn, "secondObject", cellDict, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

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
                cell.downBtn.tag = 1009;

            }else if ([stateStr isEqualToString:@"2"]){
//                cell.downProsseLabel.text = @"0.00%";
                cell.downStatelabel.text = @"正在下载";
                cell.downBtn.hidden = NO;
                [cell.downBtn setTitle:@"继续" forState:UIControlStateNormal];
                cell.downBtn.tag = 1000;
                
            }else if ([stateStr isEqualToString:@"3"]){
                //                cell.downProsseLabel.text = @"0.00%";
                cell.downStatelabel.text = @"正在下载";
                cell.downBtn.hidden = NO;
                [cell.downBtn setTitle:@"暂停" forState:UIControlStateNormal];
                cell.downBtn.tag = 1010;
            }
        }
        [db close];

    }
    cell.downBtn.hidden = YES;

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
    catalogVC.mfileName = antiqueCatalogdata.name;

    [self.navigationController pushViewController:catalogVC animated:YES];
    
}


#pragma mak-- 
-(void)downList:(NSNotification *)obj{
    NSLog(@"ddddddddddd通知 通知＝＝＝＝＝:%@",obj.userInfo);
    NSDictionary * userDict = obj.userInfo;
    if (DIC_NOT_EMPTY(userDict)) {
        NSString * fileId = [NSString stringWithFormat:@"%@",userDict[@"FiledId"]];
        for (int i = 0; i < _antiqueCatalogDataArray.count; i ++) {
            AntiqueCatalogData * antiqueCatalogdata  = _antiqueCatalogDataArray[i];
            if ([fileId isEqualToString: antiqueCatalogdata.ID]) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:i inSection:0];
                [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
                break;
            }

        }
   
    }
   

    
}

-(void)downBtnButtonClick:(id)sender{
    UIButton * button = (UIButton*)sender;
     AntiqueCatalogData * cataData  = objc_getAssociatedObject(button, "firstObject");
    NSDictionary * cellDict = objc_getAssociatedObject(button, "secondObject");

    NSLog(@"dddddddddd:%@  %@",cataData.ID,cataData.name);
    NSString * fileId = [NSString stringWithFormat:@"%@",cataData.ID];
    NSString * fileName = [NSString stringWithFormat:@"%@",cataData.name];
    NSArray * listArray = cellDict[@"list"];
    NSMutableDictionary * userDict = [NSMutableDictionary dictionary];
    userDict[@"fileId"] = [NSString stringWithFormat:@"%@",fileId];
    userDict[@"fileName"] = [NSString stringWithFormat:@"%@",fileName];
    userDict[@"list"] = listArray;
    
    if (button.tag == 1009) {
//        [button]
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GODOWN" object:self userInfo:userDict];

       button.tag = 1010;
        
    }else if (button.tag == 1010){
        [button setTitle:@"继续" forState:UIControlStateNormal];
        button.tag = 1000;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"STOPDOWN" object:self userInfo:userDict];
        
    }else if (button.tag == 1000){
        [button setTitle:@"暂停" forState:UIControlStateNormal];
        button.tag = 1010;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"GODOWN" object:self userInfo:userDict];

    }
    
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    switch (buttonIndex) {
        case 0:
        {
        
        }
            break;
        case 1:
        {
            AntiqueCatalogData * cataData = _antiqueCatalogDataArray[row];
            [db open];
            NSString * tableImageName = [NSString stringWithFormat:@"%@_%@",DOWNFILEIMAGE_NAME,cataData.ID];
            NSString *sqlstr = [NSString stringWithFormat:@"DROP TABLE %@", tableImageName];
            BOOL res = [db executeUpdate:sqlstr];

            if (res)
            {
                NSLog(@"删除该图录图片表成功");

            }
            
            FMResultSet * tempRs = [Api queryResultSetWithWithDatabase:db AndTable:DOWNTABLE_NAME AndWhereName:DOWNFILEID AndValue:cataData.ID];
            if ([tempRs next]) {
                NSString *deleteSql = [NSString stringWithFormat:
                                       @"delete from %@ where %@ = '%@'",
                                       DOWNTABLE_NAME, DOWNFILEID, cataData.ID];
                
                BOOL res = [db executeUpdate:deleteSql];
                
                if (!res) {
                    NSLog(@"error when insert db table");
                } else {
                    NSLog(@"success to insert db table");
                }
            }
           
            [db close];
            
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [paths objectAtIndex:0];    //初始化临时文件路径
            NSString *folderPath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"DownLoad/%@_%@",cataData.ID,cataData.name]];
            //创建文件管理器
            NSFileManager *fileManager = [NSFileManager defaultManager];
            //判断temp文件夹是否存在
            BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
            if (fileExists) {
                //
                NSError *err;
                [fileManager removeItemAtPath:folderPath error:&err];
            }
            [_antiqueCatalogDataArray removeObjectAtIndex:row];
            [self.tableView reloadData];
        
        }
            break;
        default:
            break;
    }
}

-(void)deletBtnButtonClick:(id)sender{
    UIButton * deletBtn = (UIButton*)sender;
    row = deletBtn.tag;
    UIAlertView * altView =[[UIAlertView alloc] initWithTitle:@"删除下载" message:@"确定从本地删除该图录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [altView show];
    
    

}

@end
