//
//  RegisterCollectionViewCell.h
//  Collector
//
//  Created by 刘鹏 on 14/12/2.
//  Copyright (c) 2014年 刘鹏. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RegisterCollectionViewCell;
@protocol RegisterCollectionViewCellDelegate <NSObject>

- (void)registerCollectionViewCell:(RegisterCollectionViewCell *)registerCollectionViewCell buttonClicked:(BOOL)selected andIndexPath:(NSIndexPath *)indexPath;

@end

@interface RegisterCollectionViewCell : UICollectionViewCell
{
    UIImageView *_registerImageView;
    UILabel *_registerLabel;
    
    NSIndexPath *_indexPath;
}

@property (assign,nonatomic)id<RegisterCollectionViewCellDelegate> delegate;
@property (strong,nonatomic)UIButton *registerButton;

- (void)updateCellWithData:(NSDictionary *)data andIndexPath:(NSIndexPath *)indexPath;

@end
