//
//  templateView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/21.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol templateViewDelegate <NSObject>

@optional
- (void)handTapVeiw:(UITapGestureRecognizer *)tap;

@end

@interface templateView : UIView

@property (nonatomic,strong)NSMutableArray *dataarray;

@property (nonatomic,assign)id <templateViewDelegate>delegate;

- (instancetype)initWithFrame:(CGRect)frame andWithmutbleArray:(NSMutableArray *)array;

- (void)goNumberofpages:(NSString *)string;

@end
