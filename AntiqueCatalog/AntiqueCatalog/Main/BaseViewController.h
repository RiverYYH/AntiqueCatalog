//
//  BaseViewController.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/1.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseViewController : UIViewController
//{
//    UILabel *_titleLabel;
//    UIImageView *_imageViewIndex;
//    UIButton *_rightButton;
//    UIButton *_leftButton;
//    UIImageView *_titleImageView;
//}

@property (nonatomic,strong)UILabel     *titleLabel;
@property (nonatomic,strong)UIImageView *imageViewIndex;
@property (nonatomic,strong)UIButton    *rightButton;
@property (nonatomic,strong)UIButton    *leftButton;
@property (nonatomic,strong)UIImageView *titleImageView;

- (void)leftButtonClick:(id)sender;
- (void)rightButtonClick:(id)sender;

@end
