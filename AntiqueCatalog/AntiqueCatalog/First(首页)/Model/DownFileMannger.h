//
//  DownFileMannger.h
//  AntiqueCatalog
//
//  Created by yangyonghe on 16/4/16.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFHTTPRequestOperation.h"
#import "ASIHTTPRequest.h"
#import "ASINetworkQueue.h"

@interface DownFileMannger : NSObject
@property (nonatomic)double fileSiz; //文件全部大小
@property (nonatomic)long long DidDownLoadLenth; //已经下载的文件大小
@property (nonatomic,strong)ASINetworkQueue *netWorkQueue;

+ (DownFileMannger *)DefaultManage;
- (void)createFilePath;
-(void)createQuue;

- (NSString *)productFileFullPathWithSubDirectory:(NSString *)subDir fileName:(NSString *) fileName;
- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress;
- (void)startDownLoadFileByFileUrl:(NSString *)imageUrl downLoadingIndex:(int)index withSavePath:(NSString*)savePath;

@end
