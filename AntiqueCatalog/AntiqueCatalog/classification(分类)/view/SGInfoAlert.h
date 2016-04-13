#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIDraw.h"

//#define kSGInfoAlert_fontSize       25
#define kSGInfoAlert_width          200
#define kMax_ConstrainedSize        CGSizeMake(200, 100)

typedef enum{
    charactersInCircle = 0,
    charactersInRectangle,
} SGCharactersShowType;

@interface SGInfoAlert : UIView{
    CGColorRef bgColor_;
    NSString *info_;
    CGSize fontSize_;
    float showTime;
    SGInfoAlert *infoAlert;
    SGCharactersShowType showType;
    float sizeFont;
}

// info为提示信息，frame为提示框大小，view是为消息框的superView
// vertical 为垂直方向上出现的位置 从 取值 0 ~ 1。
- (void)showInfo:(NSString*)info
         bgColor:(CGColorRef)color
          inView:(UIView*)view 
        vertical:(float)height
        showTime:(float)timeShow
        showType:(SGCharactersShowType)type
        fontSize:(float)sizeFont;

-(void)showInfo:(NSString *)info
        bgColor:(CGColorRef)color
        inView:(UIView *)view
        offsetY:(float)yOffset
        showTime:(float)timeShow
       fontSize:(float)sizeFont;

-(void)showInfo:(NSString *)info
        bgColor:(CGColorRef)color
         inView:(UIView *)view
       fontSize:(float)sizeFont;



//单例
+(SGInfoAlert *)alert;

@end
