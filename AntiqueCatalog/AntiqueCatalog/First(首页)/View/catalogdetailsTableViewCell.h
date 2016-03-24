//
//  catalogdetailsTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/9.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "catalogdetailsdata.h"

@protocol catalogdetailsTableViewCellDelegate <NSObject>

@optional
- (void)hanreadingclick;
- (void)hancataloglistclick;

@end


@interface catalogdetailsTableViewCell : UITableViewCell
@property (nonatomic,assign)id<catalogdetailsTableViewCellDelegate>delegate;
@property (nonatomic,strong)catalogdetailsdata *catalogdetailsData;
@property (assign, nonatomic) BOOL isPingLun;

@end
