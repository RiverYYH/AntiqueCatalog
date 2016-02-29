//
//  catalogMoreTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol catalogMoreTableViewCellDelegate <NSObject>

@optional

- (void)hanMoreIndexPath:(NSString *)MoreindexPath;

@end



@interface catalogMoreTableViewCell : UITableViewCell

@property (nonatomic,assign)id <catalogMoreTableViewCellDelegate>delegate;

- (void)loadWithstring:(NSString *)string andWitharray:(NSArray *)array andWithIndexPath:(NSIndexPath *)indexPath;


@end
