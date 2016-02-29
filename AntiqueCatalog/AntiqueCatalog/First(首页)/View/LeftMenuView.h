//
//  LeftMenuView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/6.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol LeftMenuViewDelegate <NSObject>

@optional

- (void)gologin;
- (void)golist:(NSIndexPath *)indexPath;

@end

@interface LeftMenuView : UIView

@property (nonatomic,assign)id <LeftMenuViewDelegate>delegate;
- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;
- (void)click;

@end
