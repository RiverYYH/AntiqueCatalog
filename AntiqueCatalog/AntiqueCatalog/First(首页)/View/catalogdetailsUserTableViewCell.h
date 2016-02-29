//
//  catalogdetailsUserTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/11.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "catalogdetailsdata.h"

@protocol catalogdetailsUserTableViewCellDelegate <NSObject>

@optional

- (void)follow:(catalogdetailsdata *)catalogdetailsData andIndexPath:(NSIndexPath *)indexPath;
- (void)hanheadImage;

@end

@interface catalogdetailsUserTableViewCell : UITableViewCell

@property (nonatomic,assign)id <catalogdetailsUserTableViewCellDelegate>delegate;
@property (nonatomic,strong)catalogdetailsdata *catalogdetailsData;
- (void)loadCatalogdetailsData:(catalogdetailsdata *)catalogdetailsData andindexPath:(NSIndexPath *)indexPath;

@end
