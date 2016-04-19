//
//  DownFileMannger.m
//  AntiqueCatalog
//
//  Created by yangyonghe on 16/4/16.
//  Copyright © 2016年 Cangmin. All rights reserved.
//

#import "DownFileMannger.h"
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
- (void)createFilePath {
    NSString *path = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    //初始化临时文件路径
    NSString *folderPath = [path stringByAppendingPathComponent:@"/DownLoad/temp"];
    //创建文件管理器
    NSFileManager *fileManager = [NSFileManager defaultManager];
    //判断temp文件夹是否存在
    BOOL fileExists = [fileManager fileExistsAtPath:folderPath];
    
    if (!fileExists) {//如果不存在说创建,因为下载时,不会自动创建文件夹
        [fileManager createDirectoryAtPath:folderPath
               withIntermediateDirectories:YES
                                attributes:nil
                                     error:nil];
    }

}

- (NSString *) createDirectoryOnDocumentWithSubDirectory:(NSString *)subDir{
    //在~/Document目录下创建一个子目录
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *screenshotDirectory = [documentsDirectory stringByAppendingPathComponent:subDir];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSError *error;
    if (![fm createDirectoryAtPath: screenshotDirectory withIntermediateDirectories: YES attributes:nil error: &error]) {
        //如果创建目录失败则直接returns
        return nil;
    }
    return screenshotDirectory;
}

- (NSString *)productFileFullPathWithSubDirectory:(NSString *)subDir fileName:(NSString *) fileName{
    NSString* screenshotDirectory = [self createDirectoryOnDocumentWithSubDirectory:subDir];
    if (nil == screenshotDirectory) {
        return nil;
    }
    NSString *fileFullPath = [screenshotDirectory stringByAppendingPathComponent:fileName];
    return fileFullPath;
}

- (void)createQuue {
    
    if (self.netWorkQueue == nil) {
        
        ASINetworkQueue   *que = [[ASINetworkQueue alloc] init];
        self.netWorkQueue = que;
        
        [self.netWorkQueue reset];
        [self.netWorkQueue setShowAccurateProgress:YES];
        [self.netWorkQueue setMaxConcurrentOperationCount:1];
        [self.netWorkQueue go];
    }

}


- (void)downloadFileWithOption:(NSDictionary *)paramDic
                 withInferface:(NSString*)requestURL
                     savedPath:(NSString*)savedPath
               downloadSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               downloadFailure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure
                      progress:(void (^)(float progress))progress{
    
    
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *request =[serializer requestWithMethod:@"post" URLString:requestURL parameters:paramDic error:nil];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    [operation setOutputStream:[NSOutputStream outputStreamToFileAtPath:savedPath append:NO]];
    [operation setDownloadProgressBlock:^(NSUInteger bytesRead, long long totalBytesRead, long long totalBytesExpectedToRead) {
        float p = (float)totalBytesRead / totalBytesExpectedToRead;
        progress(p);
        NSLog(@"download：%f", (float)totalBytesRead / totalBytesExpectedToRead);
        
    }];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        success(operation,responseObject);
        NSLog(@"下载成功");
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        success(operation,error);
        
        NSLog(@"下载失败%@",[error localizedDescription]);
        
    }];
    
    [operation start];

}

- (void)startDownLoadFileByFileUrl:(NSString *)imageUrl downLoadingIndex:(int)index withSavePath:(NSString*)savePath{
    NSURL *url = [NSURL URLWithString:imageUrl];
    ASIHTTPRequest *request = [[ASIHTTPRequest alloc] initWithURL:url];
    request.delegate = self;
    [request setDownloadDestinationPath:savePath];
    [request setDownloadProgressDelegate:self];
    [request setUserInfo:[NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithInt:index],@"bookID",nil]];
    [self.netWorkQueue addOperation:request];


}

#pragma mark ASIHTTPRequestDelegate method
//ASIHTTPRequestDelegate,下载之前获取信息的方法,主要获取下载内容的大小，可以显示下载进度多少字节
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders {
    
    //下载新任务前清空上一个任务下载的数据量
    self.DidDownLoadLenth = 0;
    
    double fileLenth = [[responseHeaders valueForKey:@"Content-Length"] doubleValue];
    self.fileSiz = fileLenth;
    int bookid = [[request.userInfo objectForKey:@"bookID"] intValue];
    NSLog(@"bbbbbbbbbbbbbbb");

}

- (void)request:(ASIHTTPRequest *)request didReceiveBytes:(long long)bytes {
    
    int bookid = [[request.userInfo objectForKey:@"bookID"] intValue];
    self.DidDownLoadLenth += bytes;
    NSLog(@"aaaaaaaaaaaaaaaa");
//    if ([self.delegate respondsToSelector:@selector(DownLoadManageDownAsiLoadingByid:withDownLoadDataProgress:)]) {
//        double progress = self.DidDownLoadLenth / self.fileSiz;
//        [self.delegate DownLoadManageDownAsiLoadingByid:bookid withDownLoadDataProgress:progress];
//    }
}

//ASIHTTPRequestDelegate,下载完成时,执行的方法
- (void)requestFinished:(ASIHTTPRequest *)request {
    
    int bookid = [[request.userInfo objectForKey:@"bookID"] intValue];
    NSLog(@"rrrrrrrrrrrrrr");
//    if ([self.delegate respondsToSelector:@selector(DownLoadManageaSIdidFinishDownLoadByid:)]) {
//        [self.delegate DownLoadManageaSIdidFinishDownLoadByid:bookid];
//    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    NSLog(@"dddddddddddddddddd");
}

@end
