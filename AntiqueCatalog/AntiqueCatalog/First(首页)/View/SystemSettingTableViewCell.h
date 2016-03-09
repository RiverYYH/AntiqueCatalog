//
//  SystemSettingTableViewCell.h
//  Collector
//
//  Created by 刘鹏 on 14/11/13.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SystemSettingTableViewCell : UITableViewCell
{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIImageView *_jiantouImageView;
    UISwitch *_switchButton;
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;

@end
