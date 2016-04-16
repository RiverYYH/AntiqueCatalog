//
//  UserSpaceViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/14.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "UserSpaceViewController.h"
#import "UserSpacedata.h"
#import "UserSpaceTableViewCell.h"

#import "AntiqueCatalogData.h"
#import "AntiqueCatalogViewCell.h"
#import "CatalogDetailsViewController.h"

@interface UserSpaceViewController ()<UITableViewDataSource,UITableViewDelegate,UserSpaceTableViewCellDelegate>

@property (nonatomic,strong)UserSpacedata *userspacedata;

@property (nonatomic,strong)UITableView *tableView;
@property (nonatomic,strong)NSMutableArray *catalogArray;

@property (nonatomic,assign)BOOL isMore;
@property (nonatomic,assign)BOOL isOne;
@property (nonatomic,assign)BOOL isOpen;

@end

@implementation UserSpaceViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.titleLabel.text = @"艺术独家号主页";
    _isMore = NO;
    _isOne = YES;
    _isOpen = NO;
    _catalogArray = [[NSMutableArray alloc]init];
    [self CreatUI];
    [self loaduserdata];
    // Do any additional setup after loading the view.
}

- (void)CreatUI{
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
}

- (void)loaduserdata{
    
    NSDictionary *prams = [NSDictionary dictionary];
    if (_isMore) {
        
        prams = @{@"user_id":_uid,@"max_id":@"1"};
    }else{
        
        prams = @{@"user_id":_uid,@"max_id":@"0"};
    }
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_USER_userInfo withParams:prams withSuccess:^(id responseObject) {
        
        if (_isOne) {
            _isOne = NO;
            NSDictionary *dic = [responseObject objectForKey:@"userInfo"];
            _userspacedata = [UserSpacedata WithUserSpacedataDic:dic];
        }
        NSArray *array = [responseObject objectForKey:@"catalog"];
        if(ARRAY_NOT_EMPTY(array)){
            for (NSDictionary *dic in array) {
                [_catalogArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
            }
        }
        [_tableView reloadData];
    } withError:^(NSError *error) {
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }else{
        return _catalogArray.count;
    }
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
//    static NSString *identifier = @"cellUp";
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
//    if (!cell) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
//    }
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    return cell;
    if (indexPath.row == 0 && indexPath.section == 0) {
        static NSString *identifier = @"cellUp";
        UserSpaceTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UserSpaceTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        [cell updateCellWithData:_userspacedata andmore:_isOpen andIndexPath:indexPath];
        return cell;
    }else{
        
        static NSString *identifier = @"cellantique";
        AntiqueCatalogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AntiqueCatalogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (ARRAY_NOT_EMPTY(_catalogArray)) {
            cell.antiquecatalogdata = _catalogArray[indexPath.row];
        }
        return cell;

        
    }
    return nil;
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UILabel *lable = [[UILabel alloc]init];
        CGSize infosize;
        if (STRING_NOT_EMPTY(_userspacedata.intro)) {
            infosize = [Allview String:_userspacedata.intro Withfont:Catalog_Cell_info_Font WithCGSize:UI_SCREEN_WIDTH - 64 Withview:lable Withinteger:0];
        }else{
            infosize = CGSizeMake(0.f, 0.f);
        }
        if (_isOpen) {
            return 24+48+16+15+12+30+12+infosize.height+30;
            
        }else{
            if (infosize.height > 35.0f) {
                return 24+72+16+15+12+30+12+35+30;
            }else{
                return 24+72+16+15+12+30+12+infosize.height+10;;
            }
        }
    }else{
        return 141.0f;
    }
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 1.0f;
    }else{
        return 10.0f;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 0.01f;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        CatalogDetailsViewController *catalogVC = [[CatalogDetailsViewController alloc]init];
        AntiqueCatalogData *antiqueCatalogdata = _catalogArray[indexPath.row];
        catalogVC.ID = antiqueCatalogdata.ID;
        [self.navigationController pushViewController:catalogVC animated:YES];
    }
}

#pragma mark - UserSpaceTableViewCellDelegate
-(void)addfollower:(BOOL)more andIndexPath:(NSIndexPath *)indexPath{
    _isOpen = !_isOpen;
    
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
    
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

-(void)addOrUnaddFollowerWithUserSpacedata:(UserSpacedata *)userspacedata AndButton:(UIButton *)button AndIndexPath:(NSIndexPath *)indexPath{
    NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
    NSString * userId = userspacedata.uid;
    BOOL following = userspacedata.follow_status_following;
    NSString * actionAdd;
    NSDictionary *param = [NSDictionary dictionary];
    
    param = @{@"user_id":userId};
    if(following){
        actionAdd = API_URL_USER_UNFollow;
    }else{
        actionAdd = API_URL_USER_Follow;
    }
    NSLog(@"----usewrid=%@----actionAdd=%@",userId,actionAdd);
    [Api showLoadMessage:@"正在加载"];
    [Api requestWithbool:YES withMethod:@"get" withPath:actionAdd withParams:param withSuccess:^(id responseObject) {
        
        NSLog(@"%@",responseObject[@"msg"]);
        if ([[responseObject objectForKey:@"status"] integerValue] == 1) {
            if(following){
                userspacedata.follow_status_following = 0;
            }else{
                userspacedata.follow_status_following = 1;
            }
            [_tableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
        }
        [Api hideLoadHUD];
    } withError:^(NSError *error) {
        [Api hideLoadHUD];
        
    }];
}
@end
