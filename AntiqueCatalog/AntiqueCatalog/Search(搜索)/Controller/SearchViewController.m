//
//  SearchViewController.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/15.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "SearchViewController.h"

#import "AntiqueCatalogData.h"
#import "AntiqueCatalogViewCell.h"
#import "CatalogDetailsViewController.h"

#import "ScreeningView.h"

#import "CatalogCategorydata.h"



@interface SearchViewController ()<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate,ScreeningViewDelegate>


@property (nonatomic,strong)NSMutableArray   *catalogcategoryarray;

@property (nonatomic,strong)UITableView     *tableView;
@property (nonatomic,strong)NSMutableArray  *catalogArray;//图录数组

@property (nonatomic,strong)UISearchBar *searchBar;
@property (nonatomic,copy)NSString      *seatchBarstring;
@property (nonatomic,assign)BOOL        isMore;
@property (nonatomic,strong)UIButton    *screening;

@property (nonatomic,strong)ScreeningView *sereenView;
@property (nonatomic,strong)NSMutableDictionary *mutdic;
@property (nonatomic,assign)NSInteger   integer;

@property (nonatomic,strong)NSMutableArray *author;
@property (nonatomic,strong)NSMutableArray *city;
@end

@interface SearchViewController ()

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.rightButton setImage:[UIImage imageNamed:@"icon_search"] forState:UIControlStateNormal];
    [self.rightButton setImageEdgeInsets:UIEdgeInsetsMake(0,0,0,-10)];
    
    _isMore = NO;
    
    _catalogArray = [[NSMutableArray alloc]init];
    _catalogcategoryarray = [[NSMutableArray alloc]init];
    _mutdic = [[NSMutableDictionary alloc]init];
    _integer = 0;
    
    _author = [[NSMutableArray alloc]init];
    _city = [[NSMutableArray alloc]init];
    
    NSMutableArray *aa = [[NSMutableArray alloc]initWithObjects:@"1",@"2",@"3",@"1",@"2",@"3", nil];
    NSMutableArray *bb = [[NSMutableArray alloc]init];
    [aa enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
      
        __block BOOL isContain = NO;
        
        [bb enumerateObjectsUsingBlock:^(NSString *desString, NSUInteger idx, BOOL *stop) {
            
            if (NSOrderedSame == [obj compare:desString options:NSCaseInsensitiveSearch]) {
                
                isContain = YES;
                
            }}];
        
        if (NO == isContain) {
            
            [bb addObject:obj];
        }
        
     
    }];
    
    [self CreatUI];
    
//    [self loadtitle];
    
    // Do any additional setup after loading the view.
}

//- (void)loadtitle{
//    
//    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_getCatalogCategory withParams:nil withSuccess:^(id responseObject) {
//        
//        if (ARRAY_NOT_EMPTY(responseObject)) {
//            for (NSDictionary *dic in responseObject) {
//                CatalogCategorydata *catalogcategory = [CatalogCategorydata WithCatalogCategoryDataDic:dic];
//                [_catalogcategoryarray addObject:catalogcategory];
//            }
//            _sereenView.titleArray = _catalogcategoryarray;
//            
//        }
//        
//    } withError:^(NSError *error) {
//        
//    }];
//    
//}

- (void)rightButtonClick:(id)sender{
    _isMore = NO;
    [_searchBar resignFirstResponder];
    if (STRING_NOT_EMPTY(_seatchBarstring)) {
        [self loaddata];
    }
}

- (void)CreatUI{
    
    _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(44, 20, UI_SCREEN_WIDTH - 44 - 44 , 44)];
    [self.titleImageView addSubview:_searchBar];
    [_searchBar setPlaceholder:@"搜索图录"];// 搜索框的占位符
    _searchBar.delegate = self;
    _searchBar.backgroundColor = [UIColor clearColor];
    [_searchBar becomeFirstResponder];
    //    去掉搜索框的背景视图
    for (UIView *view in _searchBar.subviews) {
        // for before iOS7.0
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        }
        if ([view isKindOfClass:NSClassFromString(@"UISearchBarTextField")]) {
            view.layer.masksToBounds = YES;
            view.layer.cornerRadius = 4;
            view.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
            view.layer.borderWidth = 1.0;
        }
        // for later iOS7.0(include)
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            [[view.subviews objectAtIndex:0] removeFromSuperview];
            //            break;
        }
        if ([view isKindOfClass:NSClassFromString(@"UIView")] && view.subviews.count > 0) {
            //            NSLog(@"%d",view.subviews.count);
            UIView *view1 = [view.subviews objectAtIndex:0];
            view1.layer.masksToBounds = YES;
            view1.layer.cornerRadius = 4;
            view1.layer.borderColor = [UIColor colorWithConvertString:Background_Color].CGColor;
            view1.layer.borderWidth = 1.0;
        }
    }
    
    _screening = [[UIButton alloc]initWithFrame:CGRectMake(CGRectGetMaxX(_searchBar.frame), 20, 44, 44)];
    [_screening setImage:[UIImage imageNamed:@"icon_select"] forState:UIControlStateNormal];
    _screening.hidden = YES;
    [_screening addTarget:self action:@selector(screeningclick:) forControlEvents:UIControlEventTouchUpInside];
    [self.titleImageView addSubview:_screening];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) style:UITableViewStyleGrouped];
    _tableView.separatorInset = UIEdgeInsetsMake(0, 0, 0, 0);
    _tableView.separatorColor = Clear_Color;
    _tableView.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _sereenView = [[ScreeningView alloc]initWithFrame:CGRectMake(UI_SCREEN_WIDTH, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20)];
    _sereenView.delegate = self;
    [self.view addSubview:_sereenView];
  
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    _seatchBarstring = searchText;
    if (!STRING_NOT_EMPTY(_seatchBarstring)) {
        self.rightButton.hidden = NO;
        _screening.hidden = YES;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    _isMore = NO;
    [_searchBar resignFirstResponder];
    if (STRING_NOT_EMPTY(_seatchBarstring)) {
        [self loaddata];
    }
}

- (void)screeningclick:(UIButton *)btn{
    
    if (ARRAY_NOT_EMPTY(_catalogcategoryarray)) {
        [_sereenView reloadtable];
    }
    
    [_sereenView reloadaution];
    
    [UIView animateWithDuration:0.5 animations:^{
        
        _sereenView.frame = CGRectMake(0, 20, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT - 20);
        
    } completion:^(BOOL finished) {
        _sereenView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
    }];
    
    
}

#pragma mark - ScreeningViewDelegate

-(void)sure:(NSMutableDictionary *)dic andWithint:(NSInteger)integer
{
    _mutdic = dic;
    _integer = integer;
    [self loaddata];
}

- (void)sure_paimai:(NSMutableDictionary *)dic andWithint:(NSInteger)integer{
    
    _mutdic = dic;
    _integer = integer;
}

- (void)loaddata{
    
    NSMutableDictionary *prams = [[NSMutableDictionary alloc]init];
    if (_isMore) {
        
        prams = [NSMutableDictionary dictionaryWithObjectsAndKeys:_seatchBarstring,@"key", nil];
        if (DIC_NOT_EMPTY(_mutdic) && _integer == 1) {
            NSArray *array = [_mutdic allKeys];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [prams setValue:[_mutdic objectForKey:obj] forKey:obj];
            }];
        }
        if (DIC_NOT_EMPTY(_mutdic) && _integer == 2) {
            NSArray *array = [_mutdic allKeys];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [prams setValue:[_mutdic objectForKey:obj] forKey:obj];
            }];
        }
        
    }else{
        
        prams = [NSMutableDictionary dictionaryWithObjectsAndKeys:_seatchBarstring,@"key", nil];
        if (DIC_NOT_EMPTY(_mutdic) && _integer == 1) {
            NSArray *array = [_mutdic allKeys];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [prams setValue:[_mutdic objectForKey:obj] forKey:obj];
            }];
        }
        if (DIC_NOT_EMPTY(_mutdic) && _integer == 2) {
            NSArray *array = [_mutdic allKeys];
            [array enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
                [prams setValue:[_mutdic objectForKey:obj] forKey:obj];
            }];
        }
        
        
    }
    
    [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_search withParams:prams withSuccess:^(id responseObject) {
        NSArray *dataarray = [[NSArray alloc]init];
        dataarray = [responseObject objectForKey:@"data"];
        
        NSArray *categoryarray = [[NSArray alloc]init];
        categoryarray = [responseObject objectForKey:@"category"];
        
        NSArray *authorarray = [[NSArray alloc]init];
        authorarray = [responseObject objectForKey:@"author"];
        
        NSArray *cityarray = [[NSArray alloc]init];
        cityarray = [responseObject objectForKey:@"city"];
        
        if (ARRAY_NOT_EMPTY(dataarray)) {
            if (_isMore) {
                
            }else{
                [_catalogArray removeAllObjects];
            }
            for (NSDictionary *dic in dataarray) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_catalogArray addObject:[AntiqueCatalogData WithTypeListDataDic:dic]];
                }
                
            }
            [_tableView reloadData];
        }
        
        if (ARRAY_NOT_EMPTY(categoryarray) && _catalogcategoryarray.count == 0) {
            
            for (NSDictionary *dic in categoryarray) {
                CatalogCategorydata *catalogcategory = [CatalogCategorydata WithCatalogCategoryDataDic:dic];
                [_catalogcategoryarray addObject:catalogcategory];
            }
            _sereenView.titleArray = _catalogcategoryarray;
            
        }
        
        if (ARRAY_NOT_EMPTY(authorarray) && _author.count == 0) {
            for (NSDictionary *dic in authorarray) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_author addObject:dic];
                }
                
            }
                        _sereenView.author = _author;
        }
        
        if (ARRAY_NOT_EMPTY(cityarray) && _city.count == 0) {
            for (NSDictionary *dic in cityarray) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_city addObject:dic];
                }
            }
            for (NSDictionary *dic in cityarray) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_city addObject:dic];
                }
            }
            for (NSDictionary *dic in cityarray) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_city addObject:dic];
                }
            }
            for (NSDictionary *dic in cityarray) {
                if (DIC_NOT_EMPTY(dic)) {
                    [_city addObject:dic];
                }
            }
            _sereenView.city = _city;
        }

        if (STRING_NOT_EMPTY(_seatchBarstring) && ARRAY_NOT_EMPTY(_catalogArray)) {
            self.rightButton.hidden = YES;
            _screening.hidden = NO;
        }
        
        _isMore = NO;
        
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
    return _catalogArray.count;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 141.0f;
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
    AntiqueCatalogData *antiqueCatalogdata = _catalogArray[indexPath.row];
    catalogVC.ID = antiqueCatalogdata.ID;
    [self.navigationController pushViewController:catalogVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
