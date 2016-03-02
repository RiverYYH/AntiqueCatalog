//
//  MybookView.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/7.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "MybookView.h"
#import "MybookCollectionViewCell.h"
#import "MybookCatalogdata.h"

@interface MybookView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray   *mybookcatalogarray;
@property (nonatomic,assign)BOOL             editor;

@property (nonatomic,assign)BOOL             isSelectEdit;
@property (nonatomic,strong)NSMutableArray   *indextArray;
@property (nonatomic,strong)NSMutableArray   *indextArray1;

@property (nonatomic,assign)BOOL             isAll;

@end

@implementation MybookView

- (instancetype)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(allselect:) name:@"allselect" object:nil];
        
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(allcancel:) name:@"allcancel" object:nil];
        [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(delete:) name:@"delete" object:nil];
        _mybookcatalogarray = [[NSMutableArray alloc]init];
        _editor = NO;
        _isSelectEdit = NO;
        _isAll = NO;
        _indextArray = [[NSMutableArray alloc]init];
        _indextArray1 = [[NSMutableArray alloc]init];
        [self CreatUI];
    }
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"allselect"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"allcancel"];
    [[NSNotificationCenter defaultCenter] removeObserver:self forKeyPath:@"delete"];
}

-(void)loadMybookCatalogdata:(NSMutableArray *)array{
    
    _mybookcatalogarray = array;
    [_collectionView reloadData];
}

- (void)allselect:(NSNotificationCenter *)notific
{
    _isAll = YES;
    [_indextArray removeLastObject];
    _isSelectEdit = YES;
    [_collectionView reloadData];
    
}
- (void)allcancel:(NSNotificationCenter *)notific
{
    _isAll = NO;
    _editor = NO;
    [_indextArray removeLastObject];
    _isSelectEdit = NO;
    [_collectionView reloadData];
}
- (void)delete:(NSNotificationCenter *)notific
{
    if (ARRAY_NOT_EMPTY(_indextArray)) {
        NSString *deletestring = @"";
        for (NSIndexPath *dex in _indextArray) {
            catalogdetailsCollectiondata *catalogdata = [_mybookcatalogarray objectAtIndex:dex.row];
            deletestring = [NSString stringWithFormat:@"%@,%@",deletestring,catalogdata.ID];
        }
        
        NSDictionary *prams = [NSDictionary dictionary];
        prams = @{@"cid":deletestring};
        
        [Api requestWithbool:YES withMethod:@"get" withPath:API_URL_Catalog_delToBook withParams:prams withSuccess:^(id responseObject) {

            if ([[responseObject objectForKey:@"status"] integerValue]) {
                for (NSIndexPath *dex in _indextArray) {
                    [_mybookcatalogarray removeObjectAtIndex:dex.row];
                }
                _editor = NO;
                _isAll = NO;
                [_indextArray removeLastObject];
                _isSelectEdit = NO;
                [_collectionView reloadData];
                [[NSNotificationCenter defaultCenter]postNotificationName:@"deleteOVer" object:nil];
            }
            
        } withError:^(NSError *error) {
            
            NSLog(@"%@",error);
            
            
            
        }];
        
    }
    
    
}

- (void)CreatUI{
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
    //  设定全局的Cell间距
    flowLayout.minimumInteritemSpacing = 0;
    //  设定全局的行间距
    flowLayout.minimumLineSpacing = 10;
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UI_SCREEN_WIDTH, UI_SCREEN_SHOW) collectionViewLayout:flowLayout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView setBackgroundColor:White_Color];
    //  必须注册你使用的单元格
    [_collectionView registerClass:[MybookCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    [self addSubview:_collectionView];
    
    
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    
//    此处给其增加长按手势，用此手势触发cell
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handlelongGesture:)];
    [_collectionView addGestureRecognizer:longGesture];
    
}


#pragma mark-UICollectionViewDataSource
//返回collection view里区(section)的个数，如果没有实现该方法，将默认返回1：
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
//返回指定区(section)包含的数据源条目数(number of items)，该方法必须实现：
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return _mybookcatalogarray.count;
}
//返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString * CellIdentifier = @"UICollectionViewCell";
    MybookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = White_Color;
//    cell.mybookCatalogdata = _mybookcatalogarray[indexPath.row];
    [cell reloaddata:_mybookcatalogarray[indexPath.row] andWithbool:_isSelectEdit andWithIndexPath:indexPath];
    if (_isAll == YES) {
        _isSelectEdit = YES;
        [_indextArray addObject:indexPath];
    }else{
        _isSelectEdit = NO;
    }
    return cell;
}
#pragma mark-UICollectionViewDelegate
//当指定indexPath处的item被选择时触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    _isAll = NO;
    if (_editor == NO) {
        if (_delegate && [self.delegate respondsToSelector:@selector(hanIndexPath:)]) {
            
            [self.delegate hanIndexPath:indexPath];
        }
    }else{
        
        BOOL ishave = NO;
        __block typeof(ishave) weakSelf = ishave;

        [_indextArray enumerateObjectsUsingBlock:^(NSIndexPath *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if (obj.row == indexPath.row) {
                weakSelf = YES;
                *stop = YES;
            }
            if (*stop == YES) {
                [_indextArray removeObject:obj];
            }
            
        }];
        ishave = weakSelf;
        if (ishave == NO) {
            [_indextArray addObject:indexPath];
            //NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            _isSelectEdit = YES;
            //[_collectionView reloadItemsAtIndexPaths:indexPaths];
            MybookCollectionViewCell *cell = (MybookCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            [cell.selectedImageview setHidden:NO];
        }else{
            //NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
            _isSelectEdit = NO;
            //[_collectionView reloadItemsAtIndexPaths:indexPaths];
            MybookCollectionViewCell *cell = (MybookCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
            [cell.selectedImageview setHidden:YES];
            
        }
  
    }

}
#pragma mark-UICollectionViewDelegateFlowLayout
//设定collectionView(指定区)的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //    return UIEdgeInsetsMake(15, 15, 30, 15);
    return UIEdgeInsetsMake(24, (UI_SCREEN_WIDTH - 108*3)/4, 0, (UI_SCREEN_WIDTH - 108*3)/4);
}
//设定指定Cell的尺寸
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(88+20, 116+12+25);
}
//设定指定区内Cell的最小行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 20;
}
//设定指定区内Cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)handlelongGesture:(UILongPressGestureRecognizer *)longGesture {
    
    switch (longGesture.state) {
        case UIGestureRecognizerStateBegan:
        {
            
            NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:[longGesture locationInView:self.collectionView]];
            
            if (ARRAY_NOT_EMPTY(_indextArray)) {
//                __weak __typeof(_indextArray) weakSelf = _indextArray;
//                __weak typeof(self)weakSelf =self;
                
                BOOL ishave = NO;
                for (NSIndexPath *index in _indextArray) {
                    if (index.row == indexPath.row) {
                        ishave = YES;
                    }
                }
                if (ishave == NO) {
                    [_indextArray addObject:indexPath];
                    //NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
                    _isSelectEdit = YES;
                    _editor = YES;
                    //[_collectionView reloadItemsAtIndexPaths:indexPaths];
                    MybookCollectionViewCell * cell = (MybookCollectionViewCell*)[_collectionView cellForItemAtIndexPath:indexPath];
                    [cell.selectedImageview setHidden:NO];
                }
                
                
            }else{
                
                [_indextArray addObject:indexPath];
                //NSArray *indexPaths = [NSArray arrayWithObjects:indexPath, nil];
                _isSelectEdit = YES;
                _editor = YES;
                //[_collectionView reloadItemsAtIndexPaths:indexPaths];
                MybookCollectionViewCell * cell = (MybookCollectionViewCell*)[_collectionView cellForItemAtIndexPath:indexPath];
                [cell.selectedImageview setHidden:NO];
            }
            
            if (_delegate && [_delegate respondsToSelector:@selector(longhan)]) {
                [_delegate longhan];
            }
            
        }
            break;
            
        default:
            break;
    }
    
}



@end
