//
//  ClassficationViewController.m
//  AntiqueCatalog
//
//  Created by cssweb on 16/4/5.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "ClassficationViewController.h"
#import "TabbarScrollView.h"
#import "CatalogCategorydata.h"
#import "AntiqueCatalogData.h"
#import "AntiqueCatalogViewCell.h"
#import "CatalogDetailsViewController.h"
#import "CustmonCollectionViewCell.h"
//#import "MJRefreshNormalHeader.h"
#import "MJRefresh.h"
#import "ClassficationDailView.h"
#import "ClassificationViewController.h"

#define  ScreenWidth  [UIScreen mainScreen].bounds

@interface ClassficationViewController ()<UICollectionViewDelegate,UICollectionViewDataSource>
@property (nonatomic, strong) UICollectionView * myCollectionView;
@property (nonatomic,strong) NSMutableArray * titleDataArray;
@property (nonatomic,strong) NSString * refreshType;

@end

@implementation ClassficationViewController
- (instancetype)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
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
    self.titleDataArray = [NSMutableArray array];
    self.refreshType = @"0";
    self.titleLabel.text = @"分类";
    [self initWithCollection];
    [self loadtitle];


}

-(void)initWithCollection{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    _myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(self.view.bounds.origin.x,  UI_NAVIGATION_BAR_HEIGHT, self.view.bounds.size.width, UI_SCREEN_SHOW) collectionViewLayout:layout];
    [self.view addSubview:_myCollectionView];
    [self.myCollectionView registerClass:[CustmonCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
    [_myCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"reusableView"];
    
    //4.设置代理
    _myCollectionView.delegate = self;
    _myCollectionView.dataSource = self;
    _myCollectionView.backgroundColor = [UIColor clearColor];
    __unsafe_unretained UICollectionView *tableView = _myCollectionView;
    tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
//        NSLog(@"rrrrrrrrrrrrrrrrrrr");
        [self.titleDataArray removeAllObjects];
        [self loadTitleWith:tableView];
        
    }];
    //    [UIScreen s]
}

-(void)loadTitleWith:(UICollectionView*)collectionView{
//    NSMutableDictionary * parm = [NSMutableDictionary dictionary];
//    parm[@"id"] = @"0";
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getCatalogCategoryNew withParams:nil withSuccess:^(id responseObject) {
        [collectionView.mj_header endRefreshing];

        if (ARRAY_NOT_EMPTY(responseObject)) {
            //            NSLog(@"dddddddddddd:%@",responseObject);
            NSArray * resultArray = [NSArray arrayWithArray:responseObject];
            [self.titleDataArray addObjectsFromArray:resultArray];
            [self.myCollectionView reloadData];
            
        }
        
        
    }withError:^(NSError *error) {
        [collectionView.mj_header endRefreshing];
 
    }];

}

-(void)loadtitle{
   
    [Api showLoadMessage:@"加载数据中"];

    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getCatalogCategory withParams:nil withSuccess:^(id responseObject) {
    
        [Api hideLoadHUD];

        if (ARRAY_NOT_EMPTY(responseObject)) {
//            NSLog(@"dddddddddddd:%@",responseObject);
            NSArray * resultArray = [NSArray arrayWithArray:responseObject];
            [self.titleDataArray addObjectsFromArray:resultArray];
            [self.myCollectionView reloadData];
            
        }

        
    }withError:^(NSError *error) {
     
    }];
}


#pragma UICollectionViewDelegate and UICollectionViewDataSource

//设置每个item水平间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


//设置每个item垂直间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 10;
}


#pragma mark collectionView代理方法
//返回section个数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

//每个section的item个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [self.titleDataArray count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    CustmonCollectionViewCell *cell = (CustmonCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    NSDictionary * dict = [self.titleDataArray objectAtIndex:indexPath.row];
    
    if (STRING_NOT_EMPTY(dict[@"title"])) {
        cell.cellTitle.text = [NSString stringWithFormat:@"%@",dict[@"title"]];

    }
    if (STRING_NOT_EMPTY(dict[@"cover"])) {
        [cell.cellImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",dict[@"cover"]]]];
    }

//    NSString * urlStr = [NSString stringWithFormat:@"%@",dict[@"cover"]];
    
    
    cell.backgroundColor = [UIColor yellowColor];
    
    return cell;
}

//设置每个item的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake((ScreenWidth.size.width-30)/2, 100);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
//    ClassficationDailView * dailView = [[ClassficationDailView alloc] init];
//    NSDictionary * dict = [self.titleDataArray objectAtIndex:indexPath.row];
//    dailView.dataDict = dict;
//    [self.navigationController pushViewController:dailView animated:YES];
    
    ClassificationViewController * dailView = [[ClassificationViewController alloc] init];
    NSDictionary * dict = [self.titleDataArray objectAtIndex:indexPath.row];
    dailView.tempId = [NSString stringWithFormat:@"%@",dict[@"id"]];
    [self.navigationController pushViewController:dailView animated:YES];

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
