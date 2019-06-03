//
//  SLAudioDownloader.m
//  SLToolObjCKit_Example
//
//  Created by CoderSLZeng on 2019/6/3.
//  Copyright © 2019 CoderSLZeng. All rights reserved.
//

#import "SLAudioDownloader.h"
#import "SLPlayerAudioFile.h"

@interface SLAudioDownloader ()<NSURLSessionDataDelegate>
/** 会话 */
@property (strong, nonatomic) NSURLSession *session;
/** 输出流 */
@property (strong, nonatomic) NSOutputStream *outputStream;

/** 资源 */
@property (strong, nonatomic) NSURL *URL;
@end

@implementation SLAudioDownloader

- (void)downloadWithURL:(NSURL *)URL offset:(long long)offset {
    [self cancelAndClean];
    
    self.URL = URL;
    self.offset = offset;
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:URL];
    [request setValue:[NSString stringWithFormat:@"bytes=%lld-", offset] forHTTPHeaderField:@"Range"];
    NSURLSessionDataTask *task = [self.session dataTaskWithRequest:request];
    [task resume];
}

#pragma mark - NSURLSessionDataDelegate
- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
didReceiveResponse:(NSHTTPURLResponse *)response
 completionHandler:(void (^)(NSURLSessionResponseDisposition disposition))completionHandler {
    
    self.totalSize = [response.allHeaderFields[@"Content-Length"] longLongValue];
    NSString *contentRangeStr = response.allHeaderFields[@"Content-Range"];
    if (contentRangeStr.length) {
        self.totalSize = [[contentRangeStr componentsSeparatedByString:@"/"].lastObject longLongValue];
    }
    
    self.MIMEType = response.MIMEType;
    
    self.outputStream = [NSOutputStream outputStreamToFileAtPath:[SLPlayerAudioFile tempFilePath:self.URL]
                                                          append:YES];
    [self.outputStream open];
    
    completionHandler(NSURLSessionResponseAllow);
}

- (void)URLSession:(NSURLSession *)session
          dataTask:(NSURLSessionDataTask *)dataTask
    didReceiveData:(NSData *)data {
    self.loadedSize += data.length;
    [self.outputStream write:data.bytes maxLength:data.length];
    
    if ([self.delegate respondsToSelector:@selector(downloading)]) {
        [self.delegate downloading];
    }
}
- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    
    [self.outputStream close];
    if (error) {
        NSLog(@"有错误");
        return;
    }
    
    if ([SLPlayerAudioFile tempFileSize:self.URL] == self.totalSize) {
        [SLPlayerAudioFile moveTempPathToCachePath:self.URL];
    }
}

#pragma mark - Private methond
- (void)cancelAndClean {
    [self.session invalidateAndCancel];
    self.session = nil;
    
    [SLPlayerAudioFile cleanTempFile:self.URL];
    self.loadedSize = 0;
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
