//
//  MybookCollectionViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/7.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MybookCatalogdata.h"
#import "catalogdetailsCollectiondata.h"

@interface MybookCollectionViewCell : UICollectionViewCell

@property (nonatomic,strong)MybookCatalogdata *mybookCatalogdata;
@property (nonatomic,strong)catalogdetailsCollectiondata *catalogCollectiondata;

- (void)reloaddata:(MybookCatalogdata *)mybookCatalogdata andWithbool:(BOOL)isedit andWithIndexPath:(NSIndexPath *)indexPath;

@end
