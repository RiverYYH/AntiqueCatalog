//
//  UserTableViewCell.h
//  Collector
//
//  Created by 刘鹏 on 14/11/17.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, UserCellType)
{
    UserCellTypeNormal = 0,
    UserCellTypeBlack,
    UserCellTypeUnion,
    UserCellTypeAttent,
    UserCellTypeFans,
    UserCellTypeNear
};


@protocol UserTableViewCellDelegate <NSObject>
@optional
- (void)attentionButtonClicked:(NSIndexPath *)indexPath;
-(void)showUserProfileByName:(NSString *)name;

@end

@interface UserTableViewCell : UITableViewCell
{
    UIImageView *_userFaceImageView;
    UIImageView *_userfanceV;
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIButton *_attentionButton;
    UIButton *_jiechuButton;

    NSIndexPath *_indexPath;
}

@property (assign,nonatomic)id<UserTableViewCellDelegate> delegate;

+ (CGFloat)heightForCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;
- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath andUserCellType:(UserCellType)userCellType;

@end