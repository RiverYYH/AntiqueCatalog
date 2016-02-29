//
//  ScreeningView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/23.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ScreeningViewDelegate <NSObject>

@optional
- (void)sure:(NSMutableDictionary *)dic andWithint:(NSInteger)integer;
- (void)sure_paimai:(NSMutableDictionary *)dic andWithint:(NSInteger)integer;

@end

@interface ScreeningView : UIView

@property (nonatomic,assign)id <ScreeningViewDelegate>delegate;
@property (nonatomic,strong)NSMutableArray *titleArray;
@property (nonatomic,strong)NSMutableArray *author;
@property (nonatomic,strong)NSMutableArray *city;
- (void)reloadtable;
- (void)reloadaution;
@end
