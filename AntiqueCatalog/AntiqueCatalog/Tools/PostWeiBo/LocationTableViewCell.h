//
//  LocationTableViewCell.h
//  RiseClub
//
//  Created by liuxiaoqing on 14-9-26.
//  Copyright (c) 2014年 huweihong. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LocationTableViewCell : UITableViewCell
{
    UILabel *schoolName;
    UILabel *schoolAddress;
    UIImageView *headImageView;
    UIButton *selectedBtn;
}
-(void)updateCell:(NSDictionary *)dic andIndex:(NSInteger )index andSelectIndex:(NSInteger)selectIndex;
-(void)updateCell1:(NSString *)str andIndex:(NSInteger )index andSelectIndex:(NSInteger)selectIndex;
@end
