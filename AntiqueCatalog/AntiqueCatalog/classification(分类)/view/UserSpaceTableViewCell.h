//
//  UserSpaceTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/14.
//  Copyright © 2016年 Cangmin. All rights reserved.
//
//艺术独家号首页 上半部分CELL
#import <UIKit/UIKit.h>
#import "UserSpacedata.h"

@protocol UserSpaceTableViewCellDelegate <NSObject>

@optional
- (void)addfollower:(BOOL)more andIndexPath:(NSIndexPath *)indexPath;

@optional
-(void)addOrUnaddFollowerWithUserSpacedata:(UserSpacedata*)userspacedata AndButton:(UIButton*)button AndIndexPath:(NSIndexPath*)indexPath;
@end

@interface UserSpaceTableViewCell : UITableViewCell

@property (nonatomic,assign)id<UserSpaceTableViewCellDelegate>delegate;
@property (nonatomic,strong)UserSpacedata *userspacedata;
- (void)updateCellWithData:(UserSpacedata *)userspacedata andmore:(BOOL)more andIndexPath:(NSIndexPath *)indexPath;
@end
