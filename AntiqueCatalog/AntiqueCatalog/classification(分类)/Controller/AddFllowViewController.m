//
//  AddFllowViewController.m
//  AntiqueCatalog
//
//  Created by CssWeb on 16/4/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "AddFllowViewController.h"
#import "AddFolloweringdata.h"
#import "AddFolloweringTableViewCell.h"
#import "MJRefresh.h"

#import "FollowSearchViewController.h"
@interface AddFllowViewController ()<UITableViewDataSource,UITableViewDelegate, AddFoloweringTableViewCellDelegate>
@property (nonatomic,strong)UITableView    * tableVeiw;
@property (nonatomic,strong)NSMutableArray * dataArray;
@property (nonatomic,strong)NSMutableArray * type1Array;
@property (nonatomic,strong)NSMutableArray * type2Array;
@property (nonatomic,strong)NSMutableArray * type3Array;
@property (nonatomic,strong)UILabel * flagLabel;

@property (nonatomic,strong)NSString * currType; //当前所选的类别(推荐？拍卖？艺术)
@end

@implementation AddFllowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"艺术独家号";
    [self CreatUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear: animated];
    
    //如果没有所选列表标签值 代表第一次进入本页面，设默认值1
    if(!self.currType){
        self.currType = @"1";
    }else{
        //如果所选列表标签值有值 代表从后续页面返回回来，根据不同的值重置相应的结果集
        if([self.currType isEqualToString:@"1"]){
            self.type1Array = nil;
        }else if ([self.currType isEqualToString:@"2"]){
            self.type2Array = nil;
        }else if ([self.currType isEqualToString:@"3"]){
            self.type3Array = nil;
        }else{
            [self showHudInView:self.view showHint:@"当前没有所选列表"];
        }
    }
    [Api showLoadMessage:@"正在加载"];
    [self loadDataWithType:self.currType];
    
}

-(void)CreatUI{
    UIButton * leftButton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"推荐" Withcolor:Blue_color WithSelectcolor:Blue_color Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
    leftButton.tag = 101;
    [leftButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * centerButton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"拍卖" Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
    centerButton.tag = 102;
    [centerButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * rightButton = [Allview WithlineBreak:1 WithcontentVerticalAlignment:UIControlContentVerticalAlignmentCenter WithString:@"艺术" Withcolor:Deputy_Colour WithSelectcolor:Blue_color Withfont:Nav_title_font WithBgcolor:Clear_Color WithcornerRadius:0 Withbold:YES];
    rightButton.tag = 103;
    [rightButton addTarget:self action:@selector(typeButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    float eve = UI_SCREEN_WIDTH / 3;
    [leftButton setFrame:CGRectMake(0, 0, eve, 50)];
    [centerButton setFrame:CGRectMake(eve, 0, eve, 50)];
    [rightButton setFrame:CGRectMake(eve*2, 0, eve, 50)];
    
    UIView * topView = [[UIView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, 50)];
    topView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    [topView addSubview:leftButton];
    [topView addSubview:centerButton];
    [topView addSubview:rightButton];
    
    self.flagLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 45, eve, 4)];
    self.flagLabel.backgroundColor = Blue_color;
    [topView addSubview:self.flagLabel];
    
    [self.view addSubview:topView];
    
    [self.rightButton setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    
    _tableVeiw = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT+50, UI_SCREEN_WIDTH, UI_SCREEN_SHOW - 50) style:UITableViewStyleGrouped];
    _tableVeiw.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableVeiw.separatorColor = Clear_Color;
    _tableVeiw.backgroundColor = White_Color;
    _tableVeiw.delegate = self;
    _tableVeiw.dataSource = self;
    [self.view addSubview:_tableVeiw];
    [self setupRefresh];


}

-(void)typeButtonClick:(UIButton*)sender{
    for(int i=101;i<104;i++){
        if(sender.tag == i){
            [sender setTitleColor:Blue_color forState:UIControlStateNormal];
        }else{
            UIButton *btn = [self.view viewWithTag:i];
            [btn setTitleColor:Deputy_Colour forState:UIControlStateNormal];
        }
    }
    if(sender.frame.origin.x != self.flagLabel.frame.origin.x){
        [UIView animateWithDuration:0.1 animations:^{
            CGRect rect = self.flagLabel.frame;
            rect.origin.x = sender.frame.origin.x;
            self.flagLabel.frame = rect;
        }];
    }
    if(sender.tag == 101){
        self.currType = @"1";
        if(self.type1Array){
            self.dataArray = [NSMutableArray arrayWithArray:self.type1Array];
            [self.tableVeiw reloadData];
        }else{
            [Api showLoadMessage:@"正在加载"];
            [self loadDataWithType:@"1"];
        }
    }
    if(sender.tag == 102){
        self.currType = @"2";
        if(self.type2Array){
            self.dataArray = [NSMutableArray arrayWithArray:self.type2Array];
            [self.tableVeiw reloadData];
        }else{
            [Api showLoadMessage:@"正在加载"];
            [self loadDataWithType:@"2"];
        }
    }
    if(sender.tag == 103){
        self.currType = @"3";
        if(self.type3Array){
            self.dataArray = [NSMutableArray arrayWithArray:self.type3Array];
            [self.tableVeiw reloadData];
        }else{
            [Api showLoadMessage:@"正在加载"];
            [self loadDataWithType:@"3"];
        }
    }

    
}
-(void)rightButtonClick:(id)sender{
    NSLog(@"-------search");
    FollowSearchViewController * page = [FollowSearchViewController alloc];
    [self.navigationController pushViewController:page animated:YES];
}

-(void)loadDataWithType:(NSString *)type{
    
    NSMutableArray * tempResultArray = [NSMutableArray array];
    NSDictionary *prams = [NSDictionary dictionary];
    prams = @{@"max_id":@"0",@"count":@"99",@"type":type};
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER_AddFolloering withParams:prams withSuccess:^(id responseObject) {
        [Api hideLoadHUD];
        if (ARRAY_NOT_EMPTY(responseObject)) {
            
            for (NSDictionary *dic in responseObject) {
                [tempResultArray addObject:[AddFolloweringdata WithFolloweringdataDic:dic]];
            }
            
            if([type isEqualToString:@"1"]){
                self.type1Array = [NSMutableArray arrayWithArray:tempResultArray];
                self.dataArray = self.type1Array;
            }
            if([type isEqualToString:@"2"]){
                self.type2Array = [NSMutableArray arrayWithArray:tempResultArray];
                self.dataArray = self.type2Array;
            }
            if([type isEqualToString:@"3"]){
                self.type3Array = [NSMutableArray arrayWithArray:tempResultArray];
                self.dataArray = self.type3Array;
            }
            [_tableVeiw reloadData];
        }
        
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

#pragma RefreshTableView 
-(void)setupRefresh{
    __unsafe_unretained UITableView *tableView = _tableVeiw;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self reloadTableViewDataWithTableview:tableView AndTypoe:self.typeStr];
    }];
}

-(void)reloadTableViewDataWithTableview:(UITableView *)tableView AndTypoe:(NSString*)type{
    NSMutableArray * tempResultArray = [NSMutableArray array];
    NSDictionary *prams = [NSDictionary dictionary];
    prams = @{@"max_id":@"0",@"count":@"99",@"type":type};
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER_AddFolloering withParams:prams withSuccess:^(id responseObject) {
        [Api hideLoadHUD];
        if (ARRAY_NOT_EMPTY(responseObject)) {
            
            for (NSDictionary *dic in responseObject) {
                [tempResultArray addObject:[AddFolloweringdata WithFolloweringdataDic:dic]];
            }
            
            if([type isEqualToString:@"1"]){
                self.type1Array = [NSMutableArray arrayWithArray:tempResultArray];
                self.dataArray = self.type1Array;
            }
            if([type isEqualToString:@"2"]){
                self.type2Array = [NSMutableArray arrayWithArray:tempResultArray];
                self.dataArray = self.type2Array;
            }
            if([type isEqualToString:@"3"]){
                self.type3Array = [NSMutableArray arrayWithArray:tempResultArray];
                self.dataArray = self.type3Array;
            }
            [tableView.mj_header endRefreshing];

            [_tableVeiw reloadData];
            
        }
        
    } withError:^(NSError *error) {
        [tableView.mj_header endRefreshing];

//        [Api hideLoadHUD];
    }];

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
    AddFolloweringTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AddFolloweringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.followeringdata = _dataArray[indexPath.row];
    cell.delegate = self;
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
//    UserSpaceViewController *userspaceVC = [[UserSpaceViewController alloc]init];
//    Followeringdata *follower = _dataArray[indexPath.row];
//    userspaceVC.uid = follower.uid;
//    [self.navigationController pushViewController:userspaceVC animated:YES];
}

-(void)didClickFollowButtonWithData:(NSString *)uid{
    NSMutableDictionary *prams = [NSMutableDictionary dictionary];
    prams[@"user_id"] = uid;
    [Api showLoadMessage:@"正在处理"];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER_Follow withParams:prams withSuccess:^(id responseObject) {
        
        NSLog(@"%@",responseObject[@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            
            if([self.currType isEqualToString:@"1"]){
                self.type1Array = nil;
            }else if ([self.currType isEqualToString:@"2"]){
                self.type2Array = nil;
            }else if ([self.currType isEqualToString:@"3"]){
                self.type3Array = nil;
            }else{
                [self showHudInView:self.view showHint:@"当前没有所选列表"];
            }
            [self loadDataWithType:self.currType];
            
        }
        
    } withError:^(NSError *error) {
        [Api hideLoadHUD];
        
    }];

}
@end
