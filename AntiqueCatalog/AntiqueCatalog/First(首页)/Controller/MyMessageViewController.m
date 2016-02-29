//
//  MyMessageViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/2/20.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "MyMessageViewController.h"
#import "NotificationTableViewCell.h"

@interface MyMessageViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)BOOL isMore;

@end

@implementation MyMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"我的消息";
    
    _dataArray = [NSMutableArray array];
    _isMore = NO;
    
    [self CreatUI];
    [self reloaddata];
    
}

- (void)CreatUI{
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.backgroundColor = White_Color;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)reloaddata{
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_isMore) {
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[[_dataArray lastObject] objectForKey:@"data"] objectForKey:@"list_id"],@"max_id",@"10",@"count",nil];
    }else{
        params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"",@"max_id",@"10",@"count",nil];
    }
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_NOTIFY withParams:params withSuccess:^(id responseObject) {
        if (!_isMore){
            if ([_dataArray count])
            {
                [_dataArray removeAllObjects];
            }
            [_dataArray addObjectsFromArray:responseObject];
        }
        else
        {
            if (ARRAY_NOT_EMPTY(responseObject))
            {
                [_dataArray addObjectsFromArray:responseObject];
            }
            else
            {
                return;
            }
        }
        _isMore = NO;
        [_tableView reloadData];
    } withError:^(NSError *error) {
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    NotificationTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == NULL)
    {
        cell = [[NotificationTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell updateCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
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
//    NotificationDetailViewController *notificationDetailVC = [[NotificationDetailViewController alloc] initWithNibName:nil bundle:nil andName:[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"name"] andContent:[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"title"]andTime:[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"data"] objectForKey:@"ctime"]];
//    [self.navigationController pushViewController:notificationDetailVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
