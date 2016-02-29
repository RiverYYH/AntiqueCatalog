//
//  TabbarScrollView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/12.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol TabbarScrollViewDelegate <NSObject>

@optional
- (void)hanTabbarIndexPath:(NSInteger)indexPath;

@end



@interface TabbarScrollView : UIScrollView

@property (nonatomic,assign)CGFloat Height;
@property (nonatomic,strong)NSArray *array;

@property (nonatomic,assign)id <TabbarScrollViewDelegate>Tabbardelegate;
- (instancetype)initWithheight:(CGFloat)height andWitharray:(NSArray *)array;
- (void)btnClickByScrollWithIndex:(NSInteger)index;

@end
