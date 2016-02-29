//
//  NotificationTableViewCell.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/2/20.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NotificationTableViewCell : UITableViewCell
{
    UILabel *_titleLabel;
    UILabel *_timeLabel;
    UILabel *_contentLabel;
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;

@end
