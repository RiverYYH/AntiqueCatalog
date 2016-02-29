//
//  CatalogListTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/22.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CatalogGetList.h"

@interface CatalogListTableViewCell : UITableViewCell

- (void)initWithdic:(NSDictionary *)dic andWithcataloggetlist:(CatalogGetList *)cataloggetlist andWithIndexPath:(NSIndexPath *)indexPath;

#pragma mark 单元格高度
@property (assign,nonatomic) CGFloat height;


@end
