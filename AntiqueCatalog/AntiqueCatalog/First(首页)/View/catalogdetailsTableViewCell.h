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
- (void)readingButtonDidClick;
- (void)downloadButtonDidClick;

- (void)leftViewDidClick;
- (void)centerViewDidClick;
- (void)rightViewDidClick;
@end


@interface catalogdetailsTableViewCell : UITableViewCell
@property (nonatomic,assign)id<catalogdetailsTableViewCellDelegate>delegate;
@property (nonatomic,strong)catalogdetailsdata *catalogdetailsData;
@property (assign, nonatomic) BOOL isPingLun;
- (void)initSubView;
@end
