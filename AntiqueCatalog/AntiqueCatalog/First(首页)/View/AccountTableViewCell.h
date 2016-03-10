//
//  AccountTableViewCell.h
//  Collector
//
//  Created by 刘鹏 on 14/12/3.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AccountTableViewCellDelegate <NSObject>

- (void)buttonClicked:(NSIndexPath *)indexPath;

@end

@interface AccountTableViewCell : UITableViewCell
{
    UIImageView *_imageView;
    UILabel *_label;
    UIButton *_button;
    
    NSIndexPath *_indexPath;
}

@property (strong,nonatomic)id<AccountTableViewCellDelegate> delegate;

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;

@end
