//
//  NetWorkClientOne.h
//  AntiqueCatalog
//
//  Created by cssweb on 16/3/9.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"

@interface NetWorkClientOne : AFHTTPRequestOperationManager
+ (instancetype)sharedClient;

@end
