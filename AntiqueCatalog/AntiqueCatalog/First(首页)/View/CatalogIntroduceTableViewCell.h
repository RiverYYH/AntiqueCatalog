//
//  CatalogIntroduceTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/9.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "catalogdetailsdata.h"

@protocol CatalogIntroduceTableViewCellDelegate <NSObject>

@optional

- (void)han:(BOOL)more andIndexPath:(NSIndexPath *)indexPath;

@end

@interface CatalogIntroduceTableViewCell : UITableViewCell

@property (nonatomic,assign)id <CatalogIntroduceTableViewCellDelegate>delegate;

- (void)updateCellWithData:(catalogdetailsdata *)data andmore:(BOOL)more andIndexPath:(NSIndexPath *)indexPath;

@end
