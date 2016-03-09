//
//  TopicListTableViewCell.h
//  藏民网
//
//  Created by Hong on 15/3/17.
//  Copyright (c) 2015年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, TopicListType){
    TopicListTypeSquare,
    TopicListTypeMyself,
    TopicListTypeMyAttention,
    TopicListTypeTopicPost
};

@class TopicListTableViewCell;

@protocol TopicListViewCellDelegate <NSObject>

- (void)topicListViewCell:(TopicListTableViewCell *)topicCell guanzhuButtonClickedWithIndexPath:(NSIndexPath *)indexPath;

@end

@interface TopicListTableViewCell : UITableViewCell

@property (nonatomic, assign) id<TopicListViewCellDelegate> delegate;

- (void)updateCellWithData:(NSDictionary *)dic andIndexPath:(NSIndexPath *)indexPath andTopicListType:(TopicListType)topicListType;
@end
