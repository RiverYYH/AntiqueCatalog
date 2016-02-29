//
//  UserSpaceTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/14.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UserSpacedata.h"

@protocol UserSpaceTableViewCellDelegate <NSObject>

@optional
- (void)addfollower:(BOOL)more andIndexPath:(NSIndexPath *)indexPath;
@end

@interface UserSpaceTableViewCell : UITableViewCell

@property (nonatomic,assign)id<UserSpaceTableViewCellDelegate>delegate;
@property (nonatomic,strong)UserSpacedata *userspacedata;
- (void)updateCellWithData:(UserSpacedata *)userspacedata andmore:(BOOL)more andIndexPath:(NSIndexPath *)indexPath;
@end
