//
//  RegisterCollectionReusableView.m
//  Collector
//
//  Created by 刘鹏 on 14/12/2.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import "RegisterCollectionReusableView.h"

@implementation RegisterCollectionReusableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        _label.backgroundColor = HEADER_COLOR;
        _label.textColor = CONTENT_COLOR;
        _label.font = [UIFont systemFontOfSize:12];
        [self addSubview:_label];
    }
    return self;
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath
{
    _label.text = @"  推荐用户";
}

@end
