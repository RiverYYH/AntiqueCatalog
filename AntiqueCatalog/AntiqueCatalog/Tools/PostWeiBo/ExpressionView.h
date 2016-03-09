//
//  ExpressionView.h
//  Class_iPhone
//
//  Created by JingXiaoLiang on 13-3-7.
//
//

#import <UIKit/UIKit.h>

@protocol ExpressionViewDelegate <NSObject>

-(void)selectedFacialView:(NSString*)str;

@end

@interface ExpressionView : UIView

@property(nonatomic,assign)id<ExpressionViewDelegate> delegate;

-(void)loadFacialView:(int)page size:(CGSize)size;

@end
