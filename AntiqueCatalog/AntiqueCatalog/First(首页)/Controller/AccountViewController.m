//
//  AccountViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/13.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "AccountViewController.h"
//#import "ModifyViewController.h"
#import "BindViewController.h"
#import "ResetPhoneViewController.h"
#import <ShareSDK/ShareSDK.h>

@interface AccountViewController ()
{
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    NSInteger _index;
}
@end

@implementation AccountViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        
        _dataArray = [NSMutableArray array];
        _index = 0;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(phoneBindSuccessful:) name:@"PHONEBINDSUCCESSFUL" object:nil];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"PHONEBINDSUCCESSFUL" object:nil];
}

- (void)phoneBindSuccessful:(NSNotification *)notification
{
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
    [dic setObject:@"1" forKey:@"isBind"];
    [_dataArray replaceObjectAtIndex:_index withObject:dic];
    
    [_tableView reloadData];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"账号管理";
    
    _tableView = [[UITableView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _tableView.separatorColor = LINE_COLOR;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    [self loadNewData];
}

- (void)loadNewData
{
    [self showHudInView:self.view hint:@"加载中"];
    [Api requestWithMethod:@"GET" withPath:API_URL_Other_Bind withParams:nil withSuccess:^(id responseObject){
        NSLog(@"===%@",responseObject);
       
        if ([responseObject count])
        {
            BOOL isError = NO;
            
//            for (NSDictionary * dict in responseObject) {
                NSString * state = [NSString stringWithFormat:@"%@",responseObject[@"msg"]];
                if ([state isEqualToString:@"接口认证失败"]) {
                    isError = YES;
                }
//            }
            if (!isError) {
                [_dataArray addObjectsFromArray:responseObject];

            }
        }
        [self hideHud];
        [_tableView reloadData];
    } withError:^(NSError *error){
        [self showHudInView:self.view showHint:@"请检查网络设置"];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
//	if (section == 0)
//    {
//        return [_dataArray count];
//    }
    return [_dataArray count];

//    else
//    {
//        return 1;
//    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if (indexPath.section == 0)
//    {
        static NSString *identifier = @"cell";
        AccountTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (cell == NULL)
        {
            cell = [[AccountTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            cell.delegate = self;
        }
        
        [cell updateCellWithData:[_dataArray objectAtIndex:indexPath.row] andIndexPath:indexPath];
        
        return cell;
//    }
//    else
//    {
//        static NSString *identifier = @"cell2";
//        SystemSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//        if (cell == NULL)
//        {
//            cell = [[SystemSettingTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//        }
//        
//        [cell updateCellWithData:@{@"title": @"修改密码" ,@"type": @"jiantou"} andIndexPath:indexPath];
//        
//        return cell;
//    }
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
	return 12;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1)
    {        
//        ModifyViewController *modifyVC = [[ModifyViewController alloc] init];
//        [self.navigationController pushViewController:modifyVC animated:YES];
    }
}

#pragma mark - AccountTableViewCellDelegate
- (void)buttonClicked:(NSIndexPath *)indexPath
{
    //NSLog(@"第%d个button点击",indexPath.row);
    
    _index = indexPath.row;
    
    if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"phone"])
    {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"isBind"] intValue])
        {
//            [LPActionSheetView showInView:self.view title:@"确定解除绑定吗" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:@"确定" otherButtonTitles:nil tagNumber:1];
            ResetPhoneViewController *ResetPhoneVC = [[ResetPhoneViewController alloc] init];
            [self.navigationController pushViewController:ResetPhoneVC animated:YES];
        }
        else
        {
            
            
            BindViewController *bindVC = [[BindViewController alloc] init];
            [self.navigationController pushViewController:bindVC animated:YES];
        }
    }
    else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"qzone"])
    {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"isBind"] intValue])
        {
            [LPActionSheetView showInView:self.view title:@"确定解除绑定吗" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:@"确定" otherButtonTitles:nil tagNumber:2];
        }
        else
        {
            [ShareSDK getUserInfoWithType:ShareTypeQQSpace //平台类型
                              authOptions:nil //授权选项
                                   result:^(BOOL result, id userInfo, id error) { //返回回调
                                       if (result)
                                       {
                                           NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"qzone",@"type",[[ShareSDK getCredentialWithType:ShareTypeQQSpace] uid],@"type_uid",[[ShareSDK getCredentialWithType:ShareTypeQQSpace] token],@"access_token", nil];
                                           [Api requestWithMethod:@"get" withPath:API_URL_Other_Bind_Other withParams:param withSuccess:^(id responseObject) {
                                               //NSLog(@"param2= %@====%@",param,responseObject);
                                               if ([[responseObject objectForKey:@"status"] intValue])
                                               {
                                                   [self showHudInView:self.view showHint:@"绑定成功"];
                                                   NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
                                                   [dic setObject:@"1" forKey:@"isBind"];
                                                   [_dataArray replaceObjectAtIndex:_index withObject:dic];
                                                   
                                                   [_tableView reloadData];
                                               }
                                               else
                                               {
                                                   [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                                               }
                                           }withError:^(NSError *error) {
                                               [self hideHud];
                                               [self showHudInView:self.view showHint:@"请检查网络设置"];
                                           }];
                                       }
                                       else
                                       {
                                           NSLog(@"授权失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                       }
                                   }];
        }
    }
    else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"weixin"])
    {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"isBind"] intValue])
        {
            [LPActionSheetView showInView:self.view title:@"确定解除绑定吗" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:@"确定" otherButtonTitles:nil tagNumber:3];
        }
        else
        {
            [ShareSDK getUserInfoWithType:ShareTypeWeixiSession //平台类型
                              authOptions:nil //授权选项
                                   result:^(BOOL result, id userInfo, id error) { //返回回调
                                       if (result)
                                       {
                                           NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"type",[[ShareSDK getCredentialWithType:ShareTypeWeixiSession] uid],@"type_uid",[[ShareSDK getCredentialWithType:ShareTypeWeixiSession] token],@"access_token", nil];
                                           NSLog(@"%@",param);
                                           [Api requestWithMethod:@"get" withPath:API_URL_Other_Bind_Other withParams:param withSuccess:^(id responseObject) {
                                               NSLog(@"param2= %@====%@",param,responseObject);
                                               if ([[responseObject objectForKey:@"status"] intValue])
                                               {
                                                   [self showHudInView:self.view showHint:@"绑定成功"];
                                                   NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
                                                   [dic setObject:@"1" forKey:@"isBind"];
                                                   [_dataArray replaceObjectAtIndex:_index withObject:dic];
                                                   
                                                   [_tableView reloadData];
                                               }
                                               else
                                               {
                                                   [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                                               }
                                           }withError:^(NSError *error) {
                                               [self hideHud];
                                               [self showHudInView:self.view showHint:@"请检查网络设置"];
                                           }];
                                       }
                                       else
                                       {
                                           NSLog(@"授权失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                       }
                                   }];
        }
    }
    else if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"type"] isEqualToString:@"sina"])
    {
        if ([[[_dataArray objectAtIndex:indexPath.row] objectForKey:@"isBind"] intValue])
        {
            [LPActionSheetView showInView:self.view title:@"确定解除绑定吗" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:@"确定" otherButtonTitles:nil tagNumber:4];
        }
        else
        {
            [ShareSDK getUserInfoWithType:ShareTypeSinaWeibo //平台类型
                              authOptions:nil //授权选项
                                   result:^(BOOL result, id userInfo, id error) { //返回回调
                                       if (result)
                                       {
                                           NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"sina",@"type",[[ShareSDK getCredentialWithType:ShareTypeSinaWeibo] uid],@"type_uid",[[ShareSDK getCredentialWithType:ShareTypeSinaWeibo] token],@"access_token", nil];
                                           [Api requestWithMethod:@"get" withPath:API_URL_Other_Bind_Other withParams:param withSuccess:^(id responseObject) {
                                               NSLog(@"param2= %@====%@",param,responseObject);
                                               if ([[responseObject objectForKey:@"status"] intValue])
                                               {
                                                   [self showHudInView:self.view showHint:@"绑定成功"];
                                                   NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
                                                   [dic setObject:@"1" forKey:@"isBind"];
                                                   [_dataArray replaceObjectAtIndex:_index withObject:dic];
                                                   
                                                   [_tableView reloadData];
                                               }
                                               else
                                               {
                                                   [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                                               }
                                           }withError:^(NSError *error) {
                                               [self hideHud];
                                               [self showHudInView:self.view showHint:@"请检查网络设置"];
                                           }];
                                       }
                                       else
                                       {
                                           NSLog(@"授权失败,错误码:%ld,错误描述:%@", (long)[error errorCode], [error errorDescription]);
                                       }
                                   }];
        }
    }
}

#pragma mark - LPActionSheetViewDelegate
- (void)actionSheetClickedOnDestructiveButton:(LPActionSheetView *)actionSheetView
{
    switch (actionSheetView.tag)
    {
        case 1:
        {
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:@"phone",@"type", nil];
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                [self showHudInView:self.view hint:@"解绑中..."];
                [Api requestWithMethod:@"GET" withPath:API_URL_User_UNPhone withParams:params withSuccess:^(id responseObject){
                    if ([[responseObject objectForKey:@"status"] intValue] == 1)
                    {
                        [self hideHud];
                        [self showHudInView:self.view showHint:@"解绑成功"];
                        
                        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
                        [dic setObject:@"0" forKey:@"isBind"];
                        [_dataArray replaceObjectAtIndex:_index withObject:dic];
                    }
                    else
                    {
                        [self hideHud];
                        [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                    }
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [_tableView reloadData];
                    });
                } withError:^(NSError *error){
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"请检查网络设置"];
                }];
            });
        }
            break;
        case 2:
        {
            [ShareSDK cancelAuthWithType:ShareTypeQQSpace]; //取消授权,下次使用的时候需要跳转到应用重新授权
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"qzone",@"type", nil];
            [self showHudInView:self.view hint:@"解绑中..."];
            [Api requestWithMethod:@"get" withPath:API_URL_Other_UNBind withParams:param withSuccess:^(id responseObject) {
                //NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"status"] intValue])
                {
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"解绑成功"];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
                    [dic setObject:@"0" forKey:@"isBind"];
                    [_dataArray replaceObjectAtIndex:_index withObject:dic];
                    
                    [_tableView reloadData];
                }
                else
                {
                    [self hideHud];
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
            } withError:^(NSError *error) {
                [self hideHud];
                [self showHudInView:self.view showHint:@"操作失败"];
            }];
        }
            break;
        case 3:
        {
            [ShareSDK cancelAuthWithType:ShareTypeWeixiSession]; //取消授权,下次使用的时候需要跳转到应用重新授权
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"weixin",@"type", nil];
            [self showHudInView:self.view hint:@"解绑中..."];
            [Api requestWithMethod:@"get" withPath:API_URL_Other_UNBind withParams:param withSuccess:^(id responseObject) {
                //NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"status"] intValue])
                {
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"解绑成功"];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
                    [dic setObject:@"0" forKey:@"isBind"];
                    [_dataArray replaceObjectAtIndex:_index withObject:dic];
                    
                    [_tableView reloadData];
                }
                else
                {
                    [self hideHud];
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
            } withError:^(NSError *error) {
                [self hideHud];
                [self showHudInView:self.view showHint:@"操作失败"];
            }];
        }
            break;
        case 4:
        {
            [ShareSDK cancelAuthWithType:ShareTypeSinaWeibo]; //取消授权,下次使用的时候需要跳转到应用重新授权
            NSDictionary *param = [NSDictionary dictionaryWithObjectsAndKeys:@"sina",@"type", nil];
            [self showHudInView:self.view hint:@"解绑中..."];
            [Api requestWithMethod:@"get" withPath:API_URL_Other_UNBind withParams:param withSuccess:^(id responseObject) {
                //NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"status"] intValue])
                {
                    [self hideHud];
                    [self showHudInView:self.view showHint:@"解绑成功"];
                    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:[_dataArray objectAtIndex:_index]];
                    [dic setObject:@"0" forKey:@"isBind"];
                    [_dataArray replaceObjectAtIndex:_index withObject:dic];
                    
                    [_tableView reloadData];
                }
                else
                {
                    [self hideHud];
                    [self showHudInView:self.view showHint:[responseObject objectForKey:@"msg"]];
                }
            } withError:^(NSError *error) {
                [self hideHud];
                [self showHudInView:self.view showHint:@"操作失败"];
            }];
        }
            break;
            
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
