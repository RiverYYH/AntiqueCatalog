//
//  LocationTableViewCell.m
//  RiseClub
//
//  Created by liuxiaoqing on 14-9-26.
//  Copyright (c) 2014年 huweihong. All rights reserved.
//

#import "LocationTableViewCell.h"

@implementation LocationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        [self makeUI];
    }
    return self;
}
-(void)makeUI
{
	headImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 15, 25, 30)];
    headImageView.tag=999;
    [self.contentView addSubview:headImageView];
    

    schoolName=[[UILabel alloc]initWithFrame:CGRectMake(50, 3, 220, 30)];
    schoolName.font=[UIFont boldSystemFontOfSize:16];
    schoolName.tag=111;
    [self.contentView addSubview:schoolName];
 
    schoolAddress=[[UILabel alloc]initWithFrame:CGRectMake(50, 27, 220, 30)];
    schoolAddress.textColor=[UIColor grayColor];
    schoolAddress.font=[UIFont systemFontOfSize:15];
    schoolAddress.tag=11;
    [self.contentView addSubview:schoolAddress];
	
    
   selectedBtn=[UIButton buttonWithType:UIButtonTypeCustom];
    selectedBtn.frame=CGRectMake(UI_SCREEN_WIDTH-10-25, 15, 25, 30);
    selectedBtn.tag=99;
    [self.contentView addSubview:selectedBtn];
    
    
}
-(void)updateCell:(NSDictionary *)dic andIndex:(NSInteger )index andSelectIndex:(NSInteger)selectIndex
{
    [headImageView setImage:[UIImage imageNamed:@"ico_position_blue"]];
    schoolName.text=[dic objectForKey:@"name"];
    schoolAddress.text=[dic objectForKey:@"address"];
    [selectedBtn setBackgroundImage:nil forState:0];
    
    if (index==selectIndex) {
        [headImageView setImage:[UIImage imageNamed:@"ico_position_red"]];
        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"ico_sel_big"] forState:0];
    }
   
}
-(void)updateCell1:(NSString *)str andIndex:(NSInteger )index andSelectIndex:(NSInteger)selectIndex
{
    if (index==selectIndex) {
        [headImageView setImage:[UIImage imageNamed:@"ico_position_red"]];
        [selectedBtn setBackgroundImage:[UIImage imageNamed:@"ico_sel_big"] forState:0];
	}else{
		[headImageView setImage:[UIImage imageNamed:@"ico_position_blue"]];
	}
    schoolName.text=str;
    schoolAddress.text=@"当前所在区域";
}
- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
