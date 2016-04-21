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
#import "FMDB.h"
#import "MF_Base64Additions.h"

@interface DownFileMannger : NSObject{

}
@property (nonatomic)double fileSiz; //文件全部大小
@property (nonatomic)long long DidDownLoadLenth; //已经下载的文件大小
@property (nonatomic,strong)ASINetworkQueue *netWorkQueue;
@property (nonatomic,strong) NSArray * dataList;
@property (nonatomic,strong) NSString  * fileId;
@property (nonatomic,strong) NSString * fileName;

+ (DownFileMannger *)DefaultManage;
- (void)createFilePath;
-(void)createQuue;

- (NSString *)productFileFullPathWithSubDirectory:(NSString *)subDir fileName:(NSString *) fileName;
-(void)dowImageUrl:(NSString*)imageUrl withSavePath:(NSString*)downloadPath withTag:(int)tag withImageId:(NSString*)imageId withFileId:(NSString*)filedId withFileName:(NSString*)filename;

- (void)startDownLoadFileByFileUrl:(NSString *)imageUrl downLoadingIndex:(int)index withSavePath:(NSString*)savePath;

@end
