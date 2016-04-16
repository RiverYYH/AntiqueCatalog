//
//  FllowViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "FllowViewController.h"
#import "Followeringdata.h"
#import "FolloweringTableViewCell.h"
#import "UserSpaceViewController.h"
#import "AddFllowViewController.h"
@interface FllowViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView    *tableVeiw;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)BOOL           isMore;


@end

@implementation FllowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"关注列表";
    
    _dataArray = [[NSMutableArray alloc]init];
    _isMore = NO;
    [self CreatUI];
    [self.rightButton setTitle:@"+" forState:UIControlStateNormal];
    [self.rightButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loaddata];
}

-(void)rightButtonClick:(id)sender
{
    AddFllowViewController * page = [[AddFllowViewController alloc] init];
    [self.navigationController pushViewController:page animated:YES];
}

- (void)loaddata{
    
    NSDictionary *prams = [NSDictionary dictionary];
    if (_isMore) {
        
        prams = @{@"max_id":@"1",@"user_id":@""};
    }else{
        
        prams = @{@"max_id":@"0",@"user_id":@""};
    }
    [Api showLoadMessage:@"正在加载"];
    if(_dataArray){
        _dataArray = nil;
    }
    _dataArray = [NSMutableArray array];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER_Followering withParams:prams withSuccess:^(id responseObject) {
        [Api hideLoadHUD];
        if (ARRAY_NOT_EMPTY(responseObject)) {
            
            for (NSDictionary *dic in responseObject) {
                [_dataArray addObject:[Followeringdata WithFolloweringdataDic:dic]];
            }
            
            [_tableVeiw reloadData];
        }
        
    } withError:^(NSError *error) {
        [Api hideLoadHUD];
    }];
    
}

- (void)CreatUI{
    
    _tableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableVeiw.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableVeiw.separatorColor = Clear_Color;
    _tableVeiw.backgroundColor = White_Color;
    _tableVeiw.delegate = self;
    _tableVeiw.dataSource = self;
    [self.view addSubview:_tableVeiw];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *identifier = @"cellUp";
    FolloweringTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[FolloweringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.followeringdata = _dataArray[indexPath.row];
    return cell;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 73.0f;
    
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
    UserSpaceViewController *userspaceVC = [[UserSpaceViewController alloc]init];
    Followeringdata *follower = _dataArray[indexPath.row];
    userspaceVC.uid = follower.uid;
    [self.navigationController pushViewController:userspaceVC animated:YES];
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
