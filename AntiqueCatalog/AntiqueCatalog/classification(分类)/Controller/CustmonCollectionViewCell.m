//
//  CustmonCollectionViewCell.m
//  TestUICollectionView
//
//  Created by cssweb on 16/4/5.
//  Copyright © 2016年 cssweb. All rights reserved.
//

#import "CustmonCollectionViewCell.h"

@implementation CustmonCollectionViewCell
- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self){
        _cellImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.bounds.size.width - 90, self.self.bounds.size.height/2 - 40, 80, 80)];
        _cellImageView.image = [UIImage imageNamed:@"bg"];
        [self.contentView addSubview:_cellImageView];
        
        _cellTitle = [[UILabel alloc] initWithFrame:CGRectMake(5, self.self.bounds.size.height/2 - 15,(_cellImageView.frame.origin.x  - 10), 30)];
        _cellTitle.textAlignment = NSTextAlignmentRight;
        _cellTitle.textColor = [UIColor blackColor];
        _cellTitle.font = [UIFont systemFontOfSize:15];
//        _cellTitle.backgroundColor = [UIColor purpleColor];
        [self.contentView addSubview:_cellTitle];
        
    }
    return self;
}
@end
