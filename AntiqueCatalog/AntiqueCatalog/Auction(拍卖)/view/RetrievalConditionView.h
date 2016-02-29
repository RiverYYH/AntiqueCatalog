//
//  RetrievalConditionView.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/15.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Authordata.h"
#import "citydata.h"

@protocol RetrievalConditionViewDelegate <NSObject>

@optional
- (void)hanstate:(NSInteger)integer;
- (void)hanauthor:(id)obj;
- (void)hancity:(id)obj;
- (void)hanyear:(NSString *)obj andint:(NSInteger)integer;
- (void)hanmonth:(NSString *)obj andint:(NSInteger)integer;

@end

@interface RetrievalConditionView : UIView

@property (nonatomic,assign)id<RetrievalConditionViewDelegate>delegate;

@property (nonatomic,strong)NSMutableArray *authorArray;
@property (nonatomic,strong)NSMutableArray *cityArray;

+(instancetype)initWithauthor:(NSMutableArray *)authorArray andWithcity:(NSMutableArray *)cityArray;
-(instancetype)initWithauthor:(NSMutableArray *)authorArray andWithcity:(NSMutableArray *)cityArray;

@end
