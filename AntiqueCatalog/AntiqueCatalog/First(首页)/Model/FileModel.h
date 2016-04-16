//
//  FileModel.h
//  DownLoadDome
//
//  Created by chuliangliang on 13-12-23.
//  Copyright (c) 2013年 banvon. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FileModel : NSObject
@property (nonatomic,strong)NSString *name;
@property (nonatomic,strong)NSString *url;
@property (nonatomic,strong)NSNumber *isDownLoad;
@property (nonatomic,strong)NSNumber *progress;
@end
