//
//  PostTopicListViewController.m
//  藏民网
//
//  Created by Hong on 15/4/7.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import "PostTopicListViewController.h"
#import "Api.h"
#import "TopicListTableViewCell.h"
#import "PostTopicListTableViewCell.h"
#import "TopicDetailViewController.h"
#import "PostWeiBoViewController.h"
#import "MJAutoGifFooter.h"
#import "MJDIYGifHeader.h"
#import "UIViewController+HUD.h"

@interface PostTopicListViewController ()
{
    UISearchBar *_searchBar;
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    NSString *_searchKeyString;
    
    
    
    BOOL _isMore;
    NSInteger _page;
    BOOL _isExist;//判断专辑是否存在
}
@end

@implementation PostTopicListViewController
- (id)init
{
    self = [super init];
    if(self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cancelBtnClicked) name:@"NewTopicCreatedNext" object:nil];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.hidden = YES;
    _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 20, UI_SCREEN_WIDTH-10-50, 40)];
    _searchBar.placeholder = @"创建或加入专辑";
    _searchBar.searchBarStyle = 2;
    _searchBar.barTintColor = [UIColor whiteColor];
    _searchBar.backgroundColor = [UIColor clearColor];
    _searchBar.delegate = self;
    [self.view addSubview:_searchBar];
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(UI_SCREEN_WIDTH-50, 20, 40, 40);
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClicked) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:cancelBtn];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-70) style:UITableViewStylePlain];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.separatorColor = LINE_COLOR;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    _tableView.header = [MJDIYGifHeader headerWithRefreshingBlock:^{
        _isMore = NO;
        _page = 1;
        [self loadNewData];
    }];
    _tableView.footer = [MJAutoGifFooter footerWithRefreshingBlock:^{
        _isMore = YES;
        _page ++;
        [self loadNewData];
    }];
    
    _isMore = NO;
    _isExist = NO;
    _searchKeyString = @" ";
    _page = 1;
    [_searchBar becomeFirstResponder];
    [self loadNewData];
    // Do any additional setup after loading the view.
}
//取消按钮
- (void)cancelBtnClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
- (void)loadNewData
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if(_isMore) {
        if(ARRAY_NOT_EMPTY(_dataArray)) {
            params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_searchKeyString,@"k", [NSString stringWithFormat:@"%ld",_page], @"page",nil];
        } else {
            [self stopRefresh];
            return;
        }
    } else {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_searchKeyString,@"k", [NSString stringWithFormat:@"%ld",_page],@"page", nil];
    }

    [self showHudInView:self.view hint:@"加载中..."];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Api requestWithMethod:@"GET" withPath:API_URL_TOPICSEARCH withParams:params withSuccess:^(id responseObject) {
            if(!_isMore) {
                if(ARRAY_NOT_EMPTY(_dataArray)) {
                    [_dataArray removeAllObjects];
                }
                if (STRING_NOT_EMPTY(_searchKeyString)) {
                    if([[responseObject objectForKey:@"exactmatch"] intValue]) {
                        _isExist = YES;
                    } else {
                        _isExist = NO;
                    }
                }
                [_dataArray addObjectsFromArray:[responseObject objectForKey:@"topics"]];
            } else {
                if(ARRAY_NOT_EMPTY([responseObject objectForKey:@"topics"])) {
                    [_dataArray addObjectsFromArray:[responseObject objectForKey:@"topics"]];
                } else {
                    [self stopRefresh];
                    _isMore = NO;
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"没有更多了"];
                    return ;
                }
            }
            [self stopRefresh];
            _isMore = NO;
            [self hideHud];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
                
            });
        } withError:^(NSError *error) {
            [self stopRefresh];
            _isMore = NO;
            [self hideHud];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    });
}
#pragma mark - MKRefreshView delegate

- (void)stopRefresh
{
    [_tableView.header endRefreshing];
    [_tableView.footer endRefreshing];
}
- (void)dealloc
{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"NewTopicCreatedNext" object:nil];
}
#pragma mark - search delegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _searchKeyString = searchText;
    [Api endClient];
    [_tableView reloadData];
    [self hideHud];
    [self loadNewData];
}
#pragma mark - tableview datasource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0) {
        if(STRING_NOT_EMPTY(_searchKeyString)) {
            if(_isExist) {
                return 0;
            } else {
                return 1;
            }
        } else {
            return 0;
        }
    } else {
        return _dataArray.count;
    }
}
#pragma mark - tableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.2;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.2;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section == 0) {
        if(!_isExist){
            if(_type == 1) {
                if(_delegate && [_delegate respondsToSelector:@selector(PostTopicListViewWithTopicName:)]) {
                    [_delegate PostTopicListViewWithTopicName:_searchKeyString];
                }
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                PostWeiBoViewController *postWVC = [[PostWeiBoViewController alloc] initWithNibName:nil bundle:nil andPlaceText:nil];
                postWVC.topicName = _searchKeyString;
                UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postWVC];
                [self presentViewController:nav animated:YES completion:nil];
            }
        }
    } else {
        if (_type == 1) {
            if(_delegate && [_delegate respondsToSelector:@selector(PostTopicListViewWithTopicName:)]) {
                [_delegate PostTopicListViewWithTopicName:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"topic_name"]];
            }
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            PostWeiBoViewController *postWVC = [[PostWeiBoViewController alloc] initWithNibName:nil bundle:nil andPlaceText:nil];
            postWVC.topicName = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"topic_name"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:postWVC];
            [self presentViewController:nav animated:YES completion:nil];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIde = @"cell";
    PostTopicListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIde];
    if(cell == nil) {
        cell = [[PostTopicListTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIde];
    }
    if(indexPath.section == 0) {
        if(STRING_NOT_EMPTY(_searchKeyString)) {
            NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:_searchKeyString,@"topic_name",@"点击这里创建您的专辑",@"des",@"",@"pic",@"",@"view_count", nil];
            [cell updateCellWithData:dic andIndexPath:indexPath];
        }
    } else {
        [cell updateCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
    }
    return cell;
}
#pragma mark - scrollview delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_searchBar resignFirstResponder];
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
