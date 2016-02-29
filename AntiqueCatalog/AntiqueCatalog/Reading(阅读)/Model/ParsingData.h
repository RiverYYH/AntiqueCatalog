//
//  ParsingData.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/19.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ParsingData : NSObject

@property (nonatomic,strong)NSMutableArray    *chapter_title;
@property (nonatomic,strong)NSMutableArray    *chapter_int;

/**
 *    解析拍卖图录的数据，对数据进行分页
 *
 *
 */
- (NSMutableArray *)AuctionfromtoMutable:(NSArray *)array;

/**
 *    @author huihao, 16-01-21 23:01:28
 *
 *    解析带章节艺术图录的数据
 */
- (NSMutableArray *)YesChapterAuctionfromtoMutable:(NSArray *)array;

@end
