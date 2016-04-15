//
//  AddFolloweringTableViewCell.h
//  AntiqueCatalog
//
//  Created by CssWeb on 16/4/13.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AddFolloweringdata.h"

@protocol AddFoloweringTableViewCellDelegate <NSObject>

@optional
-(void)didClickFollowButtonWithData:(NSString *)uid;

@end

@interface AddFolloweringTableViewCell : UITableViewCell
@property (nonatomic,strong)AddFolloweringdata * followeringdata;
@property (nonatomic) id<AddFoloweringTableViewCellDelegate>delegate;
@end
