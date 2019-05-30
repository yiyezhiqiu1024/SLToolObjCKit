//
//  SLDownloadTool.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/5/30.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLDownloadTool.h"
#import "SLFileTool.h"

#define kTempPath NSTemporaryDirectory()
#define kCachesPath NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject

@interface SLDownloadTool () <NSURLSessionDataDelegate>
{
    NSInteger _tmpSize;
    NSInteger _totalSize;
}

/** 文件正在下载路径 */
@property (copy, nonatomic) NSString *downloadingPath;
/** 文件下载完成路径 */
@property (copy, nonatomic) NSString *downloadedPath;

@property (strong, nonatomic) NSURLSession *session;

@end

@implementation SLDownloadTool

- (void)sl_downloadWithURL:(NSURL *)url {
    
    // 1.文件存在
    // 1.1.文件名
    NSString *fileName = url.lastPathComponent;
    
    self.downloadingPath = [kTempPath stringByAppendingPathComponent:fileName];
    self.downloadedPath = [kCachesPath stringByAppendingPathComponent:fileName];

    if ([SLFileTool sl_fileExist:self.downloadedPath]) {
        // UNDO: 告诉外界，已经下载完成
        return;
    }
    
    // 2.检测：临时文件是否存在
    // 2.1.不存在
    if (![SLFileTool sl_fileExist:self.downloadingPath]) {
        // 从0字节开始请求资源
        [self downloadWithURL:url offset:0];
        return;
    }
    
    // 2.2.存在：以当前的存在文件大小作为开始字节，请求资源
    // 获取本地文件大小
    _tmpSize = [SLFileTool sl_fileSize:self.downloadingPath];
    [self downloadWithURL:url offset:_tmpSize];
    
}

#pragma mark - NSURLSessionDataDelegate
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
    
    // 比对 本地大小 和 总大小
    if (_tmpSize == _totalSize) {
        // 移动到下载完成文件夹
        [SLFileTool sl_moveFile:self.downloadingPath toPath:self.downloadedPath];
    }
    
    if (_tmpSize > _totalSize) {
        // 1.取消请求
        completionHandler(NSURLSessionResponseCancel);
        // 2.删除临时缓存
        [SLFileTool sl_removeFile:self.downloadingPath];
        // 3.从0开始下载
        [self sl_downloadWithURL:response.URL];
    }
    
    // 继续接收数据
    completionHandler(NSURLSessionResponseAllow);
}

#pragma mark - Private methond
/**
 根据开始字节，请求资源

 @param url 资源路径
 @param offset 开始字节
 */
- (void)downloadWithURL:(NSURL *)url offset:(NSInteger)offset {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestReloadIgnoringLocalCacheData
                                                       timeoutInterval:0];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", (long long)offset] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *dataTask = [self.session dataTaskWithRequest:request];
    [dataTask resume];
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
