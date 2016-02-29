//
//  UpView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/25.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol UpViewDelegate <NSObject>

@optional
-(void)backgo;
-(void)sharego;

@end

@interface UpView : UIView
@property (nonatomic,assign)id <UpViewDelegate>delegate;
@end
