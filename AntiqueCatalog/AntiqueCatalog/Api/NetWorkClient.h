//
//  NetWorkClient.h
//  AntiqueCatalog
//
//  Created by Cangmin on 16/1/4.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "AFHTTPSessionManager.h"

@interface NetWorkClient : AFHTTPSessionManager

+ (instancetype)sharedClient;

@end
