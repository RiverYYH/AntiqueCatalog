//
//  ShopNameView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/2/23.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol ShopNameViewDelegate <NSObject>

@optional
-(void)shopnamehan:(NSInteger)integer;

@end
@interface ShopNameView : UIView
@property (nonatomic,assign)id <ShopNameViewDelegate>delegate;
@end
