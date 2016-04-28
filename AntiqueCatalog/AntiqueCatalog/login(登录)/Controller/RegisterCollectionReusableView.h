//
//  RegisterCollectionReusableView.h
//  Collector
//
//  Created by 刘鹏 on 14/12/2.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterCollectionReusableView : UICollectionReusableView
{
    UILabel *_label;
}

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;

@end
