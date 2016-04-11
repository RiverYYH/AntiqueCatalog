//
//  UIDraw.m
//  licai
//
//  Created by hxf on 15/7/1.
//
//

#import "UIDraw.h"

@implementation UIDraw


+(UIDraw *)draw{
    static dispatch_once_t once;
    static UIDraw *mInstance = nil;
    dispatch_once( &once, ^{ mInstance = [[UIDraw alloc] init]; } );
    return mInstance;
}

+(void)drawCharacterInCircle:(NSDictionary *)dict{
    CGFloat fontSize = [dict[ @"fontSize"] floatValue];
    CGRect rect;
    [dict[@"rectDraw"] getValue:&rect];
    CGColorRef bgColor;
    [dict[@"bgColor"] getValue:&bgColor];
    NSString *strShow = dict[@"strShow"];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetAlpha(context, .8);
    
    
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetFillColorWithColor(context, bgColor);
    CGContextSetLineWidth(context, 1.0);
    CGContextAddArc(context, rect.size.width/2, rect.size.height/2, rect.size.width/2-1.5, 0, 2*M_PI, 0);
    CGContextDrawPath(context, kCGPathFill);
    
    // 文字1.0透明度
//    CGContextSetAlpha(context, 1.0);
    CGContextSetShadowWithColor(context, CGSizeMake(0, -1), 1, [[UIColor whiteColor] CGColor]);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    UIFont *ft = [UIFont systemFontOfSize:fontSize];
    CGSize size = [strShow sizeWithFont:ft
                    constrainedToSize:rect.size
                        lineBreakMode:(UILineBreakModeWordWrap)];
    float x_pos = (rect.size.width - size.width) / 2;
    float y_pos = (rect.size.height - size.height) /2;
    [strShow drawAtPoint:CGPointMake(rect.origin.x + x_pos, rect.origin.y + y_pos) withFont:ft];
}

+(void)drawCharacterInRectangle:(NSDictionary *)dict{
    CGFloat fontSize = [dict[ @"fontSize"] floatValue];
    CGRect rect;
    [dict[@"rectDraw"] getValue:&rect];
    CGColorRef bgColor;
    [dict[@"bgColor"] getValue:&bgColor];
    NSString *strShow = dict[@"strShow"];
    
    //圆角rectangle
    CGFloat radius = 7.0;
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, bgColor);
    CGFloat minx = CGRectGetMinX(rect), midx = CGRectGetMidX(rect), maxx = CGRectGetMaxX(rect);
    CGFloat miny = CGRectGetMinY(rect), midy = CGRectGetMidY(rect), maxy = CGRectGetMaxY(rect);
//    CGContextSetAlpha(context, 1);
    CGContextMoveToPoint(context, minx, midy);
    CGContextAddArcToPoint(context, minx, miny, midx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, midy, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextAddArcToPoint(context, minx, maxy, minx, midy, radius);
    CGContextClosePath(context);
    CGContextDrawPath(context, kCGPathFill);
    

    // 文字1.0透明度
 //   CGContextSetAlpha(context, 1);
    CGContextSetFillColorWithColor(context, [[UIColor whiteColor] CGColor]);
    
    rect.origin.x += offsetWidth/2;
    rect.origin.y += offsetHeight/2;
    rect.size.width -= offsetWidth;
    rect.size.height -= (offsetHeight-1);
    
    [strShow drawInRect: rect withFont: [UIFont systemFontOfSize:fontSize] lineBreakMode:NSLineBreakByClipping
     alignment: NSTextAlignmentCenter];
}

@end
