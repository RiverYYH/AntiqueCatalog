//
//  RegisterCompleteViewController.m
//  Collector
//
//  Created by 刘鹏 on 14/11/8.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "RegisterCompleteViewController.h"
#import "RegisterCollectionReusableView.h"

#define KCellIdentifier @"cell"
#define KSupplementaryIdentifier @"Supplementary"

@interface RegisterCompleteViewController ()
{
    UICollectionView *_collectionView;

    NSMutableArray *_dataArray;
    NSMutableArray *_selectedCircleArray;
    NSMutableArray *_selectedUserArray;
}
@end

@implementation RegisterCompleteViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.titleLabel.text = @"推荐";
//    [_rightButton setTitle:@"跳过" forState:UIControlStateNormal];
    
    _dataArray = [NSMutableArray array];
    _selectedCircleArray = [NSMutableArray array];
    _selectedUserArray = [NSMutableArray array];
    
    UICollectionViewFlowLayout *collectionViewLayout = [[UICollectionViewFlowLayout alloc] init];
    collectionViewLayout.itemSize = CGSizeMake((UI_SCREEN_WIDTH-60)/4.0, (UI_SCREEN_WIDTH-60)/4.0+32);//每个item的size
    collectionViewLayout.sectionInset = UIEdgeInsetsMake(12, 12, 12, 12);//每个section的边界
    collectionViewLayout.minimumInteritemSpacing = 12;//每行item之间的间距
    collectionViewLayout.minimumLineSpacing = 12;//每行之间的间距
    collectionViewLayout.headerReferenceSize = CGSizeMake(UI_SCREEN_WIDTH, 30);//页眉的size
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, UI_NAVIGATION_BAR_HEIGHT, UI_SCREEN_WIDTH, UI_SCREEN_HEIGHT-UI_NAVIGATION_BAR_HEIGHT-50) collectionViewLayout:collectionViewLayout];
    [_collectionView registerClass:[RegisterCollectionViewCell class] forCellWithReuseIdentifier:KCellIdentifier];
    [_collectionView registerClass:[RegisterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KSupplementaryIdentifier];
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    _collectionView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_collectionView];
    
    UIButton *finishButton = [UIButton buttonWithType:UIButtonTypeCustom];
    finishButton.frame = CGRectMake(10, UI_SCREEN_HEIGHT-50, UI_SCREEN_WIDTH-20, 40);
    finishButton.layer.masksToBounds = YES;
    finishButton.layer.cornerRadius = 4.0;
    [finishButton setTitle:@"确定" forState:UIControlStateNormal];
    finishButton.titleLabel.font = [UIFont systemFontOfSize:17];
    [finishButton setBackgroundColor:ICON_COLOR];
    [finishButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:finishButton];
    
    [self loadNewData];
}

- (void)rightButtonClick:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSFULL" object:self userInfo:nil];
}

- (void)buttonClicked:(UIButton *)button
{
    if (ARRAY_NOT_EMPTY(_selectedCircleArray) || ARRAY_NOT_EMPTY(_selectedUserArray))
    {
        if (ARRAY_NOT_EMPTY(_selectedCircleArray))
        {
            NSMutableArray *weibasArray = [NSMutableArray array];
            for (int i=0; i<[_selectedCircleArray count]; i++)
            {
                [weibasArray addObject:[[_selectedCircleArray objectAtIndex:i] objectForKey:@"weiba_id"]];
            }
            
            NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:weibasArray,@"weiba_ids",nil];
            [Api requestWithMethod:@"POST" withPath:API_UIL_TUIJIANCIRCLE withParams:params withSuccess:^(id responseObject){
                NSLog(@"%@",responseObject);
                if ([[responseObject objectForKey:@"status"] intValue])
                {
                    if (ARRAY_NOT_EMPTY(_selectedUserArray))
                    {
                        NSMutableArray *uidsArray = [NSMutableArray array];
                        for (int i=0; i<[_selectedUserArray count]; i++)
                        {
                            [uidsArray addObject:[[[_selectedUserArray objectAtIndex:i] objectForKey:@"userInfo"] objectForKey:@"uid"]];
                        }
                        
                        NSMutableDictionary *param = [NSMutableDictionary dictionaryWithObjectsAndKeys:uidsArray,@"uids",nil];
                        NSLog(@"======%@",param);
                        [Api requestWithMethod:@"POST" withPath:API_UIL_TUIJIANUSER withParams:param withSuccess:^(id responseObject){
                            NSLog(@"%@",responseObject);
                            if ([[responseObject objectForKey:@"status"] intValue])
                            {
                                [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSFULL" object:self userInfo:nil];
                            }
                        } withError:^(NSError *error){
                            [self showHudInView:self.view showHint:@"请检查网络设置"];
                        }];
                    }
                }
            } withError:^(NSError *error){
                [self showHudInView:self.view showHint:@"请检查网络设置"];
            }];
        }
        else
        {
            if (ARRAY_NOT_EMPTY(_selectedUserArray))
            {
                NSMutableArray *uidsArray = [NSMutableArray array];
                for (int i=0; i<[_selectedUserArray count]; i++)
                {
                    [uidsArray addObject:[[[_selectedUserArray objectAtIndex:i] objectForKey:@"userInfo"] objectForKey:@"uid"]];
                }
                
                NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:uidsArray,@"uids",nil];
                [Api requestWithMethod:@"POST" withPath:API_UIL_TUIJIANUSER withParams:params withSuccess:^(id responseObject){
                    NSLog(@"%@",responseObject);
                    if ([[responseObject objectForKey:@"status"] intValue])
                    {
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSFULL" object:self userInfo:nil];
                    }
                } withError:^(NSError *error){
                    [self showHudInView:self.view showHint:@"请检查网络设置"];
                }];
            }
        }
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LOGINSUCCESSFULL" object:self userInfo:nil];
    }
}

- (void)loadNewData
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [Api requestWithMethod:@"GET" withPath:API_UIL_TUIJIAN withParams:nil withSuccess:^(id responseObject){
            NSLog(@"%@",responseObject);
            [_dataArray addObjectsFromArray:responseObject];
//            [_selectedCircleArray addObjectsFromArray:[responseObject objectAtIndex:0]];
            [_selectedUserArray addObjectsFromArray:[responseObject objectAtIndex:1]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [_collectionView reloadData];
                NSLog(@"更新界面");
            });
        } withError:^(NSError *error){
            NSLog(@"登录出错");
        }];
    });
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(ARRAY_NOT_EMPTY(_dataArray)) {
        return [[_dataArray objectAtIndex:1] count];
    } else {
        return 0;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    RegisterCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:KCellIdentifier forIndexPath:indexPath];
    cell.delegate = self;
    
    if(ARRAY_NOT_EMPTY(_dataArray)) {
        [cell updateCellWithData:[[_dataArray objectAtIndex:1] objectAtIndex:indexPath.row] andIndexPath:indexPath];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    RegisterCollectionReusableView *reusableView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:KSupplementaryIdentifier forIndexPath:indexPath];
    
    if(ARRAY_NOT_EMPTY(_dataArray)){
        [reusableView updateCellWithData:[[_dataArray objectAtIndex:1] objectAtIndex:indexPath.row] andIndexPath:indexPath];
    }
    
    return reusableView;
}

#pragma mark - RegisterCollectionViewCellDelegate
- (void)registerCollectionViewCell:(RegisterCollectionViewCell *)registerCollectionViewCell buttonClicked:(BOOL)selected andIndexPath:(NSIndexPath *)indexPath
{
    if (selected)
    {
        registerCollectionViewCell.registerButton.selected = NO;
        [_selectedUserArray removeObject:[[_dataArray objectAtIndex:1] objectAtIndex:indexPath.row]];
    }
    else
    {
        registerCollectionViewCell.registerButton.selected = YES;
        [_selectedUserArray addObject:[[_dataArray objectAtIndex:1] objectAtIndex:indexPath.row]];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
