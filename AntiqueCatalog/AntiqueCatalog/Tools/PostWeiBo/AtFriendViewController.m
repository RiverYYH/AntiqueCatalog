//
//  AtFriendViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/25.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "AtFriendViewController.h"
#import "UserTableViewCell.h"
#import "MJDIYGifHeader.h"
#import "MJAutoGifFooter.h"
#import  "UIViewController+HUD.h"

@interface AtFriendViewController ()
{
	UITableView *_tableView;
	NSMutableArray *_dataArray;
	NSMutableArray *_searchArray;
	UISearchBar *_searchBar;
	BOOL _isSearch,_isLoadMore;
}
@end

@implementation AtFriendViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
	
	self.titleLabel.text = @"@联系人";
	
	_dataArray = [NSMutableArray array];
	_searchArray = [NSMutableArray array];
    _isSearch = NO;
    _isLoadMore = NO;
	
	_searchBar  = [[UISearchBar alloc] initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, 44)];
    _searchBar.delegate = self;
    _searchBar.tintColor = [UIColor colorWithRed:235/255.0 green:235/255.0 blue:235/255.0 alpha:1.0];
	_searchBar.placeholder = @"搜索                                                          ";
    [self.view addSubview:_searchBar];
	
	_tableView = [[UITableView alloc]initWithFrame:CGRectMake(0,UI_NAVIGATION_BAR_HEIGHT+44, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-44) style:UITableViewStylePlain];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _tableView.separatorColor = LINE_COLOR;
    _tableView.backgroundColor = [UIColor clearColor];
	_tableView.delegate = self;
	_tableView.dataSource = self;
	[self.view addSubview:_tableView];
	
	_tableView.footer = [MJAutoGifFooter footerWithRefreshingBlock:^{
        _isLoadMore = YES;
        [self loadNewData];
    }];
	
	[self loadNewData];
}

#pragma mark -- 刷新代理方法


-(void)dealloc
{
	
}

-(void)loadNewData
{
	NSDictionary *params = [NSDictionary dictionary];
	if (_isSearch)
    {
		[_searchBar setShowsCancelButton:NO animated:YES];
		if (_isLoadMore)
        {
            if ([_searchArray count])
            {
                params = [NSDictionary dictionaryWithObjectsAndKeys:_searchBar.text,@"key",[[_searchArray objectAtIndex:[_searchArray count]-1] objectForKey:@"uid"],@"max_id",@"10",@"count", nil];
            }
            else
            {
                [_tableView.footer endRefreshing];
                _isLoadMore = NO;
                return;
            }
		}
        else
        {
            if ([_searchArray count])
            {
                [_searchArray removeAllObjects];
            }
			params = [NSDictionary dictionaryWithObjectsAndKeys:_searchBar.text,@"key",@"10",@"count", nil];
		}
	}
    else
    {
		if (_isLoadMore)
        {
            if ([_dataArray count])
            {
                params = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"key",[[_dataArray objectAtIndex:[_dataArray count]-1] objectForKey:@"uid"],@"max_id",@"10",@"count", nil];
            }
            else
            {
                [_tableView.footer endRefreshing];
                _isLoadMore = NO;
                return;
            }
		}
        else
        {
			params = [NSDictionary dictionaryWithObjectsAndKeys:@"",@"key",@"10",@"count", nil];
		}
	}
    [self showHudInView:_tableView hint:@"查询中..."];
	[Api requestWithMethod:@"GET" withPath:API_URL_SEARCH_at withParams:params withSuccess:^(id responseObject) {
        //NSLog(@"%@",responseObject);
		if (_isSearch)
        {
			[_searchArray addObjectsFromArray:responseObject];
		}
        else
        {
			[_dataArray addObjectsFromArray:responseObject];
		}
		[_tableView reloadData];
		[_tableView.footer endRefreshing];
        _isLoadMore = NO;
		[self hideHud];
	} withError:^(NSError *error) {
		[_tableView.footer endRefreshing];
        _isLoadMore = NO;
		[self hideHud];
	}];
}

-(void)leftButtonClick:(id)sender
{
	[self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	if (_isSearch)
    {
		return [_searchArray count];
	}
	else
    {
        return [_dataArray count];
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	static NSString *identifier = @"cell";
	UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	if (cell == nil)
    {
		cell = [[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
	}
    
	if (_isSearch)
    {
        [cell updateCellWithData:[_searchArray objectAtIndex:indexPath.row] andIndexPath:indexPath andUserCellType:UserCellTypeUnion];
	}
    else
    {
		[cell updateCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath andUserCellType:UserCellTypeUnion];
	}
    
	return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_isSearch)
    {
        return [UserTableViewCell heightForCellWithData:[_searchArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
    }
    else
    {
        return [UserTableViewCell heightForCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
    }
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSString *topicName;
	if (_isSearch)
    {
		topicName = [[_searchArray objectAtIndex:indexPath.row] objectForKey:@"uname"];
	}
    else
    {
		topicName = [[_dataArray objectAtIndex:indexPath.row] objectForKey:@"uname"];
	}
    
	if (self.delegate && [self.delegate respondsToSelector:@selector(returnAtName:)])
    {
		[self.delegate returnAtName:topicName];
	}
	[self dismissViewControllerAnimated:YES completion:^{}];
}

#pragma mark - UISearchBarDelegate
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
	if (searchBar.text.length <= 0)
    {
		[_searchBar resignFirstResponder];
		_isSearch = NO;
		if ([_searchArray count])
        {
            [_searchArray removeAllObjects];
        }
		[_tableView reloadData];
	}
    else
    {
		_isSearch = YES;
	}
}
-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:YES animated:YES];
	for (UIView *v in searchBar.subviews)
	{
		if ([v isKindOfClass:[UIButton class]])
		{
			UIButton *btn = (UIButton *)v;
			[btn setTitle:@"取消" forState:UIControlStateNormal];
			[btn setTitleColor:[UIColor darkGrayColor] forState:0];
		}
	}
    return  YES;
}
-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [_searchBar resignFirstResponder];
	[self loadNewData];
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
	[searchBar setShowsCancelButton:NO animated:YES];
    [_searchBar resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
