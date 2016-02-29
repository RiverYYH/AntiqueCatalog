//
//  catalogdetailsTagTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/10.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "catalogdetailsdata.h"

@protocol catalogdetailsTagTableViewCellDelegate <NSObject>

@optional

- (void)hanTapOne:(NSDictionary *)dic;

@end


@interface catalogdetailsTagTableViewCell : UITableViewCell

@property (nonatomic,assign)id <catalogdetailsTagTableViewCellDelegate>delegate;

@property (nonatomic,strong)catalogdetailsdata *catalogdetailsData;

@end
