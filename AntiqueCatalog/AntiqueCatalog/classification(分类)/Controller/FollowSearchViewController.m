//
//  FollowSearchViewController.m
//  AntiqueCatalog
//
//  Created by CssWeb on 16/4/15.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "FollowSearchViewController.h"
#import "AddFolloweringTableViewCell.h"
#import "AddFolloweringdata.h"
#import "UserSpaceViewController.h"
@interface FollowSearchViewController ()<UISearchBarDelegate,AddFoloweringTableViewCellDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong)NSMutableArray   *catalogcategoryarray;

@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray  *catalogArray;//结果集数组

@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,copy)NSString      *seatchBarstring;

@end

@implementation FollowSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.rightButton setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,-10)];
    
    _catalogArray = [[NSMutableArray alloc]init];
    _catalogcategoryarray = [[NSMutableArray alloc]init];
    
    [self CreatUI];

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(_seatchBarstring){
        self.catalogArray = nil;
        [self.tableView reloadData];
        [Api showLoadMessage:@"正在加载"];
        [self loaddata];
    }
}

- (void)rightButtonClick:(id)sender{
    [_searchBar resignFirstResponder];
    if (STRING_NOT_EMPTY(_seatchBarstring)) {
        [Api showLoadMessage:@"正在加载"];
        [self loaddata];
    }
}

- (void)CreatUI{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(44, 20, UI_SCREEN_WIDTH - 44 - 44 , 44)];
    [self.titleImageView addSubview:_searchBar];
    [_searchBar setPlaceholder:@"搜索图录"];// 搜索框的占位符
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    //[_searchBar becomeFirstResponder];
    //    去掉搜索框的背景视图
    for (UIView *view in _searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 4;
            view.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
            view.layer.borderWidth = 1.0;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            //            break;
        }
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            //            NSLog(@"%d",view.subviews.count);
            UIView *view1 = [view.subviews objectAtIndex:0];
            view1.layer.masksToBounds = YES;
            view1.layer.cornerRadius = 4;
            view1.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
            view1.layer.borderWidth = 1.0;
        }
    }
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _seatchBarstring = searchText;
    if (!STRING_NOT_EMPTY(_seatchBarstring)) {
        self.rightButton.hidden = NO;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [_searchBar resignFirstResponder];
    if (STRING_NOT_EMPTY(_seatchBarstring)) {
        [Api showLoadMessage:@"正在加载"];
        [self loaddata];
    }
}

- (void)loaddata{
    
    NSMutableDictionary *prams = [NSMutableDictionary dictionary];
    prams[@"key"] = _seatchBarstring;
    prams[@"max_id"] = @"0";
    prams[@"count"] = @"20";
    
    self.catalogArray = [NSMutableArray array];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_UserSearch withParams:prams withSuccess:^(id responseObject) {
        [Api hideLoadHUD];
        for (NSDictionary *dic in responseObject) {
            [self.catalogArray addObject:[AddFolloweringdata WithFolloweringdataDic:dic]];
        }
        [self.tableView reloadData];
        
    } withError:^(NSError *error) {
        [Api hideLoadHUD];
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
    
    static NSString *identifier = @"cellUp";
    AddFolloweringTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[AddFolloweringTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.followeringdata = self.catalogArray[indexPath.row];
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
    UserSpaceViewController *userspaceVC = [[UserSpaceViewController alloc]init];
    AddFolloweringdata * follower = self.catalogArray[indexPath.row];
    userspaceVC.uid = follower.uid;
    [self.navigationController pushViewController:userspaceVC animated:YES];
}

-(void)didClickFollowButtonWithData:(NSString *)uid{
    NSMutableDictionary *prams = [NSMutableDictionary dictionary];
    prams[@"user_id"] = uid;
    [Api showLoadMessage:@"正在处理"];
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER_Follow withParams:prams withSuccess:^(id responseObject) {
        NSLog(@"%@",responseObject[@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            self.catalogArray = nil;
            [self loaddata];
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

@end
