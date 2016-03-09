//
//  CommentTableViewCell.h
//  Collector
//
//  Created by 刘鹏 on 14/11/22.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LPRichTextView.h"

@interface CommentTableViewCell : UITableViewCell
{
    UIImageView *_userFaceImageView;
    UILabel *_nameLabel;
    UILabel *_floorLabel;
    UILabel *_timeLabel;
    UIButton *_pinglunButton;
    
    LPRichTextView *_pinglunView;
    UIImageView *_lineImageView;
}

+ (CGFloat)heightForCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;
- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;

@end
