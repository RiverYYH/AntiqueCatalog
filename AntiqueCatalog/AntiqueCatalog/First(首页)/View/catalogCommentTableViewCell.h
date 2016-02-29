//
//  catalogCommentTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/11.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "commentData.h"

@protocol catalogCommentTableViewCellDelegate <NSObject>

@optional

- (void)hanisdigg:(NSIndexPath *)indexPath;

@end

@interface catalogCommentTableViewCell : UITableViewCell

@property (nonatomic,assign)id <catalogCommentTableViewCellDelegate>delegate;

- (void)loadWithCommentArray:(commentData *)commentdata andWithIndexPath:(NSIndexPath *)indexPath;

#pragma mark 单元格高度
@property (assign,nonatomic) CGFloat height;

@end
