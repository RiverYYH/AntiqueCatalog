//
//  NotificationTableViewCell.m
//  AntiqueCatalog
//
//  Created by Cangmin on 16/2/20.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "NotificationTableViewCell.h"

@implementation NotificationTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        //选中无状态
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor clearColor];
        
        UIView *backView = [[UIView alloc] initWithFrame:CGRectMake(0, 12, UI_SCREEN_WIDTH, 88)];
        backView.backgroundColor = [UIColor whiteColor];
        [self.contentView addSubview:backView];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 7, 100, 20)];
        _titleLabel.font = [UIFont systemFontOfSize:16.0];
        _titleLabel.textColor = Essential_Colour;
        [backView addSubview:_titleLabel];
        
        _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(UI_SCREEN_WIDTH-100-12, 7, 100, 20)];
        _timeLabel.font = [UIFont systemFontOfSize:Catalog_Cell_info_Font];
        _timeLabel.textAlignment = NSTextAlignmentRight;
        _timeLabel.textColor = Deputy_Colour;
        [backView addSubview:_timeLabel];
        
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(12, 27, UI_SCREEN_WIDTH-24, 56)];
        _contentLabel.numberOfLines = 0;
        _contentLabel.font = [UIFont systemFontOfSize:16.0];
        _contentLabel.textColor = Essential_Colour;
        [backView addSubview:_contentLabel];
    }
    return self;
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    _titleLabel.text = [data objectForKey:@"name"];
    _timeLabel.text = [UserModel formateTime:[[data objectForKey:@"data"] objectForKey:@"ctime"] andishour:YES];
    _contentLabel.text = [NSString stringWithFormat:@"    %@",[[data objectForKey:@"data"] objectForKey:@"title"]];
}

@end

