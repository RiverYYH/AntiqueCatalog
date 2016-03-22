//
//  SettingViewController.m
//  AntiqueCatalog
//
//  Created by cssweb on 16/3/8.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "SettingViewController.h"
//#import "CustomTabBarViewController.h"
#import "UIViewController+HUD.h"
#import "PostWeiBoViewController.h"
#import "SDImageCache.h"
#import "UIImageView+AFNetworking.h"
#import "AboutViewController.h"
#import "FeedbackViewController.h"
#import "LoginViewController.h"
#import "AccountViewController.h"

@interface SettingViewController (){
    UITableView *_tableView;
    
    NSMutableArray *_dataArray;
    
    NSString *cacheCount;
    UIButton *bgBtn;
}


@end

@implementation SettingViewController
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.titleLabel.text = @"设置";
    cacheCount = @"";
    _dataArray = [NSMutableArray array];
    
//    [UIView animateWithDuration:0.3 animations:^{
//        [CustomTabBarViewController sharedInstance].imageView.frame = CGRectMake(0, UI_SCREEN_HEIGHT, UI_SCREEN_WIDTH, 49);
//    } completion:^(BOOL finished){
//        [CustomTabBarViewController sharedInstance].imageView.hidden = YES;
//    }];
    
    _tableView = [[UITableView alloc] initWithFrame:UI_MAIN_SCREEN_FRAME style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 12, 0, 12);
    _tableView.separatorColor = LINE_COLOR;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, 60)];
    _tableView.tableFooterView = footerView;
    
    bgBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    bgBtn.frame = CGRectMake(12, 10, UI_SCREEN_WIDTH-24, 40);
    bgBtn.backgroundColor = ICON_COLOR;
    [bgBtn addTarget:self action:@selector(cancelLogin) forControlEvents:UIControlEventTouchUpInside];
    if([UserModel checkLogin]){
        [bgBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        bgBtn.tag = 100;

    }else{
        [bgBtn setTitle:@"登录" forState:UIControlStateNormal];
        bgBtn.tag = 200;

    }
    [bgBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    bgBtn.titleLabel.font = [UIFont systemFontOfSize:17.0];
    bgBtn.layer.masksToBounds = YES;
    bgBtn.layer.cornerRadius = 3.0;
    bgBtn.userInteractionEnabled = YES;
    [footerView addSubview:bgBtn];
    
    NSArray *arr = @[@[@{@"title": @"账号管理",@"content": @"",@"type": @"jiantou"}],
                     @[@{@"title": @"清除缓存",@"content": cacheCount,@"type": @"label"}],
                     @[@{@"title": @"接收新消息提醒",@"content": @"",@"type": @"switch"}
                       ],
                     @[@{@"title": @"意见反馈",@"content": @"",@"type": @"jiantou"},
                       @{@"title": @"关于我们",@"content": @"",@"type": @"jiantou"}]];
    [_dataArray addObjectsFromArray:arr];
    [self loadSize];

}

-(void)loadSize
{
    float count = 0.0;
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath1  = [[path objectAtIndex:0] stringByAppendingPathComponent:@"Caches/ImageCache"];
    NSString *filePath4  = [[path objectAtIndex:0] stringByAppendingPathComponent:@"/Caches"];
    NSString *filePath3  = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
    NSString *filePath2  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"];
    NSString *filePath5  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    count += [self folderSizeAtPath:filePath1];
    count += [self folderSizeAtPath:filePath4];
    count += [self folderSizeAtPath:filePath2];
    count += [self folderSizeAtPath:filePath3];
    count += [self folderSizeAtPath:filePath5];
    
    cacheCount = [NSString stringWithFormat:@"%.2fM",count+[[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0)];
    //    NSLog(@"%.2f",count+[[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0));
    double cleardata = count+[[SDImageCache sharedImageCache] getSize]/(1024.0*1024.0);
    if (cleardata > 500) {
        [self autoCleardata];
    }else{
        NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[_dataArray objectAtIndex:1]];
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:0]];
        [dic setObject:cacheCount forKey:@"content"];
        [arr replaceObjectAtIndex:0 withObject:dic];
        [_dataArray replaceObjectAtIndex:1 withObject:arr];
        [_tableView reloadData];
        
    }
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    if([UserModel checkLogin]){
        [bgBtn setTitle:@"退出登录" forState:UIControlStateNormal];
        bgBtn.tag = 100;
        
    }else{
        [bgBtn setTitle:@"登录" forState:UIControlStateNormal];
        bgBtn.tag = 200;
        
    }
}

//单个文件的大小
- (long long) fileSizeAtPath:(NSString*) filePath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if ([manager fileExistsAtPath:filePath])
    {
        return [[manager attributesOfItemAtPath:filePath error:nil] fileSize];
    }
    return 0;
}
//遍历文件夹获得文件夹大小，返回多少M
- (float ) folderSizeAtPath:(NSString*) folderPath
{
    NSFileManager* manager = [NSFileManager defaultManager];
    if (![manager fileExistsAtPath:folderPath]) return 0;
    NSEnumerator *childFilesEnumerator = [[manager subpathsAtPath:folderPath] objectEnumerator];
    NSString* fileName;
    float folderSize = 0.0;
    while ((fileName = [childFilesEnumerator nextObject]) != nil)
    {
        NSString* fileAbsolutePath = [folderPath stringByAppendingPathComponent:fileName];
        folderSize += [self fileSizeAtPath:fileAbsolutePath];
    }
    
    if(folderSize <= 0 || !folderSize)
    {
        return 0;
    }
    else
    {
        return folderSize/(1024*1024.0);
    }
}

-(void)autoCleardata{
    
    NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    NSString *filePath1  = [[path objectAtIndex:0] stringByAppendingPathComponent:@"Caches/ImageCache"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath1])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath1 error:nil];
    }
    
    NSString *filePath4  = [[path objectAtIndex:0] stringByAppendingPathComponent:@"Caches/"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath4])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath4 error:nil];
    }
    
    NSString *filePath2  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath2])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath2 error:nil];
    }
    
    NSString *filePath3  = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath3])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath3 error:nil];
    }
    
    NSString *filePath5  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:filePath5])
    {
        [[NSFileManager defaultManager] removeItemAtPath:filePath5 error:nil];
    }
    
    
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];
    
//    [self showHudInView:self.view showHint:@"清除成功"];
    
    cacheCount = @"0.00M";
    NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[_dataArray objectAtIndex:1]];
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:0]];
    [dic setObject:cacheCount forKey:@"content"];
    [arr replaceObjectAtIndex:0 withObject:dic];
    [_dataArray replaceObjectAtIndex:1 withObject:arr];
    [_tableView reloadData];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [_dataArray count];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[_dataArray objectAtIndex:section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"cell";
    SystemSettingTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == NULL)
    {
        cell = [[SystemSettingTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    }
    
    [cell updateCellWithData:[[_dataArray objectAtIndex:indexPath.section] objectAtIndex:indexPath.row] andIndexPath:indexPath];
    
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
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
    if (indexPath.section == 0){
        if ([UserModel checkLogin]) {
            switch (indexPath.row)
            {
                case 0:
                {
                    AccountViewController *accountVC = [[AccountViewController alloc] init];
                    [self.navigationController pushViewController:accountVC animated:YES];
                }
                    break;
                default:
                    break;
            }

            
        }else{
            LoginViewController *loginVC = [[LoginViewController alloc]init];
            [self.navigationController pushViewController:loginVC animated:YES];
        }
        
        
    }else if (indexPath.section == 1){
        switch (indexPath.row)
        {
            case 0:
            {
                [LPActionSheetView showInView:self.view title:@"确定要清除缓存吗？" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:@"确定" otherButtonTitles:nil tagNumber:1];
            }
                break;
            default:
                break;
        }
    }else if (indexPath.section == 2){
        
        
    }else if (indexPath.section == 3){
        switch (indexPath.row)
        {
            case 0:
            {
                if ([UserModel checkLogin]) {
                    PostWeiBoViewController *postWeiBoVC = [[PostWeiBoViewController alloc] initWithNibName:nil bundle:nil andPlaceText:[NSString stringWithFormat:@"#%@#",@"iOS建议反馈"]];
                    [self presentViewController:postWeiBoVC animated:YES completion:nil];
                    

                }else{
                    
                    LoginViewController *loginVC = [[LoginViewController alloc]init];
                    [self.navigationController pushViewController:loginVC animated:YES];
                    
                }
                
//                OpinionViewController *opinionVC = [[OpinionViewController alloc] init];
//                            [self.navigationController pushViewController:opinionVC animated:YES];
//                PostWeiBoViewController *postWeiBoVC = [[PostWeiBoViewController alloc] initWithNibName:nil bundle:nil andPlaceText:[NSString stringWithFormat:@"#%@#",@"iOS建议反馈"]];
//                [self presentViewController:postWeiBoVC animated:YES completion:nil];
//                FeedbackViewController * feedBackView = [[FeedbackViewController alloc] init];
//                 [self.navigationController pushViewController:feedBackView animated:YES];
//                
                
            }
                break;
            case 1:
            {
                AboutViewController *aboutVC = [[AboutViewController alloc] init];
                [self.navigationController pushViewController:aboutVC animated:YES];
            }
                break;
                
            default:
                break;
        }
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)cancelLogin
{
    if ([UserModel checkLogin]) {
        [LPActionSheetView showInView:self.view title:@"确定要退出登录吗？" delegate:self cancelButtonTitle:@"再想想" destructiveButtonTitle:@"确定" otherButtonTitles:nil tagNumber:3];

    }else {
        LoginViewController *loginVC = [[LoginViewController alloc]init];
        [self.navigationController pushViewController:loginVC animated:YES];
    }
    
}

#pragma mark - LPActionSheetViewDelegate
- (void)actionSheetClickedOnDestructiveButton:(LPActionSheetView *)actionSheetView
{
    switch (actionSheetView.tag)
    {
        case 1:
        {
            //            NSLog(@"清除缓存-确定");
            NSArray *path = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
            NSString *filePath1  = [[path objectAtIndex:0] stringByAppendingPathComponent:@"Caches/ImageCache"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath1])
            {
                [[NSFileManager defaultManager] removeItemAtPath:filePath1 error:nil];
            }
            
            NSString *filePath4  = [[path objectAtIndex:0] stringByAppendingPathComponent:@"Caches/"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath4])
            {
                [[NSFileManager defaultManager] removeItemAtPath:filePath4 error:nil];
            }
            
            NSString *filePath2  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/ImageCache"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath2])
            {
                [[NSFileManager defaultManager] removeItemAtPath:filePath2 error:nil];
            }
            
            NSString *filePath3  = [NSHomeDirectory() stringByAppendingPathComponent:@"tmp/"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath3])
            {
                [[NSFileManager defaultManager] removeItemAtPath:filePath3 error:nil];
            }
            
            NSString *filePath5  = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/"];
            if ([[NSFileManager defaultManager] fileExistsAtPath:filePath5])
            {
                [[NSFileManager defaultManager] removeItemAtPath:filePath5 error:nil];
            }
            
            [[SDImageCache sharedImageCache] clearDisk];
            [[SDImageCache sharedImageCache] clearMemory];
            
            
            [self showHudInView:self.view showHint:@"清除成功"];
            
            cacheCount = @"0.00M";
            NSMutableArray *arr = [[NSMutableArray alloc] initWithArray:[_dataArray objectAtIndex:1]];
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:[arr objectAtIndex:0]];
            [dic setObject:cacheCount forKey:@"content"];
            [arr replaceObjectAtIndex:0 withObject:dic];
            [_dataArray replaceObjectAtIndex:1 withObject:arr];
            [_tableView reloadData];
        }
            break;
        case 2:
        {
            NSLog(@"删除所有聊天记录-确定");
//            [self showHudInView:self.view showHint:@"聊天记录已经删除"];
        }
            break;
        case 3:
        {
            [UserModel deleteUserPassport];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUT" object:nil];
            [self.navigationController popToRootViewControllerAnimated:YES];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGOUTSUCCESSFULL" object:self userInfo:nil];
//
//            //环信退出登录
//            EMError *error ;
//            NSDictionary *dic = [[EaseMob sharedInstance].chatManager logoffWithUnbindDeviceToken:NO error:&error];
//            if(!error && dic) {
//                NSLog(@"环信退出成功");
//            }
//            [[EaseMob sharedInstance].chatManager disableDeliveryNotification];
//            //            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
//            //            NSData *dataImage = (NSData *)[defaults objectForKey:@"userImage1"];
//            //            dataImage = nil;
//            [[NSUserDefaults standardUserDefaults] setObject:nil forKey:@"userImage1"];
        }
            break;
            
        default:
            break;
    }


}

@end
