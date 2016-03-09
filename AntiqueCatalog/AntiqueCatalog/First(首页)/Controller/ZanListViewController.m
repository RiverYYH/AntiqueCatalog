//
//  ZanListViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/12/25.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "ZanListViewController.h"
#import "UIViewController+HUD.h"


@interface ZanListViewController ()
{
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    
    NSString *_feedID;
    ZanType _zanType;
    
    BOOL _isMore;
}
@end

@implementation ZanListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil andFeedID:(NSString *)feedID andType:(ZanType)zanType
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _feedID = feedID;
        _zanType = zanType;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"赞列表";
    
    _dataArray = [NSMutableArray array];
    
    _tableView = [[UITableView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _tableView.separatorColor = LINE_COLOR;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self loadNewData];
    _isMore = NO;
    
    _tableView.header = [MJDIYGifHeader headerWithRefreshingBlock:^{
        _isMore = NO;
        [self loadNewData];
    }];
    _tableView.footer = [MJAutoGifFooter footerWithRefreshingBlock:^{
        _isMore = YES;
        [self loadNewData];
    }];
}

#pragma mark - MJRefreshBaseViewDelegate

-(void)stopRefreshing
{
	[_tableView.header endRefreshing];
	[_tableView.footer endRefreshing];
}
- (void)dealloc
{
    
}

- (void)loadNewData
{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    if (_isMore)
    {
        if (ARRAY_NOT_EMPTY(_dataArray))
        {
            switch (_zanType)
            {
                case ZanTypeNormal:
                {
                    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedID,@"feed_id",[[_dataArray objectAtIndex:[_dataArray count]-1] objectForKey:@"id"],@"max_id",@"10",@"count",nil];
                }
                    break;
                case ZanTypeCircle:
                {
                    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedID,@"post_id",[[_dataArray objectAtIndex:[_dataArray count]-1] objectForKey:@"id"],@"max_id",@"10",@"count",nil];
                }
                    break;
                case ZanTypeKnowledge:
                {
                    params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedID,@"id",[[_dataArray objectAtIndex:[_dataArray count]-1] objectForKey:@"id"],@"max_id",@"10",@"count",nil];
                }
                    break;
                default:
                    break;
            }
        }
        else
        {
            [self stopRefreshing];
            return;
        }
    }
    else
    {
        switch (_zanType)
        {
            case ZanTypeNormal:
            {
                params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedID,@"feed_id",@"",@"max_id",@"10",@"count",nil];
            }
                break;
            case ZanTypeCircle:
            {
                params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedID,@"post_id",@"",@"max_id",@"10",@"count",nil];
            }
                break;
            case ZanTypeKnowledge:
            {
                params = [NSMutableDictionary dictionaryWithObjectsAndKeys:_feedID,@"id",@"",@"max_id",@"10",@"count",nil];
            }
                break;
            default:
                break;
        }
    }
    
    NSString *path = [NSString string];
    switch (_zanType)
    {
        case ZanTypeNormal:
        {
            path = API_URL_ZANLIST;
        }
            break;
        case ZanTypeCircle:
        {
            path = API_URL_Weiba_ZanList;
        }
            break;
        case ZanTypeKnowledge:
        {
            path = API_URL_Knowledge_ZanList;
        }
            break;
        default:
            break;
    }
    [self showHudInView:self.view hint:@"加载中"];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Api requestWithMethod:@"GET" withPath:path withParams:params withSuccess:^(id responseObject){
            NSLog(@"%@",responseObject);
            if (!_isMore)
            {
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
                    [self stopRefreshing];
                    _isMore = NO;
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"没有更多了"];
                    return;
                }
            }
            [self stopRefreshing];
            _isMore = NO;
            [_tableView reloadData];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self hideHud];
            });
        } withError:^(NSError *error){
            [self stopRefreshing];
            _isMore = NO;
            [self hideHud];
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    });
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_dataArray count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    UserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (cell == NULL)
    {
        cell = [[UserTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.delegate = self;
    }
    
    [cell updateCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath andUserCellType:UserCellTypeNormal];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UserTableViewCell heightForCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.1;
}

#pragma mark - UserTableViewCellDelegate
- (void)attentionButtonClicked:(NSIndexPath *)indexPath
{
//    NSLog(@"%d",indexPath.row);
    [LPActionSheetView showInView:self.view title:[[[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"follow_status"] objectForKey:@"following"] intValue]==1?@"确定取消关注吗？":@"确定关注吗？" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:@"确定" otherButtonTitles:nil tagNumber:indexPath.row];
}
-(void)showUserProfileByName:(NSString *)name
{
//    NewUserInformationViewController *userInformationVC = [[NewUserInformationViewController alloc] init];
//    userInformationVC.uname = name;
//    [self.navigationController pushViewController:userInformationVC animated:YES];
}
#pragma mark - LPActionSheetViewDelegate
- (void)actionSheetClickedOnDestructiveButton:(LPActionSheetView *)actionSheetView
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:[[_dataArray objectAtIndex:actionSheetView.tag] objectForKey:@"uid"],@"user_id",nil];
        [Api requestWithMethod:@"GET" withPath:[[[[_dataArray objectAtIndex:actionSheetView.tag] objectForKey:@"follow_status"] objectForKey:@"following"] intValue]==1?API_URL_USER_UNFollow:API_URL_USER_Follow withParams:params withSuccess:^(id responseObject){
            NSLog(@"%@",responseObject);
            if ([[responseObject objectForKey:@"status"] intValue] == 1)
            {
                NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:actionSheetView.tag]];
                NSMutableDictionary *dicc = [NSMutableDictionary dictionaryWithDictionary:[dic objectForKey:@"follow_status"]];
                [dicc setObject:[responseObject objectForKey:@"following"] forKey:@"following"];
                [dic setObject:dicc forKey:@"follow_status"];
                [_dataArray replaceObjectAtIndex:actionSheetView.tag withObject:dic];
                
                [[NSNotificationCenter defaultCenter] postNotificationName:@"MeStatusChanged" object:self userInfo:nil];
            }
            else
            {
                [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [_tableView reloadData];
            });
        } withError:^(NSError *error){
            [self showHudInView:self.view showHint:@"请检查网络设置"];
        }];
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
