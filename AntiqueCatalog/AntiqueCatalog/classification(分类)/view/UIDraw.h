//
//  UIDraw.h
//  licai
//
//  Created by hxf on 15/7/1.
//
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define offsetWidth 20
#define offsetHeight 20

@interface UIDraw : NSObject

+(void)drawCharacterInCircle:(NSDictionary *)dict;
+(void)drawCharacterInRectangle:(NSDictionary *)dict;

//单例
+(UIDraw *)draw;


@end
