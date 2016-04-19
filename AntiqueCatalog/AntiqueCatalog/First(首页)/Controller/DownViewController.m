//
//  DownViewController.m
//  AntiqueCatalog
//
//  Created by yangyonghe on 16/4/16.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "DownViewController.h"
#import "CatalogDetailsViewController.h"

@interface DownViewController ()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray  *catalogArray;

@end

@implementation DownViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];

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
