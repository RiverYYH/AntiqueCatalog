//
//  cimmenView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/24.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol cimmenViewDelegate <NSObject>

-(void)TextForComment:(NSString *)commStr;

@end

@interface cimmenView : UIView

@property (nonatomic,assign)id <cimmenViewDelegate>delegate;
@property (nonatomic,strong)UITextView *textView;
@property (nonatomic,strong)UIButton   *button;
@property (nonatomic,strong)UILabel    *label;

@end
