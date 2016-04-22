//
//  DownFileMannger.m
//  AntiqueCatalog
//
//  Created by yangyonghe on 16/4/16.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "DownFileMannger.h"
#import "ASIFormDataRequest.h"
#import "FMDB.h"
#import "MF_Base64Additions.h"

#define FileSavePath [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"]

@implementation DownFileMannger
static DownFileMannger *downLoadManage = nil;

+ (DownFileMannger *)DefaultManage{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        downLoadManage = [[DownFileMannger alloc] init];
        
    });

    return downLoadManage;
}
-(id)init{
    if ( self = [super init] ){
    
    }
    return self;
}

//创建队列
- (void)createQuue {
    
    if (self.netWorkQueue == nil) {
        
        ASINetworkQueue   *que = [[ASINetworkQueue alloc] init];
        self.netWorkQueue = que;
        
        [self.netWorkQueue reset];
        [self.netWorkQueue setShouldCancelAllRequestsOnFailure:NO];

        [self.netWorkQueue setDelegate:self];
        [self.netWorkQueue setShowAccurateProgress:YES];
        [self.netWorkQueue setMaxConcurrentOperationCount:10];
        [self.netWorkQueue setQueueDidFinishSelector:@selector(queueFinished:)];
        [self.netWorkQueue setRequestDidFailSelector:@selector(requestFailed:)];

//        [self.netWorkQueue setRequestDidFinishSelector:@selector(imageFetchCompeleted:)];
//        [self.netWorkQueue setRequestDidFailSelector:@selector(imageFetchFailed:)];
//        [self.netWorkQueue go];
    }

}

-(void)dowImageUrl:(NSString*)imageUrl withSavePath:(NSString*)downloadPath withTempPath:(NSString*)temPath withTag:(int)tag withImageId:(NSString*)imageId withFileId:(NSString*)filedId withFileName:(NSString*)filename {
    
    NSURL *url = [NSURL URLWithString:imageUrl];
    
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.delegate = self;
    [request setDownloadDestinationPath:downloadPath];
    [request setDownloadProgressDelegate:self];
    //[request setTemporaryFileDownloadPath:temPath];
    request.allowResumeForFileDownloads = YES;
    NSMutableDictionary *  userInfo = [NSMutableDictionary dictionary];
    userInfo[@"FileId"] = filedId;
    userInfo[@"FileName"] = filename;
    userInfo[@"imgeId"] = imageId;
    userInfo[@"imageUrl"] = imageUrl;
    request.tag = tag;
    [request setUserInfo:userInfo];
    [self.netWorkQueue addOperation:request];
}

/*
- (void)startDownLoadFileByFileUrl:(NSString *)imageUrl downLoadingIndex:(int)index withSavePath:(NSString*)savePath withTempPath:(NSString*)tempPath{
    NSURL *url = [NSURL URLWithString:imageUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.delegate = self;
    [request setDownloadDestinationPath:savePath];
//    　[request setDownloadDestinationPath:savePath];
    [request setDownloadProgressDelegate:self];
    request.allowResumeForFileDownloads = YES;

    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"bookID",nil]];
    [self.netWorkQueue addOperation:request];


}
*/
#pragma mark ASIHTTPRequestDelegate method
//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小，可以显示下载进度多少字节
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    
    //下载新任务前清空上一个任务下载的数据量
    self.DidDownLoadLenth = 0;
    
    double fileLenth = [[responseHeaders valueForKey:@"Content-Length"] doubleValue];
    self.fileSiz = fileLenth;
//    NSLog(@"bbbbbbbbbbbbbbb");

}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    self.DidDownLoadLenth += bytes;
//    NSLog(@"aaaaaaaaaaaaaaaa");
//    if ([self.delegate respondsToSelector:@selector(DownLoadManageDownAsiLoadingByid:withDownLoadDataProgress:)]) {
//        double progress = self.DidDownLoadLenth / self.fileSiz;
//        [self.delegate DownLoadManageDownAsiLoadingByid:bookid withDownLoadDataProgress:progress];
//    }
}

//ASIHTTPRequestDelegate,下载完成时,执行的方法


- (void)requestFinished:(ASIHTTPRequest *)request {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //NSLog(@"cout==%d",self.netWorkQueue.requestsCount);
        FMDatabaseQueue *queue = [Api getSharedDatabaseQueue];
        [queue inDatabase:^(FMDatabase * _db) {
            NSDictionary * userDict = request.userInfo;
            NSString * fileId = userDict[@"FileId"];
            
            NSString * fileName = userDict[@"FileName"];
            NSString *imgeId = userDict[@"imgeId"];
            NSString * imageUrl = userDict[@"imageUrl"];
            [_db open];
            NSString * tableImageName = [NSString stringWithFormat:@"%@_%@",DOWNFILEIMAGE_NAME,fileId];
            
            FMResultSet * tempRs = [Api queryResultSetWithWithDatabase:_db AndTable:tableImageName AndWhereName:DOWNFILEIMAGE_ID AndValue:imgeId];
            
            if([tempRs next]){
                //找到这条记录的话 把下载状态从NO 改为YES
                NSString *updateSql = [NSString stringWithFormat:
                                       @"UPDATE %@ SET  %@ = '%@' WHERE %@ = %@",
                                       tableImageName,DOWNFILEIMAGE_STATE,@"YES",DOWNFILEIMAGE_ID,imgeId];
                BOOL res = [_db executeUpdate:updateSql];
                if (!res) {
                    NSLog(@"error when update TABLE_ACCOUNTINFOS");
                } else {
                    
                }
                
            }else{
                //找不到的话 直接插入数据
                NSString *insertSql= [NSString stringWithFormat:
                                      @"INSERT INTO '%@' ('%@', '%@','%@','%@') VALUES ('%@', '%@','%@','%@' )",
                                      tableImageName,DOWNFILEID,DOWNFILEIMAGE_ID,DOWNFILEIMAGE_STATE,DOWNFILEIMAGE_URL,fileId,imgeId,@"YES",imageUrl];
                NSLog(@"-------------------------------%@",insertSql);
                BOOL res = [_db executeUpdate:insertSql];
                if (!res) {
                    NSLog(@"error when TABLE_ACCOUNTINFOS");
                } else {

                }
                
            }
            [_db close];
            
            [_db open];
            FMResultSet * resTwo = [Api queryTableIALLDatabase:_db AndTableName:tableImageName];
            NSString* countStr = [NSString stringWithFormat:@"select count(*) from %@",tableImageName];
            NSUInteger count = [_db intForQuery:countStr];
            //            NSLog(@"数据库总数目:%d",count);
            
            BOOL isFinish = YES;
            int isHaveDown = 0;
            while([resTwo next]){
                NSString* imageState =[resTwo objectForColumnName:DOWNFILEIMAGE_STATE];
                if ([imageState isEqualToString:@"NO"]) {
                    isFinish = NO;
                }else{
                    isHaveDown ++;
                    //NSLog(@"request.tan = %ld   isHaveDown == %d",(long)request.tag,isHaveDown);
                }
            }
            [_db close];
            
            
            if (isFinish) {
                NSLog(@"isHaveDown == %d",isHaveDown);
                [_db open];
                FMResultSet * tempRsOne = [Api queryResultSetWithWithDatabase:_db AndTable:DOWNTABLE_NAME AndWhereName:DOWNFILEID AndValue:fileId];
                
                if([tempRsOne next]){
                    NSString *updateSql = [NSString stringWithFormat:
                                           @"UPDATE %@ SET  %@ = '%@' WHERE %@ = %@",
                                           DOWNTABLE_NAME,DOWNFILE_TYPE,@"1",DOWNFILEID,fileId];
                    BOOL res = [_db executeUpdate:updateSql];
                    if (!res) {
                        NSLog(@"error when update TABLE_ACCOUNTINFOS");
                    } else {
                        //                        NSLog(@"success to update TABLE_ACCOUNTINFOS");
                    }
                    NSString * prectstrOne = [NSString stringWithFormat:@"%0.2f%%",((float)isHaveDown/count) * 100];
                    
                    
                    NSString *updateSqlM = [NSString stringWithFormat:
                                            @"UPDATE %@ SET  %@ = '%@',%@ = '%@' WHERE %@ = %@",
                                            DOWNTABLE_NAME,DOWNFILE_TYPE,@"1",DOWNFILE_Progress,prectstrOne,DOWNFILEID,fileId];
                    BOOL resM = [_db executeUpdate:updateSqlM];
                    if (!resM) {
                        NSLog(@"error when update TABLE_ACCOUNTINFOS");
                    } else {
                        
                        
                    }
                    
                    
                }
                
                [_db close];
                
                
                
            }else{
                [_db open];
                NSString * prectstrOne = [NSString stringWithFormat:@"%0.2f%%",((float)isHaveDown/count) * 100];
                
                FMResultSet * tempRsOne = [Api queryResultSetWithWithDatabase:_db AndTable:DOWNTABLE_NAME AndWhereName:DOWNFILEID AndValue:fileId];
                
                if([tempRsOne next]){
                    
                    NSString *updateSql = [NSString stringWithFormat:
                                           @"UPDATE %@ SET %@ = '%@', %@ = '%@' WHERE %@ = %@",
                                           DOWNTABLE_NAME,DOWNFILE_TYPE,@"3",DOWNFILE_Progress,prectstrOne,DOWNFILEID,fileId];
                    BOOL res = [_db executeUpdate:updateSql];
                    if (!res) {
                        NSLog(@"error when update TABLE_ACCOUNTINFOS");
                    } else {
                        //                        NSLog(@"success to update TABLE_ACCOUNTINFOS");
                    }
                    
                    
                }
                [_db close];
                
            }
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                NSMutableDictionary * usDict = [NSMutableDictionary dictionary];
                if (count > 30 ) {
                    if ( isHaveDown % 10 == 0) {
                        usDict[@"ProgreValue"] = [NSString stringWithFormat:@"%0.2f",(float)isHaveDown/count];
                        usDict[@"FiledId"] = [NSString stringWithFormat:@"%@",fileId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDownList" object:nil userInfo:usDict];
                        
                    }
                }else{
//                    if ( isHaveDown % 5 == 0) {
                        usDict[@"ProgreValue"] = [NSString stringWithFormat:@"%0.2f",(float)isHaveDown/count];
                        usDict[@"FiledId"] = [NSString stringWithFormat:@"%@",fileId];
                        [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDownList" object:nil userInfo:usDict];
                        
//                    }
                }
               
//                NSLog(@"ddddd: %d %d",count, isHaveDown);

                if (isHaveDown == count) {
                    usDict[@"ProgreValue"] = [NSString stringWithFormat:@"%0.2f",(float)isHaveDown/count];
                    usDict[@"FiledId"] = [NSString stringWithFormat:@"%@",fileId];
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"AddDownList" object:nil userInfo:usDict];

                  
                }
                
                if (self.netWorkQueue.requestsCount == 0 && isFinish) {
                    NSLog(@"kkkkkkkkkkkkkkkkkkkkk");
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownNextFiled" object:self userInfo:nil];
                    self.netWorkQueue = nil;

                }
                
      
            });
        }];
  

    });
    


}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    // You could release the queue here if you wanted
    if ([self.netWorkQueue requestsCount] == 0) {
        self.netWorkQueue = nil;
    }
//    NSLog(@"")
    NSLog(@"Request failed");
    [self.netWorkQueue addOperation:request];
}


- (void)queueFinished:(ASINetworkQueue *)queue
{
    // You could release the queue here if you wanted
//    NSDictionary * dict = queue.userInfo;
    if ([self.netWorkQueue requestsCount] == 0) {
//        self.netWorkQueue = nil;
//        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:0.05];

       
    
    }
    
    NSLog(@"Queue finished");

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"DownNextFiled" object:self userInfo:nil];
//    self.netWorkQueue = nil;

    
}



@end
