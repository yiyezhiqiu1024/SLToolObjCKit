//
//  SLDownloadTool.m
//  SLToolObjCKit
//
//  Created by CoderSLZeng on 2019/5/30.
//

#import "SLDownloadTool.h"
#import "SLFileTool.h"

#define kTempPath NSTemporaryDirectory()
#define kCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@interface SLDownloadTool () <NSURLSessionDataDelegate>
{
    NSInteger _tmpSize; // 记录文件临时下载大小
    NSInteger _totalSize; // 记录文件总大小
}

/** 文件正在下载路径 */
@property (copy, nonatomic) NSString *downloadingPath;
/** 文件下载完成路径 */
@property (copy, nonatomic) NSString *downloadedPath;
/** 下载会话 */
@property (strong, nonatomic) NSURLSession *session;
/** 输出流 */
@property (strong, nonatomic) NSOutputStream *outputStream;
/** 当前下载任务 */
@property (nonatomic, weak) NSURLSessionDataTask *dataTask;

@property (nonatomic, copy) DownloadInfoBlock infoBlock;
@property (nonatomic, copy) DownloadStateBlock stateBlock;
@property (nonatomic, copy) DownloadProgressBlock progressBlock;
@property (nonatomic, copy) DownloadSuccessBlock successBlock;
@property (nonatomic, copy) DownloadFailureBlock failureBlock;

@end

@implementation SLDownloadTool

#pragma mark - Public interface methond

- (void)downloadWithURL:(NSURL *)URL
                      info:(DownloadInfoBlock)info
                  progress:(DownloadProgressBlock)progress
                   success:(DownloadSuccessBlock)success
                   failure:(DownloadFailureBlock)failure {
    
    self.infoBlock = info;
    self.progressBlock = progress;
    self.successBlock = success;
    self.failureBlock = failure;
    
    [self downloadWithURL:URL];
}

- (void)downloadWithURL:(NSURL *)URL {
    
    // 内部实现
    // 1. 真正的从头开始下载
    // 2. 如果任务存在了, 继续下载
    
    // 0.当前任务，肯定存在
    if ([URL isEqual:self.dataTask.originalRequest.URL]) {
        // 判断当前状态，如果是暂停状态
        if (self.state == SLDownloadStatePause) {
            // 继续
            [self resumeDownload];
            return;
        }
    }
    
    [self cancelDownload];
    // 1.文件存在
    // 1.1.文件名
    NSString *fileName = URL.lastPathComponent;
    self.downloadingPath = [kTempPath stringByAppendingPathComponent:fileName];
    self.downloadedPath = [kCachesPath stringByAppendingPathComponent:fileName];

    if ([SLFileTool fileExist:self.downloadedPath]) {
        self.state = SLDownloadStateSuccess;
        return;
    }
    
    // 2.检测：临时文件是否存在
    // 2.1.不存在
    if (![SLFileTool fileExist:self.downloadingPath]) {
        // 从0字节开始请求资源
        [self downloadWithURL:URL offset:0];
        return;
    }
    
    // 2.2.存在：以当前的存在文件大小作为开始字节，请求资源
    // 获取本地文件大小
    _tmpSize = [SLFileTool fileSize:self.downloadingPath];
    [self downloadWithURL:URL offset:_tmpSize];
}

/**
 继续任务
 */
- (void)resumeDownload {
    if (self.dataTask && self.state == SLDownloadStatePause) {
        self.state = SLDownloadStateDownloading;
        [self.dataTask resume];
    }
}

- (void)pauseDownload {
    if (self.state == SLDownloadStateDownloading) {
        self.state = SLDownloadStatePause;
        [self.dataTask suspend];
    }
}

- (void)cancelDownload {
    self.state = SLDownloadStatePause;
    [self.session invalidateAndCancel];
    self.session = nil;
}

- (void)cancelDownloadAndCleanCaches {
    [self cancelDownload];
    [SLFileTool removeFile:self.downloadingPath];
}

#pragma mark - NSURLSessionDataDelegate
/**
 第一次接受到相应的时候调用(响应头, 并没有具体的资源内容)
 通过这个方法, 里面, 系统提供的回调代码块, 可以控制, 是继续请求, 还是取消本次请求
 
 @param session 会话
 @param dataTask 任务
 @param response 响应头信息
 @param completionHandler 系统回调代码块, 通过它可以控制是否继续接收数据
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSHTTPURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    // 取资源总大小
    // 1. 从  Content-Length 取出来 请求的大小 != 资源大小
    // 2. 如果 Content-Range 有, 应该从Content-Range里面获取
    _totalSize = [response.allHeaderFields[@"Content-Length"] integerValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length != 0) {
        _totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject integerValue];
    }
    
    // 传递给外界: 总打下 & 本地存储的文件路径
    if (self.infoBlock != nil) {
        self.infoBlock(_totalSize);
    }
    
    // 比对 本地大小 和 总大小
    if (_tmpSize == _totalSize) {
        // 1.取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        // 2.移动到下载完成文件夹
        [SLFileTool moveFile:self.downloadingPath toPath:self.downloadedPath];
        // 3.修改状态
        self.state = SLDownloadStateSuccess;
        return;
    }
    
    if (_tmpSize > _totalSize) {
        // 1.取消本次请求
        completionHandler(NSURLSessionResponseCancel);
        // 2.删除临时缓存
        [SLFileTool removeFile:self.downloadingPath];
        // 3.从0开始下载
        [self downloadWithURL:response.URL];
        return;
    }
    
    self.state = SLDownloadStateDownloading;
    // 确定开始下载数据
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:self.downloadingPath append:YES];
    [self.outputStream open];
    // 继续接收数据
    completionHandler(NSURLSessionResponseAllow);
}

/**
 当用户确定, 继续接受数据的时候调用
 
 @param session 会话
 @param dataTask 任务
 @param data 接受到的一段数据
 */
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {

    // 下载进度
    _tmpSize += data.length;
    self.progress = 1.0 * _tmpSize / _totalSize;
    [self.outputStream write:data.bytes maxLength:data.length];
}

/**
 请求完成时候调用
 请求完成的时候调用( != 请求成功/失败)
 @param session 会话
 @param task 任务
 @param error 错误
 */
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {

    [self.outputStream close];
    
    if (error) {
        self.state = (-999 == error.code) ? SLDownloadStatePause : SLDownloadStateFailure;
        return;
    }
    
    // 不一定是成功
    // 数据是肯定可以请求完毕
    // 判断, 本地缓存 == 文件总大小 {filename: filesize: md5:xxx}
    // 如果等于 => 验证, 是否文件完整(file md5 )
    [SLFileTool moveFile:self.downloadingPath toPath:self.downloadedPath];
    self.state = SLDownloadStateSuccess;
}

#pragma mark - Private methond
/**
 根据开始字节，请求资源

 @param url 资源路径
 @param offset 开始字节
 */
- (void)downloadWithURL:(NSURL *)URL offset:(NSInteger)offset {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:0];
    // 通过控制range, 控制请求资源字节区间
    [request setValue:[NSString stringWithFormat:@"bytes=%ld-", (long)offset] forHTTPHeaderField:@"Range"];
    // session 分配的task, 默认情况, 挂起状态
    self.dataTask = [self.session dataTaskWithRequest:request];
    [self resumeDownload];
}

#pragma mark - Setter
- (void)setState:(SLDownloadState)state {
    // 数据过滤
    if (_state == state) return;
    
    _state = state;
    
    if (self.stateBlock) {
        self.stateBlock(_state);
    }
    
    if (_state == SLDownloadStateSuccess && self.successBlock) {
        self.successBlock(self.downloadedPath);
    }
    
    if (_state == SLDownloadStateFailure && self.failureBlock) {
        self.failureBlock();
    }
}

- (void)setProgress:(NSInteger)progress {
    _progress = progress;
    if (self.progressBlock) {
        self.progressBlock(_progress);
    }
}

#pragma mark - Getter
- (NSURLSession *)session {
    if (!_session) {
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        _session = [NSURLSession sessionWithConfiguration:config delegate:self delegateQueue:[NSOperationQueue mainQueue]];
    }
    return _session;
}

@end
