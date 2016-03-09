//
//  PostTopicListTableViewCell.h
//  藏民网
//
//  Created by Hong on 15/5/9.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PostTopicListTableViewCell : UITableViewCell

- (void)updateCellWithData:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath;
@end
