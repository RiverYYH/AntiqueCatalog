//
//  downView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/25.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol downViewDelegate <NSObject>

@optional
-(void)menuo:(NSInteger)integer;

@end

@interface downView : UIView
@property (nonatomic,assign)id <downViewDelegate>delegate;
@end
