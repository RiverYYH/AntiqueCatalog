//
//  MybookView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/7.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MybookViewDelegate <NSObject>

@optional

- (void)hanIndexPath:(NSIndexPath *)indexPath;

- (void)longhan;

@end
@interface MybookView : UIView

@property (nonatomic,assign)id <MybookViewDelegate>delegate;

-(void)loadMybookCatalogdata:(NSMutableArray *)array;

@end
