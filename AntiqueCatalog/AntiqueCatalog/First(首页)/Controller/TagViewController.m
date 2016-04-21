//
//  TagViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/22.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "TagViewController.h"

#import "AntiqueCatalogData.h"
#import "AntiqueCatalogViewCell.h"
#import "CatalogDetailsViewController.h"

@interface TagViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray  *catalogArray;//图录数组
@property (nonatomic,assign)BOOL            isMore;
@property (nonatomic,copy)NSString          *count;
@property (nonatomic,strong)UILabel         *lable1;


@end

@implementation TagViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.titleLabel.text = @"标签";
    
    _isMore = NO;
    _catalogArray = [[NSMutableArray alloc]init];
    
    [self CreatUI];
    [self loaddata];


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
    

    _lable1 = [Allview Withstring:[NSString stringWithFormat:@"%@本图录", _count] Withcolor:Deputy_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    
}


- (void)loaddata{
    
    NSDictionary *prams = [[NSDictionary alloc]init];
    if (_isMore) {
        prams = @{@"":_ID,@"max_id":@"0"};
    }else{
        prams = @{@"id":_ID,@"max_id":@"0"};
    }
    
    [Api requestWithbool:NO withMethod:@"get" withPath:API_URL_Catalog_getTagCatalog withParams:prams withSuccess:^(id responseObject) {
        
        _count = [responseObject objectForKey:@"count"];
        
        NSArray *dataarray = [[NSArray alloc]init];
        dataarray = [responseObject objectForKey:@"catalog"];
        if (ARRAY_NOT_EMPTY(dataarray)) {
            if (_isMore) {
                
            }else{
                [_catalogArray removeAllObjects];
            }
            for (NSDictionary *dic in dataarray) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_catalogArray addObject:[AntiqueCatalogData WithTypeListDataDic:[dic objectForKey:@"info"]]];
                }
                
            }
            [_tableView reloadData];
        }

        
    } withError:^(NSError *error) {
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _catalogArray.count+1;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        
        static NSString *identifier = @"cellone";
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell removeFromSuperview];
        
        UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(16, 24, 46, 46)];
        
        imageview.image = [UIImage imageNamed:@"icon_tag"];
        
        UILabel *lable = [Allview Withstring:[_dic objectForKey:@"name"] Withcolor:Essential_Colour Withbgcolor:Clear_Color Withfont:Catalog_Cell_Name_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
        lable.frame = CGRectMake(CGRectGetMaxX(imageview.frame), 24, 260, 15);
        
        _lable1.text = @"";
        _lable1.text = [NSString stringWithFormat:@"%@本图录",_count];
        
        _lable1.frame = CGRectMake(CGRectGetMaxX(imageview.frame), CGRectGetMaxY(lable.frame)+5, 260, 15);
        
        [cell.contentView addSubview:imageview];
        [cell.contentView addSubview:lable];
        [cell.contentView addSubview:_lable1];
        
        
        return cell;
        
    }else if (indexPath.row > 0) {
        
        static NSString *identifier = @"cellantique";
        AntiqueCatalogViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        if (!cell) {
            cell = [[AntiqueCatalogViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (ARRAY_NOT_EMPTY(_catalogArray)) {
            cell.antiquecatalogdata = _catalogArray[indexPath.row - 1];
        }
        return cell;
        
    }
    return nil;
    
    
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return 91;
    }else{
        return 141.0f;
    }
    
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
    
    CatalogDetailsViewController *catalogVC = [[CatalogDetailsViewController alloc]init];
    AntiqueCatalogData *antiqueCatalogdata = _catalogArray[indexPath.row - 1];
    catalogVC.ID = antiqueCatalogdata.ID;
    catalogVC.mfileName = antiqueCatalogdata.name;

    [self.navigationController pushViewController:catalogVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
