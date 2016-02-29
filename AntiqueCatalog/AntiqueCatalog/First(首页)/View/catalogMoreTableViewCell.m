//
//  catalogMoreTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "catalogMoreTableViewCell.h"
#import "MybookCollectionViewCell.h"

@interface catalogMoreTableViewCell ()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong)UILabel *label;
@property (nonatomic,strong)UICollectionView *collectionView;
@property (nonatomic,strong)NSMutableArray *bookcatalogarray;

@end

@implementation catalogMoreTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initSubView];
        
    }
    return self;
}

- (void)initSubView
{
    self.backgroundColor = [UIColor colorWithConvertString:Background_Color];
    
    _bookcatalogarray = [[NSMutableArray alloc]init];
    
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = White_Color;
    
    _label = [Allview Withstring:@"" Withcolor:Deputy_Colour Withbgcolor:White_Color Withfont:Catalog_Cell_info_Font WithLineBreakMode:1 WithTextAlignment:NSTextAlignmentLeft];
    _label.frame = CGRectMake(16, 10, UI_SCREEN_WIDTH - 32, 30);
    
    //确定是水平滚动，还是垂直滚动
    UICollectionViewFlowLayout *flowLayout=[[UICollectionViewFlowLayout alloc] init];
    [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    //  设定全局的Cell间距
    flowLayout.minimumInteritemSpacing = 0;
    //  设定全局的行间距
    flowLayout.minimumLineSpacing = 10;
    flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
    flowLayout.itemSize = CGSizeMake(88+6, 116+12+46);
    
    _collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_label.frame), UI_SCREEN_WIDTH, 116+12+45) collectionViewLayout:flowLayout];
    _collectionView.dataSource=self;
    _collectionView.delegate=self;
    [_collectionView setBackgroundColor:White_Color];
    //  必须注册你使用的单元格
    [_collectionView registerClass:[MybookCollectionViewCell class] forCellWithReuseIdentifier:@"UICollectionViewCell"];
    _collectionView.alwaysBounceVertical = YES;
    _collectionView.showsVerticalScrollIndicator = NO;
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.scrollEnabled = NO;
    _collectionView.contentSize =  CGSizeMake(0, 0);
    
    view.frame = CGRectMake(0, 10, UI_SCREEN_WIDTH, CGRectGetMaxY(_collectionView.frame));
    
    [view addSubview:_label];
    [view addSubview:_collectionView];
    [self.contentView addSubview:view];
    
}

- (void)loadWithstring:(NSString *)string andWitharray:(NSArray *)array andWithIndexPath:(NSIndexPath *)indexPath
{
    [_bookcatalogarray removeAllObjects];
    _label.text = string;
    if (ARRAY_NOT_EMPTY(array)) {
        for (NSDictionary *dic in array) {
            [_bookcatalogarray addObject:[catalogdetailsCollectiondata WithbookCatalogDataDic:dic]];
        }
        [_collectionView reloadData];
    }
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
    return _bookcatalogarray.count;
}
//返回某个indexPath对应的cell，该方法必须实现：
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * CellIdentifier = @"UICollectionViewCell";
    MybookCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    cell.backgroundColor = White_Color;
    cell.mybookCatalogdata = _bookcatalogarray[indexPath.row];
    
    return cell;
}
#pragma mark-UICollectionViewDelegate
//当指定indexPath处的item被选择时触发
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    catalogdetailsCollectiondata *data = _bookcatalogarray[indexPath.row];
    NSString *idstring = data.ID;
    if (_delegate && [self.delegate respondsToSelector:@selector(hanMoreIndexPath:)]) {
        
        [self.delegate hanMoreIndexPath:idstring];
    }
    
}
#pragma mark-UICollectionViewDelegateFlowLayout
//设定collectionView(指定区)的边距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    //    return UIEdgeInsetsMake(15, 15, 30, 15);
    return UIEdgeInsetsMake(0, (UI_SCREEN_WIDTH-88*3)/4, 0, 24);
}
//设定指定Cell的尺寸
//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return CGSizeMake(88+6, 116+12+25);
//}
//设定指定区内Cell的最小行距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15;
}
//设定指定区内Cell的最小间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}


@end
